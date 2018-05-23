//
//  BarButtonLineView.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

protocol BarButtonDelegate {
    
    func buttonActionClick(_ type: ReadingType)
}

final class BarButtonLineView: UIView {
    
    var delegate: BarButtonDelegate?
    var titles: [String] {
        didSet {
            addCustomButtons()
        }
    }
    
    fileprivate var scrollView = UIScrollView()
    
    init(frame: CGRect, forTitles: [String], delegate: BarButtonDelegate? = nil) {
        self.titles = forTitles
        self.delegate = delegate
        super.init(frame: frame)
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue: (UIViewAutoresizing.flexibleWidth.rawValue))
        self.addSubview(scrollView)
        addCustomButtons()
    }    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Init methods
    deinit {
        print("BarButtonLineView deallocated")
    }
    
    // MARK: UI Methods
    
    func addCustomButtons() {
        
        scrollView.removeAllSubviews()
        var xPadding: CGFloat = 12
        for eachValue in titles {
            let newButton = UIButton(type: .custom)
            newButton.setTitle(eachValue, for: .normal)
            newButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            newButton.setTitleColor(UIColor.white, for: .selected)
            newButton.setTitleColor(UIColor.black, for: .normal)
            newButton.backgroundColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0)
            newButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            scrollView.addSubview(newButton)
            
            let tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width - 12, height: self.frame.size.height))
            tempLabel.text = eachValue
            tempLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            var rect = ServiceUtility.main.findRectForLabel(tempLabel.frame.size, label: tempLabel)
            rect.size.width += 30
            newButton.frame = CGRect(x: xPadding, y: 0, width: rect.size.width, height: self.frame.size.height)
            
            xPadding += rect.size.width + 12
        }
        scrollView.contentSize = CGSize(width: xPadding, height: self.frame.size.height)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        
        if let titleLabel = sender.titleLabel, let title = titleLabel.text {
            delegate?.buttonActionClick(ReadingType.getEquivalent(title))
            sender.backgroundColor = UIColor(red: 14/255, green: 112/255, blue: 159/255, alpha: 1.0)
            sender.isSelected = true
            for eachButton in scrollView.subviews {
                if let newButton = eachButton as? UIButton {
                    if newButton != sender {
                        sender.isSelected = false
                        newButton.backgroundColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0)
                    }
                }
            }
        }
    }
}
