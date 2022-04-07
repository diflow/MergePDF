//
//  UIButton+Extension.swift
//  MergePDF
//
//  Created by Ivan Dvornyk on 07.04.2022.
//

import UIKit

extension UIButton {
    
    public func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        
        guard  let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: forState)
    }
}
