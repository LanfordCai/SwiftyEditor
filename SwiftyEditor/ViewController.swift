//
//  ViewController.swift
//  SwiftyEditor
//
//  Created by Lanford on 8/19/16.
//  Copyright © 2016 Lanford. All rights reserved.
//

import UIKit

private let ScreenWidth = UIScreen.mainScreen().bounds.width
private let ScreenHeight = UIScreen.mainScreen().bounds.height

class ViewController: UIViewController {
    
    private var editor = SwiftyEditorView()
    
    lazy var toolbar: SwiftyEditorToolbar = {
        let toolbar = SwiftyEditorToolbar(frame: CGRect(x: 0, y: ScreenHeight - 44, width: ScreenWidth, height: 44))
        toolbar.options = SwiftyEditorOptions.all()
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGrayColor()
        editor.frame = CGRect(x: 0, y: 24, width: ScreenWidth, height: ScreenHeight - 64)
        view.addSubview(editor)
        
        toolbar.editor = editor
        toolbar.delegate = self
        view.addSubview(toolbar)
        
        let item = SwiftyEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar?.editor?.setHTML("")
        }
        
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func boldButtonTapped() {
        editor.bold()
    }
}

extension ViewController: SwiftyEditorToolbarDelegate {
    
    func swiftyEditorToolbarInsertImage(toolbar: SwiftyEditorToolbar) {
        toolbar.editor?.insertImage("http://ww4.sinaimg.cn/mw690/68c9c44djw1f72dobe6yzj20qo1bedm0.jpg", alt: "Gravatar")
    }
}

