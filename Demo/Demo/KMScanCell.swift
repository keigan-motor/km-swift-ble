//
//  KMScanCell.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/12/02.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation
import UIKit


protocol KMScanCellDelegate {
    func KMScanCellNameUpdated()
}

extension KMScanCellDelegate {
    func KMScanCellNameUpdated(){
        print("Motor's Device Name Updated.")
    }
}

class KMScanCell:UITableViewCell {
    
    @IBOutlet weak var motorColorLabel: UILabel!
    @IBOutlet weak var motorNameLabel: UILabel!
    @IBOutlet weak var connectSwitch: UISwitch!
    
    var delegate: KMScanCellDelegate?
    var motor: KMMotor? {
        willSet {
        self.motor?.removeObserver(self, forKeyPath: "name")
        }
        didSet {
            self.motor?.addObserver(self, forKeyPath: "name", options: .new , context: nil)
                motorNameLabel.text = motor?.name ?? "(null)"
            if let rgb = motor?.getOwnColorFromDeviceName(){
                motorColorLabel.textColor = UIColor.init(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1.0)
            }
            
        }
    }
    
    deinit
    {
        self.motor = nil
    }
    
    @IBAction func connectSwitchTapped(_ sender: Any) {
        let cs = sender as! UISwitch
        if cs.isOn {
            motor?.connect()
        } else {
            motor?.cancelConnection()
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == nil) {
            // self.deviceNameLabel.text = device?.name
            self.delegate?.KMScanCellNameUpdated() // デリゲートでテーブルビュー更新
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
}
