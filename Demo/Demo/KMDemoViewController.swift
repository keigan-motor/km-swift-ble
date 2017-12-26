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
    var speedRPM: Float32 = 0
    var positionDeg: Float32 = 0
    var distanceDeg: Float32 = 0
    var holdTorque: Float32 = 0
    var maxTorque: Float32 = 1
    var waitTimeSec: Float32 = 0
    var tasksetIndex: UInt16 = 0
    var motionIndex: UInt16 = 0
    var isRecordingTaskset: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var torqueLabel: UILabel!
    
    @IBOutlet weak var enableSegment: UISegmentedControl!
    
    @IBOutlet weak var speedStepper: UIStepper!
    @IBOutlet weak var speedTextField: UITextField!{
        didSet {
            speedTextField.delegate = self
        }
    }
    
    
    @IBOutlet weak var moveToStepper: UIStepper!
    @IBOutlet weak var moveToTextField: UITextField!{
        didSet {
            moveToTextField.delegate = self
        }
    }
    
    @IBOutlet weak var moveByStepper: UIStepper!
    @IBOutlet weak var moveByTextField: UITextField!{
        didSet {
            moveByTextField.delegate = self
        }
    }
    
    @IBOutlet weak var holdTorqueStepper: UIStepper!
    @IBOutlet weak var holdTorqueTextField: UITextField!{
        didSet {
            holdTorqueTextField.delegate = self
        }
    }
    
    
    @IBOutlet weak var maxTorqueStepper: UIStepper!
    @IBOutlet weak var maxTorqueTextField: UITextField!{
        didSet {
            maxTorqueTextField.delegate = self
        }
    }
    
    
    @IBOutlet weak var waitStepper: UIStepper!
    @IBOutlet weak var waitTextField: UITextField!{
        didSet {
            waitTextField.delegate = self
        }
    }
    
    @IBOutlet weak var pauseSegment: UISegmentedControl!
    
    @IBOutlet weak var recordTasksetButton: UIButton!
    @IBOutlet weak var tasksetIndexStepper: UIStepper!
    @IBOutlet weak var tasksetIndexTextField: UITextField!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
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
    
    @IBAction func speedButtonTapped(_ sender: Any) {
        motor?.speed(rpm: speedRPM)
    }
    
    @IBAction func speedStepperChanged(_ sender: Any) {
        let stepper = sender as! UIStepper
        speedRPM = Float32(stepper.value)
        speedTextField.text = String(speedRPM)
    }
    
    @IBAction func speedTextFieldEdited(_ sender: Any) {
        let tf = sender as! UITextField
        guard let str = tf.text else {return}
        if let spd = Float32(str) {
            speedRPM = spd
            speedStepper.value = Double(spd)
        } else {
            print("Invalid Input Value in \(speedTextField)")
        }
    }
    
    
    @IBAction func runReverseButtonTapped(_ sender: Any) {
        motor?.runReverse()
    }
    
    @IBAction func runForwardButtonTapped(_ sender: Any) {
        motor?.runForward()
    }
    
    @IBAction func moveToButtonTapped(_ sender: Any) {
        motor?.move(toDegree:positionDeg)
    }
    
    @IBAction func moveToStepperChanged(_ sender: Any) {
        let stepper = sender as! UIStepper
        positionDeg = Float32(stepper.value)
        moveToTextField.text = String(positionDeg)
    }
    
    
    @IBAction func moveToTextFieldEdited(_ sender: Any) {
        let tf = sender as! UITextField
        guard let str = tf.text else {return}
        if let pos = Float32(str) {
            positionDeg = pos
            moveToStepper.value = Double(pos)
        } else {
            print("Invalid Input Value in \(moveToTextField)")
        }
    }
    
    @IBAction func moveByButtonTapped(_ sender: Any) {
        motor?.move(byDegree: distanceDeg)
    }
    
    @IBAction func moveByStepperTapped(_ sender: Any) {
        let stepper = sender as! UIStepper
        distanceDeg = Float32(stepper.value)
        moveByTextField.text = String(distanceDeg)
    }
    
    
    @IBAction func moveByTextFieldEdited(_ sender: Any) {
        let tf = sender as! UITextField
        guard let str = tf.text else {return}
        if let dist = Float32(str) {
            distanceDeg = dist
            moveByStepper.value = Double(dist)
        } else {
            print("Invalid Input Value in \(moveByTextField)")
        }
    }
    
    
    @IBAction func holdButtonTapped(_ sender: Any) {
        motor?.hold(torque: holdTorque)
    }

    
    @IBAction func holdTorqueStepperChanged(_ sender: Any) {
        let stepper = sender as! UIStepper
        holdTorque = Float32(stepper.value)
        holdTorqueTextField.text = String(holdTorque)
    }
    
    @IBAction func holdTorqueTextFieldEdited(_ sender: Any) {
        let tf = sender as! UITextField
        guard let str = tf.text else {return}
        if let trq = Float32(str){
            holdTorque = trq
            holdTorqueStepper.value = Double(trq)
        } else {
            print("Invalid Input Value in \(holdTorqueTextField)")
        }
    }
    
    
    @IBAction func maxTorqueButtonTapped(_ sender: Any) {
        motor?.maxTorque(maxTorque)

    }
    
    @IBAction func maxTorqueStepperChanged(_ sender: Any) {
        let stepper = sender as! UIStepper
        maxTorque = Float32(stepper.value)
        maxTorqueTextField.text = String(maxTorque)
    }
    
    
    @IBAction func maxTorqueTextFieldEdited(_ sender: Any) {
        let tf = sender as! UITextField
        guard let str = tf.text else {return}
        if let trq = Float32(str){
            maxTorque = trq
            maxTorqueStepper.value = Double(trq)
        } else {
            print("Invalid Input Value in \(maxTorqueTextField)")
        }
    }
    
    
    @IBAction func waitButtonTapped(_ sender: Any) {
        motor?.wait(forSec: waitTimeSec)
    }
    
    @IBAction func waitStepperChanged(_ sender: Any) {
        let stepper = sender as! UIStepper
        waitTimeSec = Float32(stepper.value)
        waitTextField.text = String(waitTimeSec)
    }
    
    @IBAction func waitTextFieldEdited(_ sender: Any) {
        let tf = sender as! UITextField
        guard let str = tf.text else {return}
        if let time = Float32(str){
            waitTimeSec = time
            waitStepper.value = Double(time)
        } else {
            print("Invalid Input Value in \(maxTorqueTextField)")
        }
    }
    
    @IBAction func pauseSegmentChanged(_ sender: Any) {
        let seg = sender as! UISegmentedControl
        switch  seg.selectedSegmentIndex {
        case 0:
            motor?.resume()
            break
        case 1:
            motor?.pause()
            break
        default:
            break
        }
    }
    
    @IBAction func recordTasksetButtonTapped(_ sender: Any) {
        if (motor?.isRecordingTaskset)! {
            motor?.stopRecordingTaskset()
            recordingLabel.text = "■"
            recordingLabel.textColor = UIColor.darkText
            recordTasksetButton.setTitle("Record ●", for: UIControlState.normal)
            recordTasksetButton.setTitleColor(UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
, for: UIControlState.normal)
        } else {
            motor?.startRecordingTaskset(at: tasksetIndex)
            recordingLabel.text = "●"
            recordingLabel.textColor = UIColor.red
            recordTasksetButton.setTitle("Stop ■", for: UIControlState.normal)
            recordTasksetButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        }
        
    }
    
    @IBAction func tasksetIndexStepperChanged(_ sender: Any) {
        let stepper = sender as! UIStepper
        tasksetIndex = UInt16(stepper.value)
        tasksetIndexTextField.text = String(tasksetIndex)
    }
    
    @IBAction func tasksetIndexTextFieldEdited(_ sender: Any) {
        let tf = sender as! UITextField
        guard let str = tf.text else {return}
        if let id = UInt16(str){
            tasksetIndex = id
            tasksetIndexStepper.value = Double(id)
        } else {
            print("Invalid Input Value in \(maxTorqueTextField)")
        }
    }
    
    @IBAction func eraseTasksetButtonTapped(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "Confirmation", message: "Erase Taskset Index:\(tasksetIndex)?", preferredStyle:  UIAlertControllerStyle.alert)

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            self.motor?.eraseTaskset(at: self.tasksetIndex)
        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        

        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
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

