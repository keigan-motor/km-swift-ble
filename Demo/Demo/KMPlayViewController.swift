//
//  KMPlayViewController.swift
//  Demo
//
//  Created by Takashi Tokuda on 2017/12/26.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation
import UIKit

class KMPlayViewController:UIViewController, KMMotorDelegate, UITextFieldDelegate {
    
    var connectedMotors: [KMMotor?] = []
    var tasksetIndex: UInt16 = 0
    var tasksetRepeating: UInt32 = 1


    @IBOutlet weak var tasksetIndexTextField: UITextField!{
        didSet {
            tasksetIndexTextField.delegate = self
        }
    }
    @IBOutlet weak var tasksetIndexStepper: UIStepper!
    @IBOutlet weak var tasksetRepeatTextField: UITextField!{
        didSet{
            tasksetRepeatTextField.delegate = self
        }
    }
    @IBOutlet weak var tasksetRepeatStepper: UIStepper!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateConnectedMotors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        KMBluetoothManager.sharedInstance.addObserver(self, forKeyPath:"motors", options: .new, context:nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KMBluetoothManager.sharedInstance.removeObserver(self, forKeyPath: "motors")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Update Connected Motors
    func updateConnectedMotors(){
        connectedMotors = []
        let motors = KMBluetoothManager.sharedInstance.motors
        for m in motors {
            if m.isConnected {
                connectedMotors.append(m)
            }
        }
    }
    
    // MARK: - KMMotor Delegate
    func didConnected(_ sender:KMMotor)
    {
        // TODO performSegue(withIdentifier: "dataView", sender: self)
    }
    
    func didDisconnected(_ sender:KMMotor)
    {
        updateConnectedMotors() // TODO
        showAlert(title: "\(sender.name) disconnected", message: nil)
    }
    
    func didServiceFound(_ sender:KMMotor)
    {
        
    }
    

    @IBAction func tasksetIndexTextFieldEdited(_ sender: Any) {
        guard let str = tasksetIndexTextField.text else {return}
        if let index = UInt16(str){
            tasksetIndex = index
            tasksetIndexStepper.value = Double(index)
        } else {
            print("Invalid Input Value in \(tasksetIndexTextField)")
            tasksetIndexTextField.text = String(tasksetIndex)
        }
    }
    
    @IBAction func tasksetRepeatTextFieldEdited(_ sender: Any) {
        guard let str = tasksetRepeatTextField.text else {return}
        if let rpt = UInt32(str){
            tasksetRepeating = rpt
            tasksetRepeatStepper.value = Double(rpt)
        } else {
            print("Invalid Input Value in \(tasksetRepeatTextField)")
            tasksetRepeatTextField.text = String(tasksetRepeating)
        }
    }
    
    
    // MARK: - Stepper
    @IBAction func tasksetIndexStepperChanged(_ sender: Any) {
       tasksetIndex = (UInt16)(tasksetIndexStepper.value)
       tasksetIndexTextField.text = String(tasksetIndex)
    }
    
    @IBAction func tasksetRepeatStepperChanged(_ sender: Any) {
       tasksetRepeating = (UInt32)(tasksetRepeatStepper.value)
       tasksetRepeatTextField.text = String(tasksetRepeating)
    }
    
    @IBAction func enableSegmentChanged(_ sender: Any) {
        let seg = sender as! UISegmentedControl
        switch  seg.selectedSegmentIndex {
        case 0:
            for m in connectedMotors {
                m?.disable()
            }
            break
        case 1:
            for m in connectedMotors {
                m?.enable()
            }
            break
        default:
            break
        }
    }
    
    // MARK: - Do Takset
    @IBAction func doTasksetTapped(_ sender: Any) {
        for m in connectedMotors {
            m?.doTaskset(at: tasksetIndex, repeating: tasksetRepeating)
        }
    }
    

    
    
}
