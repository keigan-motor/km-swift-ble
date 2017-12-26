//
//  KMDemoViewController.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/12/20.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation
import UIKit


class KMDemoViewController:UIViewController, KMMotorDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    var motor: KMMotor? {
        didSet {
            self.title = motor?.name
            motor?.delegate = self
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
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
    
    @IBOutlet weak var torqueTextField: UITextField!{
        didSet {
            torqueTextField.delegate = self
        }
    }
    
    
    @IBOutlet weak var maxTorqueTextField: UITextField!{
        didSet {
            maxTorqueTextField.delegate = self
        }
    }
    
    var activeTextField:UITextField?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
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
        let t = String(format: "%.2f", torque) // unit: N * m
        
        // Execute in Main thread
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
        let val = round(slider.value * 10)/10
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
            print("Invalid Input Value in \(moveToTextField)")
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
            print("Invalid Input Value in \(moveByTextField)")
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
            print("Invalid Input Value in \(maxTorqueTextField)")
        }
    }
    
    @IBAction func maxTorqueTextFieldEdited(_ sender: Any) {
        maxTorqueButtonTapped(sender)
    }
    
    
    @IBAction func torqueButtonTapped(_ sender: Any) {
        guard let str = torqueTextField.text else {return}
        if let trq = Float32(str){
            motor?.hold(torque: trq)
        } else {
            print("Invalid Input Value in \(torqueTextField)")
        }
    }
    
    @IBAction func torqueTextFieldEdited(_ sender: Any) {
        torqueButtonTapped(sender)
    }
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }

    // MARK: ScrollView offset while editing TextField
    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {

        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        guard let textField = activeTextField else {return}
        let absoluteRect = textField.convert(textField.frame, to: view)
        // Bottom of textField
        let textFieldBottom = absoluteRect.origin.y + textField.frame.origin.y + textField.frame.height
        // Top of keyboard
        let keyboardTop = screenHeight - keyboardFrame.size.height
        // Overlap
        let distance = textFieldBottom - keyboardTop
        if distance >= 0 {
            scrollView.contentOffset.y = distance + 20.0
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentOffset.y = 0
    }
    
    // MARK: Hide Keyboard when the other area of the display is tapped
    @IBAction func displayTapped(_ sender: Any) {
        view.endEditing(true)
    }
}



extension KMDemoViewController: MotorSelectionDelegate {
    func motorSelected(_ newMotor: KMMotor) {
        motor = newMotor
        print("motorSelected: \(newMotor)")
    }
}

