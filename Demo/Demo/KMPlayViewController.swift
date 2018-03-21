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
    var teachingPlaybackIndex: UInt16 = 0
    var playbackRepeating: UInt32 = 1
    
    var tasksetIndex: UInt16 = 0
    var tasksetRepeating: UInt32 = 1

    @IBOutlet weak var teachingPlaybackIndexTextField: UITextField!{
        didSet {
            teachingPlaybackIndexTextField.delegate = self
        }
    }
    @IBOutlet weak var teachingPlaybackIndexStepper: UIStepper!
    @IBOutlet weak var playbackRepeatTextField: UITextField!{
        didSet {
            playbackRepeatTextField.delegate = self
        }
    }
    @IBOutlet weak var playbackRepeatStepper: UIStepper!
    
    
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
    
    }
    
    func didDisconnected(_ sender:KMMotor)
    {
        updateConnectedMotors() // TODO
        showAlert(title: "\(sender.name) disconnected", message: nil)
    }
    
    func didServiceFound(_ sender:KMMotor)
    {
        
    }
    
    // MARK: - Disable-Enable
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
    
    // MARK: - Teaching-Playback
    @IBAction func teachingPlaybackIndexTextFieldEdited(_ sender: Any) {
        guard let str = teachingPlaybackIndexTextField.text else {return}
        if let index = UInt16(str){
            teachingPlaybackIndex = index
            teachingPlaybackIndexStepper.value = Double(index)
        } else {
            print("Invalid Input Value in \(teachingPlaybackIndexTextField)")
            teachingPlaybackIndexTextField.text = String(teachingPlaybackIndex)
        }
    }
    
    
    @IBAction func teachingPlaybackIndexStepperChanged(_ sender: Any) {
        teachingPlaybackIndex = (UInt16)(teachingPlaybackIndexStepper.value)
        teachingPlaybackIndexTextField.text = String(teachingPlaybackIndex)
    }
    
    @IBAction func playbackRepeatTextFieldEdited(_ sender: Any) {
        guard let str = playbackRepeatTextField.text else {return}
        if let rpt = UInt32(str){
            playbackRepeating = rpt
            playbackRepeatStepper.value = Double(rpt)
        } else {
            print("Invalid Input Value in \(playbackRepeatTextField)")
            playbackRepeatTextField.text = String(playbackRepeating)
        }
    }
    
    @IBAction func playbackRepeatStepperChanged(_ sender: Any) {
        playbackRepeating = (UInt32)(playbackRepeatStepper.value)
        playbackRepeatTextField.text = String(playbackRepeating)
    }
    
    @IBAction func eraseMotionTapped(_ sender: Any) {
        for m in connectedMotors {
            m?.eraseMotion(at: teachingPlaybackIndex)
        }
        showCommandAlert("Erase motion at \(teachingPlaybackIndex)")
    }
    
    @IBAction func prepareTeachingMotionTapped(_ sender: Any) {
        for m in connectedMotors {
            m?.prepareTeachingMotion(at: teachingPlaybackIndex, for: 65408)
        }
        showCommandAlert("Prepare teaching motion at \(teachingPlaybackIndex)")
    }
    
    @IBAction func startTeachingMotionTapped(_ sender: Any) {
        for m in connectedMotors {
            m?.startTeachingMotion()
        }
        showCommandAlert("Start teaching motion at \(teachingPlaybackIndex)")
    }
    
    @IBAction func stopTeachingMotionTapped(_ sender: Any) {
        for m in connectedMotors {
            m?.stopTeachingMotion()
        }
        showCommandAlert("Stop teaching motion at \(teachingPlaybackIndex)")
    }
    
    @IBAction func preparePlaybackMotionTapped(_ sender: Any) {
        for m in connectedMotors {
            m?.preparePlaybackMotion(at: teachingPlaybackIndex, repeating: playbackRepeating, option: 0) // TODO option will be supported by device firmware in the future
        }
        showCommandAlert("Prepare playback motion at \(teachingPlaybackIndex)")
    }
    
    @IBAction func startPlaybackMotionTapped(_ sender: Any) {
        for m in connectedMotors {
            m?.startPlaybackMotion()
        }
        showCommandAlert("Start playback motion at \(teachingPlaybackIndex)")
    }
    
    
    // MARK: - Taskset
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
    
    @IBAction func tasksetIndexStepperChanged(_ sender: Any) {
        tasksetIndex = (UInt16)(tasksetIndexStepper.value)
        tasksetIndexTextField.text = String(tasksetIndex)
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
    
    @IBAction func tasksetRepeatStepperChanged(_ sender: Any) {
       tasksetRepeating = (UInt32)(tasksetRepeatStepper.value)
       tasksetRepeatTextField.text = String(tasksetRepeating)
    }
    
    @IBAction func doTasksetTapped(_ sender: Any) {
        for m in connectedMotors {
            m?.doTaskset(at: tasksetIndex, repeating: tasksetRepeating)
        }
        showCommandAlert("Start playback motion at \(teachingPlaybackIndex)")
    }
    

    
    
}
