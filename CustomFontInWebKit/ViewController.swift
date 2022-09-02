//
//  ViewController.swift
//  CustomFontInWebKit
//
//  Created by Nitin Bhatia on 02/09/22.
//

import UIKit
import WebKit

let x = """
<html>
        <head>
<script>
    var meta = document.createElement('meta');
    meta.setAttribute('name', 'viewport');
    meta.setAttribute('content', 'width=device-width - 40');
    meta.setAttribute('initial-scale', '0.5');
    meta.setAttribute('maximum-scale', '1.0');
    meta.setAttribute('minimum-scale', '0.5');
    meta.setAttribute('user-scalable', 'no');
    document.getElementsByTagName('head')[0].appendChild(meta);
</script>

<style>
                       body {
                                       font-size: '14px';
                                       font-family: 'Roboto';

                                   }

</style
        </head>
      <body style="margin:0">
<p>Hello</p><br/>
        <div>
          <p><strong><span lang=\"EN-GB\">Passage summary:</span></strong></p>\n<p><span lang=\"EN-GB\">The passage is about how Cetaceans adapt to life in the deep sea. Cetaceans—dolphins and whales—rely on sound more than any other sense to understand and navigate the deep sea. The evolutionary changes to the auditory equipment in dolphins and whales needed to be dramatic to accommodate the acoustic environment of the sea. Cetaceans have evolved to have a pocket of air inside each ear to enable them to locate the source of a sound. Other anatomical quirks also make the cetacean auditory equipment unique such as the shape of the tympanic membrane.</span></p>\n<p><strong><span lang=\"EN-GB\">Genre</span></strong><span lang=\"EN-GB\">: Science/Biology</span></p>\n<p><strong><span lang=\"EN-GB\">Number of words</span></strong><span lang=\"EN-GB\">: 505</span></p>\n<p><strong><span lang=\"EN-GB\">Type of question</span></strong><span lang=\"EN-GB\">: Main idea / Theme-based question</span></p>\n<p><span lang=\"EN-GB\">The author describes the evolutionary adaptations made by cetaceans in the deep sea and describes the changes. So, the primary purpose is to describe the changes.</span></p>\n<p><span lang=\"EN-GB\">Hence, A is the correct answer.</span></p>
        </div>
      </body>
"""

class ViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var web: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        web.loadHTMLString(x, baseURL: nil)
        web.navigationDelegate = self
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        guard let customFont = UIFont(name: "Roboto-Bold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        //to encode the font data in the app in the Base64
        
        
        let robotoFont = getDataString(ttf: "Roboto-Medium") //enter file name here which is under Resources>Fonts
        
        
        
        //embedded encoded font data in the Data URI scheme CSS
        
        //if format is otf then use data:font/otf;base64 and format('opentype');
        
        //font-family : can be any name like xyz, then in css of above html use the font-family with exact name
        
        //can be add in cssString or in html above
        //body {
        //        font-size: '14px';
        //        font-family: 'Roboto';
        //
        //    }
        
        let cssString = """
            
            @font-face {
            
                font-family: 'Roboto';
            
                src: url('data:font/ttf;base64,\(robotoFont)') format('truetype');
            
            }
            
            
            
            """
        
        let customFontJs = """

                var style = document.createElement('style');

                style.innerHTML = `\(cssString)`;

                document.head.appendChild(style);
"""
        //executes the JavaScript
        webView.evaluateJavaScript(customFontJs, completionHandler: nil)
    }
    
    
    func getDataString(ttf: String) -> String {
        
        let path = Bundle.main.path(forResource: ttf, ofType: "ttf")
        
        let url = URL(fileURLWithPath: path!)
        
        let data = try! Data(contentsOf: url)
        
        return data.base64EncodedString()
        
    }
    
}

