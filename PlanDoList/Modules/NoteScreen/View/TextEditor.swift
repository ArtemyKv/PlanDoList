//
//  TextEditor.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.05.2023.
//

import UIKit

class TextEditor {
    weak var textView: UITextView!
    
    let textStyles: [UIFont.TextStyle] = [.body, .title2, .largeTitle]
    
    
    func setBoldStyleIsActive(_ isActive: Bool) {
        if textView.selectedRange.length > 0 {
            setSelectedTextTraitIsActive(.traitBold, isActive: isActive)
        } else {
            setSymbolicTraitIsActive(.traitBold, isActive: isActive)
        }
    }
    
    func setItalicStyleIsActive(_ isActive: Bool) {
        if textView.selectedRange.length > 0 {
            setSelectedTextTraitIsActive(.traitItalic, isActive: isActive)
        } else {
            setSymbolicTraitIsActive(.traitItalic, isActive: isActive)
        }
    }
    
    func setUnderlineStyleIsActive(_ isActive: Bool) {
        if textView.selectedRange.length > 0 {
            setSelectedAttributeIsActive(.underlineStyle, isActive: isActive)
        } else {
            textView.typingAttributes[NSAttributedString.Key.underlineStyle] = isActive ? 1 : 0
        }
    }
    
    func setStrikethroughStyleIsActive(_ isActive: Bool) {
        if textView.selectedRange.length > 0 {
            setSelectedAttributeIsActive(.strikethroughStyle, isActive: isActive)
        } else {
            textView.typingAttributes[NSAttributedString.Key.strikethroughStyle] = isActive ? 1 : 0
        }
    }
    
    private func setSymbolicTraitIsActive(_ symbolicTrait: UIFontDescriptor.SymbolicTraits, isActive: Bool) {
        guard let currentFont = textView.typingAttributes[.font] as? UIFont else { return }
        var symbolicTraits: UIFontDescriptor.SymbolicTraits = []
        let fontDescriptor = currentFont.fontDescriptor
        let currentTraits = fontDescriptor.symbolicTraits
        symbolicTraits = currentTraits
        if isActive {
            symbolicTraits.insert(symbolicTrait)
        } else {
            symbolicTraits.remove(symbolicTrait)
        }
        let font = UIFont(descriptor: fontDescriptor.withSymbolicTraits(symbolicTraits)!, size: 0)
        textView.typingAttributes[NSAttributedString.Key.font] = font
    }
    
    private func setSelectedTextTraitIsActive(_ symbolicTrait: UIFontDescriptor.SymbolicTraits, isActive: Bool) {
        let selectedRange = textView.selectedRange
        let traits = textView.attributedText.attributes(at: selectedRange.location, effectiveRange: nil)
        let descriptor = (traits[NSAttributedString.Key.font] as! UIFont).fontDescriptor
        var symbolicTraits = descriptor.symbolicTraits
        if isActive {
            symbolicTraits.insert(symbolicTrait)
        } else {
            symbolicTraits.remove(symbolicTrait)
        }
        let font = UIFont(descriptor: descriptor.withSymbolicTraits(symbolicTraits)!, size: 0)
        let mutableString = NSMutableAttributedString(attributedString: textView.attributedText)
        mutableString.addAttributes([.font: font], range: selectedRange)
        textView.attributedText = mutableString
        textView.selectedRange = selectedRange
    }
    
    private func setSelectedAttributeIsActive(_ attribute: NSAttributedString.Key, isActive: Bool) {
        let selectedRange = textView.selectedRange
        let mutableString = NSMutableAttributedString(attributedString: textView.attributedText)
        mutableString.addAttribute(attribute, value: isActive ? 1 : 0, range: selectedRange)
        textView.attributedText = mutableString
        textView.selectedRange = selectedRange
    }
}

//MARK: - Links
extension TextEditor {
    
    func addLink(linkName: String, linkURLString: String) {
        let mText = NSMutableAttributedString(attributedString: textView.attributedText)
        let currentLocation = textView.selectedRange.location
        let currentAttrs = textView.typingAttributes
        
        if linkName.count > 0 {
            let linkAttributedText = NSMutableAttributedString(string: linkName)
            let linkTextRange = NSRange(location: 0, length: linkAttributedText.length)
            linkAttributedText.addAttributes([
                .link: linkURLString,
                .font: UIFont.preferredFont(forTextStyle: .body),
                .underlineStyle: 1
            ], range: linkTextRange)
            mText.insert(linkAttributedText, at: currentLocation)
        }
        
        textView.attributedText = mText
        textView.typingAttributes = currentAttrs
    }
    
    func editLink(linkName: String, linkURLString: String, linkTextRange: NSRange) {
        let mText = NSMutableAttributedString(attributedString: self.textView.attributedText)
        mText.deleteCharacters(in: linkTextRange)
        textView.attributedText = mText
        addLink(linkName: linkName, linkURLString: linkURLString)
    }
}

//TextStyle
extension TextEditor {
    func setTextStyle(_ textStyle: UIFont.TextStyle) {
        if textView.selectedRange.length > 0 {
            setSelectedTextStyle(textStyle)
        } else {
            textView.typingAttributes[.font] = UIFont.preferredFont(forTextStyle: textStyle)
        }
    }
    
    private func setSelectedTextStyle(_ textStyle: UIFont.TextStyle) {
        let selectedRange = textView.selectedRange
        let attrs = textView.attributedText.attributes(at: selectedRange.location, effectiveRange: nil)
        let traits = (attrs[NSAttributedString.Key.font] as! UIFont).fontDescriptor.symbolicTraits
        let newDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        let newFont = UIFont(descriptor: newDescriptor.withSymbolicTraits(traits)!, size: 0)
        let mText = NSMutableAttributedString(attributedString: textView.attributedText)
        mText.addAttribute(.font, value: newFont, range: selectedRange)
        textView.attributedText = mText
        textView.selectedRange = selectedRange
    }
}
