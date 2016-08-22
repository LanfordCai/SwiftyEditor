//
//  SwiftyEditorOptionItem.swift
//  SwiftyEditor
//
//  Created by Lanford on 8/22/16.
//  Copyright © 2016 Lanford. All rights reserved.
//

import UIKit

protocol SwiftyEditorOption {
    
    func image() -> UIImage?
    func title() -> String
    func action(editor: SwiftyEditorToolbar?)
    
}

struct SwiftyEditorOptionItem: SwiftyEditorOption {
    
    var itemImage: UIImage?
    var itemTitle: String
    
    var itemAction: (SwiftyEditorToolbar? -> Void)
    
    init(image: UIImage?, title: String, action: (SwiftyEditorToolbar? -> Void)) {
        itemImage = image
        itemTitle = title
        itemAction = action
    }
    
    func image() -> UIImage? {
        return itemImage
    }
    
    func title() -> String {
        return itemTitle
    }
    
    func action(toolbar: SwiftyEditorToolbar?) {
        itemAction(toolbar)
    }
}

enum SwiftyEditorOptions: SwiftyEditorOption {
    case Clear
    case Undo
    case Redo
    case Bold
    case Italic
    case Subscript
    case Superscript
    case Strike
    case Underline
//    case TextColor
//    case TextBackgroundColor
//    case Header(Int)
//    case Indent
//    case Outdent
//    case OrderedList
//    case UnorderedList
//    case AlignLeft
//    case AlignCenter
//    case AlignRight
    case Image
//    case Link
    
    static func all() -> [SwiftyEditorOption] {
        return [
            Clear,
            Undo, Redo, Bold, Italic,
            Subscript, Superscript, Strike, Underline,
            Image
//            TextColor, TextBackgroundColor,
//            Header(1), Header(2), Header(3), Header(4), Header(5), Header(6),
//            Indent, Outdent, OrderedList, UnorderedList,
//            AlignLeft, AlignCenter, AlignRight, Image, Link
        ]
    }
    
    // MARK: RichEditorOption
    
    func image() -> UIImage? {
        var name = ""
        switch self {
        case .Clear: name = "clear"
        case .Undo: name = "undo"
        case .Redo: name = "redo"
        case .Bold: name = "bold"
        case .Italic: name = "italic"
        case .Subscript: name = "subscript"
        case .Superscript: name = "superscript"
        case .Strike: name = "strikethrough"
        case .Underline: name = "underline"
//        case .TextColor: name = "text_color"
//        case .TextBackgroundColor: name = "bg_color"
//        case .Header(let h): name = "h\(h)"
//        case .Indent: name = "indent"
//        case .Outdent: name = "outdent"
//        case .OrderedList: name = "ordered_list"
//        case .UnorderedList: name = "unordered_list"
//        case .AlignLeft: name = "justify_left"
//        case .AlignCenter: name = "justify_center"
//        case .AlignRight: name = "justify_right"
        case .Image: name = "insert_image"
//        case .Link: name = "insert_link"
        }
        
        let bundle = NSBundle(forClass: SwiftyEditorToolbar.self)
        return UIImage(named: name, inBundle: bundle, compatibleWithTraitCollection: nil)
    }
    
    func title() -> String {
        switch self {
        case .Clear: return NSLocalizedString("Clear", comment: "")
        case .Undo: return NSLocalizedString("Undo", comment: "")
        case .Redo: return NSLocalizedString("Redo", comment: "")
        case .Bold: return NSLocalizedString("Bold", comment: "")
        case .Italic: return NSLocalizedString("Italic", comment: "")
        case .Subscript: return NSLocalizedString("Sub", comment: "")
        case .Superscript: return NSLocalizedString("Super", comment: "")
        case .Strike: return NSLocalizedString("Strike", comment: "")
        case .Underline: return NSLocalizedString("Underline", comment: "")
//        case .TextColor: return NSLocalizedString("Color", comment: "")
//        case .TextBackgroundColor: return NSLocalizedString("BG Color", comment: "")
//        case .Header(let h): return NSLocalizedString("H\(h)", comment: "")
//        case .Indent: return NSLocalizedString("Indent", comment: "")
//        case .Outdent: return NSLocalizedString("Outdent", comment: "")
//        case .OrderedList: return NSLocalizedString("Ordered List", comment: "")
//        case .UnorderedList: return NSLocalizedString("Unordered List", comment: "")
//        case .AlignLeft: return NSLocalizedString("Left", comment: "")
//        case .AlignCenter: return NSLocalizedString("Center", comment: "")
//        case .AlignRight: return NSLocalizedString("Right", comment: "")
        case .Image: return NSLocalizedString("Image", comment: "")
//        case .Link: return NSLocalizedString("Link", comment: "")
        }
    }
    
    func action(toolbar: SwiftyEditorToolbar?) {
        if let toolbar = toolbar {
            switch self {
            case .Clear: toolbar.editor?.removeFormat()
            case .Undo: toolbar.editor?.undo()
            case .Redo: toolbar.editor?.redo()
            case .Bold: toolbar.editor?.bold()
            case .Italic: toolbar.editor?.italic()
            case .Subscript: toolbar.editor?.subscriptText()
            case .Superscript: toolbar.editor?.superscriptText()
            case .Strike: toolbar.editor?.strikeThrough()
            case .Underline: toolbar.editor?.underline()
//            case .TextColor: toolbar.delegate?.richEditorToolbarChangeTextColor?(toolbar)
//            case .TextBackgroundColor: toolbar.delegate?.richEditorToolbarChangeBackgroundColor?(toolbar)
//            case .Header(let h): toolbar.editor?.header(h)
//            case .Indent: toolbar.editor?.indent()
//            case .Outdent: toolbar.editor?.outdent()
//            case .OrderedList: toolbar.editor?.orderedList()
//            case .UnorderedList: toolbar.editor?.unorderedList()
//            case .AlignLeft: toolbar.editor?.alignLeft()
//            case .AlignCenter: toolbar.editor?.alignCenter()
//            case .AlignRight: toolbar.editor?.alignRight()
            case .Image: toolbar.delegate?.swiftyEditorToolbarInsertImage(toolbar)
//            case .Link: toolbar.delegate?.richEditorToolbarInsertLink?(toolbar)
            }
        }
    }
    
}