//
//  FloatingView.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

final class FloatingView: UIView {
    
    fileprivate var titleLabel = UILabel()
    fileprivate var infoLabel = UILabel()
    
    init(frame: CGRect, forTitle: String, info: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = UIColor.gray.cgColor
        addCustomLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Init methods
    deinit {
        print("FloatingView deallocated")
    }
    
    // MARK: UI Methods
    
    func addCustomLabels() {
                
        let xPadding: CGFloat = 14
        titleLabel = UILabel(frame: CGRect(x: xPadding, y: 0, width: self.frame.size.width - (xPadding * 2), height: self.frame.size.height))
        titleLabel.text = ""
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        titleLabel.textColor = UIColor(red: 14/255, green: 112/255, blue: 159/255, alpha: 1.0)
        self.addSubview(titleLabel)
        
        var rect = ServiceUtility.main.findRectForLabel(titleLabel.frame.size, label: titleLabel)
        titleLabel.frame.size = rect.size
        
        infoLabel = UILabel(frame: CGRect(x: xPadding, y: 0, width: self.frame.size.width - (xPadding * 2) - rect.size.width, height: self.frame.size.height))
        infoLabel.text = ""
        infoLabel.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        infoLabel.textColor = UIColor(red: 14/255, green: 112/255, blue: 159/255, alpha: 1.0)
        self.addSubview(infoLabel)
        
        rect = ServiceUtility.main.findRectForLabel(infoLabel.frame.size, label: infoLabel)
        infoLabel.frame = CGRect(x: self.frame.size.width - xPadding - rect.size.width, y: 0, width: rect.size.width, height: rect.size.height)
        
        var center = titleLabel.center
        titleLabel.center = CGPoint(x: center.x, y: self.frame.size.height / 2)
        center = infoLabel.center
        infoLabel.center = CGPoint(x: center.x, y: self.frame.size.height / 2)
    }
    
    func updateView(forTitle: String, info: String) {
        
        let xPadding: CGFloat = 14
        titleLabel.text = forTitle
        infoLabel.text = info
        var rect = ServiceUtility.main.findRectForLabel(self.frame.size, label: titleLabel)
        titleLabel.frame = CGRect(x: xPadding, y: 0, width: rect.size.width, height: rect.size.height)
        
        rect = ServiceUtility.main.findRectForLabel(self.frame.size, label: infoLabel)
        infoLabel.frame = CGRect(x: self.frame.size.width - xPadding - rect.size.width, y: 0, width: rect.size.width, height: rect.size.height)
        
        var center = titleLabel.center
        titleLabel.center = CGPoint(x: center.x, y: self.frame.size.height / 2)
        center = infoLabel.center
        infoLabel.center = CGPoint(x: center.x, y: self.frame.size.height / 2)
    }
}
