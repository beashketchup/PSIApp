//
//  ServiceUtility.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

final class ServiceUtility: NSObject {
    
    static let main = ServiceUtility()
    
    // MARK: Init methods
    private override init() {}   //This prevents others from using the default '()' initializer for this class.
    
    deinit {
        print("ServiceUtility deallocated")
    }
    
    // MARK: UI Methods
    func createNavBar(_ forSize: CGSize, title: String) -> UIView {
        
        let yPadding: CGFloat = 10
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: forSize.width, height: 64))
        newView.backgroundColor = UIColor(red: 14/255, green: 112/255, blue: 159/255, alpha: 1.0)
        
        let newLabel = UILabel(frame: CGRect(x: 0, y: 20, width: forSize.width, height: forSize.height - (yPadding * 2)))
        newLabel.text = title
        newLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        newLabel.textColor = UIColor.white
        newLabel.textAlignment = .center
        newView.addSubview(newLabel)        
        
        return newView
    }
    
    // MARK: Utility methods
    func findRectForLabel(_ preferredSize : CGSize, label : UILabel, limitedLines : Int? = 0) -> CGRect {
        var newRect = CGRect(origin: CGPoint.zero, size: preferredSize)
        label.frame = newRect
        label.numberOfLines = limitedLines!
        label.sizeToFit()
        
        newRect.size = label.frame.size//CGSize(width: newRect!.size.width, height: (label?.frame.size.height)!)
        return newRect
    }
}

extension Array {
    
    mutating func push(_ newElement: Element) {
        self.append(newElement)
    }
    
    mutating func append(_ newElements: [Element]?) {
        for e in newElements ?? [] {
            self.append(e)
        }
    }
    
    mutating func pop() -> Element? {
        return self.removeLast()
    }
    
    func peekAtStack() -> Element? {
        return self.last
    }
}

extension UIView {
    
    func removeAllSubviews() {
        for eachView in subviews {
            eachView.removeFromSuperview()
        }
    }
}
