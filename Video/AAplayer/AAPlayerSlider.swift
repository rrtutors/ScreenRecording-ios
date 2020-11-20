//
//  AAPlayerSlider.swift
//  AAPlayer


import UIKit

class AAPlayerSlider: UISlider {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setThumbImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        return CGRect(x: rect.origin.x, y: rect.origin.y + 2, width: rect.width, height: rect.height)
    }
    
    fileprivate func setThumbImage() {
        
        UIGraphicsBeginImageContext(CGSize(width: 15, height: 13))
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0).cgColor)
        context?.addEllipse(in: CGRect(x: 0, y: 0, width: 10, height: 10))
        context!.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setThumbImage(image, for: .normal)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
