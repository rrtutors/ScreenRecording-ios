//
//  AAPlayButton.swift
//  AAPlayer


import UIKit

class AAPlayButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if isSelected {
            setPauseIconImage(rect)
            
        } else {
            setPlayIconImage(rect)
            
        }
        
    }
    
    fileprivate func setPauseIconImage(_ rect: CGRect) {
        
        let rect = rect
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(5.0)
        context.move(to: CGPoint(x: 5, y: 0))
        context.addLine(to: CGPoint(x: 5, y: 20))
        context.move(to: CGPoint(x: 15, y: 0))
        context.addLine(to: CGPoint(x: 15, y: 20))
        context.strokePath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setImage(image, for: .selected)
    }

    fileprivate func setPlayIconImage(_ rect: CGRect) {
        
        let rect = rect
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.move(to: CGPoint(x: 3, y: 0))
        context.addLine(to: CGPoint(x: 3, y: rect.size.height))
        context.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height / 2))
        context.closePath()
        context.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setImage(image, for: .normal)
        
    }
}
