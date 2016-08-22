//
//  SwiftyEditorToolbar.swift
//  SwiftyEditor
//
//  Created by Lanford on 8/22/16.
//  Copyright © 2016 Lanford. All rights reserved.
//

import UIKit

class SwiftyBarButtonItem: UIBarButtonItem {
    var actionHandler: (() -> Void)?
    
    convenience init(image: UIImage? = nil, handler: (() -> Void)? = nil) {
        self.init(image: image, style: .Plain, target: nil, action: nil)
        target = self
        action = #selector(SwiftyBarButtonItem.buttonWasTapped)
        actionHandler = handler
    }
    
    convenience init(title: String = "", handler: (() -> Void)? = nil) {
        self.init(title: title, style: .Plain, target: nil, action: nil)
        target = self
        action = #selector(SwiftyBarButtonItem.buttonWasTapped)
        actionHandler = handler
    }
    
    func buttonWasTapped() {
        actionHandler?()
    }
}

protocol SwiftyEditorToolbarDelegate: class {
    func swiftyEditorToolbarChangeTextColor(toolbar: SwiftyEditorToolbar)
    func swiftyEditorToolbarChangeBackgroundColor(toolbar: SwiftyEditorToolbar)
    func swiftyEditorToolbarInsertImage(toolbar: SwiftyEditorToolbar)
    func swiftyEditorToolbarInsertLink(toolbar: SwiftyEditorToolbar)
}

extension SwiftyEditorToolbarDelegate {
    func swiftyEditorToolbarChangeTextColor(toolbar: SwiftyEditorToolbar) {}
    func swiftyEditorToolbarChangeBackgroundColor(toolbar: SwiftyEditorToolbar) {}
    func swiftyEditorToolbarInsertImage(toolbar: SwiftyEditorToolbar) {}
    func swiftyEditorToolbarInsertLink(toolbar: SwiftyEditorToolbar) {}
}

class SwiftyEditorToolbar: UIView {
    
    weak var delegate: SwiftyEditorToolbarDelegate?
    
    weak var editor: SwiftyEditorView?
    
    var options: [SwiftyEditorOption] = [] {
        didSet {
            updateToolbar()
        }
    }
    
    private var toolbarScroll: UIScrollView
    private var toolbar: UIToolbar
    private var backgroundToolbar: UIToolbar
    
    override init(frame: CGRect) {
        toolbarScroll = UIScrollView()
        toolbar = UIToolbar()
        backgroundToolbar = UIToolbar()
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        toolbarScroll = UIScrollView()
        toolbar = UIToolbar()
        backgroundToolbar = UIToolbar()
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.autoresizingMask = .FlexibleWidth
        
        backgroundToolbar.frame = self.bounds
        backgroundToolbar.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        toolbar.autoresizingMask = .FlexibleWidth
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .Any)
        
        toolbarScroll.frame = self.bounds
        toolbarScroll.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        toolbarScroll.showsHorizontalScrollIndicator = false
        toolbarScroll.showsVerticalScrollIndicator = false
        toolbarScroll.backgroundColor = UIColor.clearColor()
        
        toolbarScroll.addSubview(toolbar)
        
        addSubview(backgroundToolbar)
        addSubview(toolbarScroll)
        updateToolbar()
    }
    
    private func updateToolbar() {
        var buttons = [UIBarButtonItem]()
        for option in options {
            if let image = option.image() {
                let button = SwiftyBarButtonItem(image: image) { [weak self] in  option.action(self) }
                buttons.append(button)
            } else {
                let title = option.title()
                let button = SwiftyBarButtonItem(title: title) { [weak self] in option.action(self) }
                buttons.append(button)
            }
            
        }
        toolbar.items = buttons
        
        let defaultIconWidth: CGFloat = 22
        let barButtonItemMargin: CGFloat = 11
        let width: CGFloat = buttons.reduce(0) {sofar, new in
            if let view = new.valueForKey("view") as? UIView {
                return sofar + view.frame.size.width + barButtonItemMargin
            } else {
                return sofar + (defaultIconWidth + barButtonItemMargin)
            }
        }
        
        if width < self.frame.size.width {
            toolbar.frame.size.width = self.frame.size.width
        } else {
            toolbar.frame.size.width = width
        }
        toolbar.frame.size.height = 44
        toolbarScroll.contentSize.width = width
    }
}