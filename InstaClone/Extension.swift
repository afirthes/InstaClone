//
//  Extension.swift
//  InstaClone
//
//  Created by Afir Thes on 16.09.2021.
//

import UIKit

extension UIViewController {
    class func displayLoading(withView: UIView) -> UIView {
        let spinnerView = UIView.init(frame: withView.bounds)
        spinnerView.backgroundColor = UIColor.clear
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            withView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    class func removeLoading(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        if self.size.width <= width {
            return self
        }
        let canvasSize = CGSize(width: width, height: CGFloat(ceil((width * size.height) / size.width)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
