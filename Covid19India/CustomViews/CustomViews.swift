//
//  CustomVie.swift
//  Covid19India
//
//  Created by CeX on 04/04/20.
//  Copyright © 2020 CeX. All rights reserved.
//

import UIKit

class HappeningUIShadowRadiusView: SpringView {
    
    @IBInspectable var shadowRadius : CGFloat = 4 {
        didSet  {
            self.updateShadow()
        }
    }
    @IBInspectable var offset : CGSize = .zero   {
        didSet  {
            self.updateShadow()
        }
    }
    @IBInspectable var shadowColor : UIColor = Colors.darkShadowColor {
        didSet  {
            self.updateShadow()
        }
    }
    @IBInspectable var shadowOpacity : Float = 0.5 {
        didSet  {
            self.updateShadow()
        }
    }
    @IBInspectable var cornerRadius : CGFloat = 20 {
        didSet  {
            self.updateRadius()
        }
    }

    let radiusView : SpringView = {
        let view = SpringView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    init()  {
        super.init(frame : .zero)
        self.setupShadowAndRadius()
    }
    
    override func addSubview(_ view: UIView) {
        if view == self.radiusView {
            super.addSubview(view)
            return
        }
        self.radiusView.addSubview(view)
    }
    
    func setupShadowAndRadius()  {
        self.addSubviews(self.radiusView)
        self.radiusView.fillSuperview()
        self.updateShadow()
        self.updateRadius()
    }
    
    func updateRadius()  {
        self.radiusView.setCornerRadius(radius: self.cornerRadius)
    }
    func updateShadow()  {
        self.setupSketchShadow(opacity: self.shadowOpacity, blur: self.shadowRadius, x: self.offset.width, y: self.offset.height, color: self.shadowColor, spread: 0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.setupShadowAndRadius()
    }
}

class HappeningUINeumorphicShadowRadiusView: UIView {
  
    var themeColour : UIColor = Colors.white {
        didSet  {
            self.updateShadows()
        }
    }
    
    var lightShadowColour : UIColor = .white {
        didSet  {
            self.updateShadows()
        }
    }
    
    var darkShadowColour : UIColor = Colors.darkShadowColor {
        didSet  {
            self.updateShadows()
        }
    }

    var cornerRadius : CGFloat = 10 {
        didSet  {
            self.updateShadows()
        }
    }
    
    init() {
        super.init(frame : .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateShadows()  {
        self.addSoftUIEffectForView(cornerRadius: self.cornerRadius, themeColor: self.themeColour, lightShadow: self.lightShadowColour, darkShadow: self.darkShadowColour)
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateShadows()
    }
}

@IBDesignable extension UIView    {
    
    func setCornerRadius(radius : CGFloat)  {
         self.layer.masksToBounds = true
         self.layer.cornerRadius = radius
     }
    
    open func setupSketchShadow(opacity: Float = 0, blur: CGFloat = 0, x : CGFloat, y: CGFloat, color: UIColor, spread : CGFloat = 0.0) {
        self.layer.applySketchShadow(color: color, alpha: opacity, x: x, y: y, blur: blur, spread: spread)
    }
    
    public func addSoftUIEffectForView(cornerRadius: CGFloat, themeColor: UIColor = Colors.white, lightShadow : UIColor = .white, darkShadow : UIColor = Colors.darkShadowColor) {
           self.layer.cornerRadius = cornerRadius
           self.layer.masksToBounds = false
           self.layer.shadowRadius = 2
           self.layer.shadowOpacity = 0.15
           self.layer.shadowOffset = CGSize( width: 2, height: 2)
           self.layer.shadowColor = darkShadow.cgColor
           
           let shadowLayer = CAShapeLayer()
           shadowLayer.frame = bounds
           shadowLayer.backgroundColor =  themeColor.cgColor
           shadowLayer.shadowColor = lightShadow.cgColor
           shadowLayer.cornerRadius = cornerRadius
           shadowLayer.shadowOffset = CGSize(width: -2.0, height: -2.0)
           shadowLayer.shadowOpacity = 1
           shadowLayer.shadowRadius = 1
           self.layer.insertSublayer(shadowLayer, at: 0)
       }
}

extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}

public struct Colors {
    public static let white : UIColor = UIColor(red: 248.00 / 255.00, green: 248.00 / 255.00, blue: 248.00 / 255.00, alpha: 1.0)
    public static let darkShadowColor : UIColor = UIColor(hex: "242F46")
}
