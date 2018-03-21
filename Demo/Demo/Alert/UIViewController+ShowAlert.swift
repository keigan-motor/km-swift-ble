//
//  UIViewController+ShowAlert.swift
//  KeiganPlay
//
//  Created by Takashi Tokuda on 2018/03/21.
//  Copyright © 2018年 Takashi Tokuda. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title:String, message:String?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showDismissingAlert(title:String, message:String?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        //alert.addAction(okAction)
        
        present(alert, animated: true, completion: {
            alert.view.center.y = alert.view.center.y + 100
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true, completion:nil)
            }
        })
    }
    
    func showCommandAlert(_ command:String){
        
        let commandAlert = KMCommandAlertView(title: command)
        commandAlert.show(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            commandAlert.dismiss(animated: true)
        }
        
    }
}
