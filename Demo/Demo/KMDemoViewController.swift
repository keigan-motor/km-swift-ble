//
//  KMDemoViewController.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/12/20.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation
import UIKit


class KMDemoViewController:UIViewController, KMMotorDelegate, UITextFieldDelegate {
    
    var motor: KMMotor? {
        didSet {
            self.title = motor?.name
            motor?.delegate = self
        }
    }
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var torqueLabel: UILabel!
    
    @IBOutlet weak var enableSegment: UISegmentedControl!
    
    @IBOutlet weak var speedTextField: UITextField!
    @IBOutlet weak var speedSlider: UISlider!
    
    var speedToSend: Float32! = 0
    var speedSendingFlag: Bool = false
    
    @IBOutlet weak var moveToTextField: UITextField!
    @IBOutlet weak var moveByTextField: UITextField!
    
    @IBOutlet weak var maxTorqueTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        speedTextField.delegate = self
        moveToTextField.delegate = self
        moveByTextField.delegate = self
        maxTorqueTextField.delegate = self
    }
    
    // MARK: - KMMotor Delegate
    func didConnected(_ sender:KMMotor)
    {
    }
    
    func didDisconnected(_ sender:KMMotor)
    {
        showAlert(title: "\(sender.name) disconnected", message: nil)
    }
    
    func didServiceFound(_ sender:KMMotor)
    {
        
    }
    
    func didMeasurementUpdate(_ sender:KMMotor, position:Float32, velocity:Float32, torque:Float32){
        
        // debugprint("\(position), \(velocity), \(torque)")
        let p = String(format: "%.2f", position)
        let v = String(format: "%.2f", velocity)
        let t = String(format: "%.4f", torque)
        
        // メインスレッドで実行
        DispatchQueue.main.async {
            self.positionLabel.text = "\(p)"
            self.velocityLabel.text = "\(v)"
            self.torqueLabel.text = "\(t)"
        }
    }
    
    
    @IBAction func enableSegmentTapped(_ sender: Any) {
        
        let seg = sender as! UISegmentedControl
        switch  seg.selectedSegmentIndex {
        case 0:
            motor?.disable()
            break
        case 1:
            motor?.enable()
            break
        default:
            break
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        motor?.stop()
    }
    @IBAction func freeButtonTapped(_ sender: Any) {
        motor?.free()
    }
    
    @IBAction func speedTextFieldEdited(_ sender: Any) {
        print("spd txt")
        let tf = sender as! UITextField
        guard let str = tf.text else {return}
        if let spd = Float32(str) {
            motor?.speed(spd)
            speedSlider.value = spd
        } else {
            print("Invalid Input Value")
        }
    }
    
    @IBAction func speedSliderValueChanged(_ sender: Any) {
        let slider = sender as! UISlider
        let val = round(slider.value * 100)/100
        speedToSend = val
        if speedSendingFlag == false {
            speedSendingFlag = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { // dispatch after 50 msec.
                self.speedTextField.text = "\(self.speedToSend!)"
                self.motor?.speed(self.speedToSend)
                self.speedSendingFlag = false
            }
        }
    }
    

    
    @IBAction func runReverseButtonTapped(_ sender: Any) {
        motor?.runReverse()
    }
    
    @IBAction func runForwardButtonTapped(_ sender: Any) {
        motor?.runForward()
    }
    
    @IBAction func moveToButtonTapped(_ sender: Any) {
        guard let str = moveToTextField.text else {return}
        if let pos = Float32(str){
            motor?.move(to: pos)
        } else {
            print("Invalid Input Value")
        }
    }
    
    @IBAction func moveToTextFieldEdited(_ sender: Any) {
        moveToButtonTapped(sender)
    }
    
    @IBAction func moveByButtonTapped(_ sender: Any) {
        guard let str = moveByTextField.text else {return}
        if let dist = Float32(str){
            motor?.move(by: dist)
        } else {
            print("Invalid Input Value")
        }
    }
    
    @IBAction func moveByTextFieldEdited(_ sender: Any) {
        moveByButtonTapped(sender)
    }
    
    @IBAction func maxTorqueButtonTapped(_ sender: Any) {
        guard let str = maxTorqueTextField.text else {return}
        if let trq = Float32(str){
            motor?.maxTorque(trq)
        } else {
            print("Invalid Input Value")
        }
    }
    
    @IBAction func maxTorqueTextFieldEdited(_ sender: Any) {
        maxTorqueButtonTapped(sender)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



extension KMDemoViewController: MotorSelectionDelegate {
    func motorSelected(_ newMotor: KMMotor) {
        motor = newMotor
        print("motorSelected: \(newMotor)")
    }
}

