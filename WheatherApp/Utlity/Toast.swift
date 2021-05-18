//
//  Toast.swift
//  WheatherApp
//
//  Created by Neha Gupta on 19/05/21.
//

import UIKit

class Toast {
    
    static func showToast(controller: UIViewController,message : String) {
            let toastLabel = UILabel(frame: CGRect(x: controller.view.frame.size.width/2 - 75, y: controller.view.frame.size.height-100, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.lineBreakMode = .byWordWrapping
            toastLabel.numberOfLines = 3
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            controller.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
}
