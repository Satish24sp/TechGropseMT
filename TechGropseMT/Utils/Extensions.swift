//
//  Extensions.swift
//  TechGropseMT
//
//  Created by Satish Thakur on 15/05/20.
//  Copyright © 2020 Satish Thakur. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension UIView {
    func setCornerRadiusWithBorderColor (borderColor : UIColor, borderWidth : CGFloat, radius : CGFloat,backGroundColor : UIColor) {
        self.backgroundColor = backGroundColor
        self.layer.cornerRadius =  radius
        self.layer.borderWidth =  borderWidth
        self.layer.borderColor =  borderColor.cgColor
        self.clipsToBounds =  true
    }

    func setBorder(color : UIColor,width : CGFloat,radius : CGFloat) {
        self.layer.cornerRadius =  radius
        self.layer.borderWidth =  width
        self.layer.borderColor =  color.cgColor
        self.clipsToBounds =  true
    }

    func setShadow(cornerRadius : CGFloat) {
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                    self.backgroundColor = UIColor.white
                }
            }
        }
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3.0

        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
        self.layer.cornerRadius = cornerRadius
    }

    class func loadViewFromNib(nibNamed: String, frame : CGRect) -> UIView? {
        let tView = UINib(nibName: nibNamed, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
        tView?.frame = frame
        return tView
    }

    // Round View
    func setCircleCorner() {
        self.layer.cornerRadius =  self.layer.frame.size.height/2
        self.clipsToBounds =  true
    }
}


extension UIColor {
    public convenience init?(hexString: String) {

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])

            let scanner = Scanner(string: hexColor)
            scanner.scanLocation = 0

            var rgbValue: UInt64 = 0

            scanner.scanHexInt64(&rgbValue)
            
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff

            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff, alpha: 1
            )
            return
        }

        return nil
    }
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {

        self.image = placeHolder
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }

        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error.debugDescription)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}


extension UIViewController {
     var deviceWidthRatio : CGFloat {
        get {
            return UIScreen.main.bounds.size.width / 320
        }
    }
     var deviceHeightRatio : CGFloat {
        get {
            return UIScreen.main.bounds.size.height / 568
        }
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
