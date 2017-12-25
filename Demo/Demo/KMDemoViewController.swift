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
    
    @IBOutlet weak var speedTextField: UITextField!{
        didSet {
            speedTextField.delegate = self
        }
    }
    @IBOutlet weak var speedSlider: UISlider!
    
    var speedToSend: Float32! = 0
    var speedSendingFlag: Bool = false
    
    @IBOutlet weak var moveToTextField: UITextField!{
        didSet {
            moveToTextField.delegate = self
        }
    }
    @IBOutlet weak var moveByTextField: UITextField!{
        didSet {
            moveByTextField.delegate = self
        }
    }
    
    @IBOutlet weak var maxTorqueTextField: UITextField!{
        didSet {
            maxTorqueTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        configureObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        removeObserver()
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
        let p = String(format: "%.2f", position.radToDeg()) // unit: Degree
        let v = String(format: "%.2f", velocity.radPerSecToRPM()) // unit: RPM
        let t = String(format: "%.4f", torque) // unit: N * m
        
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
            motor?.speed(rpm:spd)
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
                self.motor?.speed(rpm:self.speedToSend)
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
            motor?.move(toDegree:pos)
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
            motor?.move(byDegree:dist)
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

    // MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
            
        })
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
}



extension KMDemoViewController: MotorSelectionDelegate {
    func motorSelected(_ newMotor: KMMotor) {
        motor = newMotor
        print("motorSelected: \(newMotor)")
    }
}

