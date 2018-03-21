//
//  KMCommandAlertView.swift
//  Demo
//
//  Created by Takashi Tokuda on 2018/03/21.
//  Copyright © 2018年 Takashi Tokuda. All rights reserved.
//

import Foundation
import UIKit

class KMCommandAlertView: UIView, Modal{
    
    var dialogView = UIView()
    
    convenience init(title:String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(title:String){
        dialogView.clipsToBounds = true
        
        let dialogViewWidth = frame.width-32
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 0, width: dialogViewWidth-16, height: 30))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        dialogView.addSubview(titleLabel)
        
        let dialogViewHeight = titleLabel.frame.height
        
        dialogView.frame.origin = CGPoint(x: 16, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-32, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor(hex: "F21045", alpha: 0.8)
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
    }
    
    
}
