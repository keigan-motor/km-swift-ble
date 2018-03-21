//
//  UIView+Modal.swift
//  Demo
//
//  Created by Takashi Tokuda on 2018/03/21.
//  Copyright © 2018年 Takashi Tokuda. All rights reserved.
//

import Foundation
import UIKit

protocol Modal {
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var dialogView:UIView {get set}
}

extension Modal where Self:UIView{
    func show(animated:Bool){
        self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
        if let topController = UIApplication.topViewController() {
            topController.view.addSubview(self)
        }
        if animated {
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.dialogView.center  = CGPoint(x: self.center.x, y: self.frame.height - self.dialogView.frame.height/2 - 70)
            }, completion: { (completed) in
                
            })
        }else{
            self.dialogView.center  = self.center
        }
    }
    
    func dismiss(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        }else{
            self.removeFromSuperview()
        }
        
    }
}
