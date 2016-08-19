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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editor.frame = CGRect(x: 0, y: 24, width: ScreenWidth, height: ScreenHeight - 64)
        view.addSubview(editor)
        
        let button = UIButton(frame: CGRect(x: 0, y: ScreenHeight - 64, width: 100, height: 64))
        button.setTitle("Bold", forState: .Normal)
        button.setTitleColor(.blueColor(), forState: .Normal)
        button.addTarget(self, action: #selector(boldButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func boldButtonTapped() {
        editor.bold()
    }
}

