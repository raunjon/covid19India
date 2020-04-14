//
//  Loader.swift
//  Covid19India
//
//  Created by CeX on 14/04/20.
//  Copyright © 2020 CeX. All rights reserved.
//

import UIKit

class Loader {
    static let instance: Loader = {
        let sharedInstance = Loader(frame: CGRect(x: 0, y: 0, width: Constants.width, height: Constants.height))
        return sharedInstance
    }()
    let activity: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var backView: UIView!
    
    init(frame: CGRect) {
        self.backView = UIView(frame: frame)
        self.backView.backgroundColor = UIColor.black
        self.backView.alpha = 0.2
        self.activity.center = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.center ?? self.backView.center
        self.activity.isHidden = false
        self.activity.hidesWhenStopped = true
        self.backView.addSubview(activity)
    }
    
    init() {
            
    }
    
    class func show() {
        self.instance.show()
    }
    
    class func hide() {
        self.instance.hide()
    }
    
    func show() {
        DispatchQueue.main.async {
            UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.addSubview(self.backView)
            self.activity.startAnimating()
        }
    }

    func showLocal(forView view : UIView)  {
       DispatchQueue.main.async {
            view.addSubview(self.backView)
            self.activity.startAnimating()
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.activity.stopAnimating()
            self.backView.removeFromSuperview()
        }
    }

}
