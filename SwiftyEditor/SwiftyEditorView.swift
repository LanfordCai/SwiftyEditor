//
//  SwiftyEditorView.swift
//  SwiftyEditor
//
//  Created by Lanford on 8/19/16.
//  Copyright © 2016 Lanford. All rights reserved.
//

import UIKit
import WebKit

class SwiftyEditorView: UIView {
    
    lazy private var webView: WKWebView = {
        let webView = WKWebView()
        webView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webView.backgroundColor = .whiteColor()
        
        return webView
    }()
    
    private(set) var contentHTML: String = "" {
        didSet {
            print("contentHTML didSet")
        }
    }
    
    private var editingEnableVar = true
    var editingEnabled: Bool {
        get {
            return isContentEditable()
        
        }
        set { setContentEditable(newValue) }
    }
    
    private(set) var placeholder: String = ""
    
    private var editorLoaded = false
    
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // MARK: Public Methods
    
    func focus() {
        webView.evaluateJavaScript("RE.focus();") { (result, error) in
            print("focus result \(result)")
        }
    }
    
    func bold() {
        webView.evaluateJavaScript("RE.setBold();") { (result, error) in
            print("bold result \(result)")
        }
    }
    
    func setHTML(html: String) {
        contentHTML = html
        if editorLoaded {
            let script = "RE.setHtml('\(escape(html))');"
            webView.evaluateJavaScript(script, completionHandler: { (result, error) in
                print("setHTML \(result)")
            })
            updateHeight()
        }
    }
    
    func getHTML(completion: (HTMLString: String?) -> Void) {
        webView.evaluateJavaScript("RE.getHtml();") { (result, error) in
            guard let HTMLString = result as? String else {
                completion(HTMLString: nil)
                return
            }
            completion(HTMLString: HTMLString)
        }
    }
    
    func getText(completion: (text: String?) -> Void) {
        webView.evaluateJavaScript("RE.getText();") { (result, error) in
            guard let text = result as? String else {
                completion(text: nil)
                return
            }
            completion(text: text)
        }
    }
    
    func setPlaceholderText(text: String) {
        placeholder = text
        let script = "RE.setPlaceholderText('\(escape(text))');"
        webView.evaluateJavaScript(script) { (result, error) in
            print("setPlaceholderText result \(result)")
        }
    }
    
    
    // MARK: Private Methods
    
    private func setup() {
        webView.frame = bounds
        webView.navigationDelegate = self
        webView.removeInputAccessoryView()
        
        addSubview(webView)
        
        if let path = NSBundle(forClass: SwiftyEditorView.self).pathForResource("swifty_editor", ofType: "html") {
            let url = NSURL(fileURLWithPath: path)
            webView.loadFileURL(url, allowingReadAccessToURL: url)
        }
    }
    
    private func updateHeight() {
        let script = "document.getElementById('editor').clientHeight;"
        webView.evaluateJavaScript(script) { (result, error) in
            if let height = result as? Int {
                print("height \(height)")
            }
        }
    }
    
    private func isContentEditable() -> Bool {
        if editorLoaded {
            
        } else {
            
        }
        // MARK:
        return true
    }
    
    private func setContentEditable(editable: Bool) {
        if editorLoaded {
            let value = editable ? "true" : "false"
            let script = "RE.editor.contentEditable = \(value);"
            webView.evaluateJavaScript(script, completionHandler: { (result, error) in
                print("setContentEditable \(result)")
            })
        } else {
            editingEnableVar = editable
        }
    }
    

    
    private func performCommand(method: String) {
        if method.hasPrefix("ready") {
            if !editorLoaded {
                editorLoaded = true
                setHTML(contentHTML)
                setContentEditable(editingEnableVar)
                setPlaceholderText(placeholder)
                //
            }
            updateHeight()
            
        } else if method.hasPrefix("input") {
            
        } else if method.hasPrefix("focus") {
            
        } else if method.hasPrefix("blur") {
            
        } else if method.hasPrefix("action/") {
            
        }
    }
    
    private func escape(string: String) -> String {
        let unicode = string.unicodeScalars
        var newString = ""
        for i in unicode.startIndex..<unicode.endIndex {
            let char = unicode[i]
            if char.value < 9 || (char.value > 9 && char.value < 32) // < 32 == special characters in ASCII, 9 == horizontal tab in ASCII
                || char.value == 39 { // 39 == ' in ASCII
                let escaped = char.escape(asASCII: true)
                newString.appendContentsOf(escaped)
            } else {
                newString.append(char)
            }
        }
        return newString
    }
}

extension SwiftyEditorView: WKNavigationDelegate {
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        switch navigationAction.navigationType {
        case .LinkActivated:
            if navigationAction.targetFrame == nil {
                // TODO:
                print("targetFrame == nil")
            }
        default:
            break
        }
        
        if let URLString = navigationAction.request.URL?.absoluteString where URLString.hasPrefix("re-callback://") {
//            let commands = runJS("RE.getCommandQueue();")
//            print("hahaha \(commands)")
            webView.evaluateJavaScript("RE.getCommandQueue();", completionHandler: { (result, error) in
                if let commands = result as? String,
                    data = commands.dataUsingEncoding(NSUTF8StringEncoding) {
                    let jsonCommands: [String]?
                    do {
                        jsonCommands = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String]
                    } catch {
                        jsonCommands = nil
                        print("pare json error")
                    }
                    
                    if let jsonCommands = jsonCommands {
                        for command in jsonCommands {
                            self.performCommand(command)
                        }
                    }
                }
            })
            
            // TODO: run js code
        }
        
        decisionHandler(.Allow)
    }
}

extension WKWebView {
    // See: http://stackoverflow.com/questions/33853924/removing-wkwebview-accesory-bar-in-swift/33939584#33939584
    func removeInputAccessoryView() {
        var targetView: UIView? = nil
        for view in self.scrollView.subviews {
            if String(view.dynamicType).hasPrefix("WKContent") {
                targetView = view
            }
        }
        
        if targetView == nil {
            return
        }
        
        let noInputAccessoryViewClassName = "\(targetView!.superclass!)_NoInputAccessoryView"
        var newClass: AnyClass? = NSClassFromString(noInputAccessoryViewClassName)
        if newClass == nil {
            let uiViewClass: AnyClass = object_getClass(targetView!)
            newClass = objc_allocateClassPair(uiViewClass, noInputAccessoryViewClassName.cStringUsingEncoding(NSASCIIStringEncoding)!, 0)
        }
        
        let originalMethod = class_getInstanceMethod(UIView.self, Selector("inputAccessoryView"))
        class_addMethod(newClass!.self, Selector("inputAccessoryView"), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        
        object_setClass(targetView, newClass)
    }
}
