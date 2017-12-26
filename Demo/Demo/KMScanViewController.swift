//
//  KMScanViewController.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/11/24.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import UIKit
import Foundation

protocol MotorSelectionDelegate: class {
    func motorSelected(_ newMotor: KMMotor)
}

class KMScanViewController:UITableViewController, KMMotorDelegate, KMScanCellDelegate {
    
    var selectedMotor: KMMotor?
    var shouldScanFirst = true
    var scanButton: UIBarButtonItem?

    weak var delegate: MotorSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(scanButton, animated: false)
        scanButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action:#selector(scanButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.alpha = 1
        self.tableView.isUserInteractionEnabled = true
        
        KMBluetoothManager.sharedInstance.addObserver(self, forKeyPath:"motors", options: .new, context:nil)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if shouldScanFirst {
            scan(5.0)
            shouldScanFirst = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KMBluetoothManager.sharedInstance.removeObserver(self, forKeyPath: "motors")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "motors") {
            self.tableView.reloadData()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Scan
    @objc func scanButtonTapped(){
        scan(5.0)
    }
    
    
    func scan(_ duration:TimeInterval) {
        displayNavBarActivity()
        KMBluetoothManager.sharedInstance.scan(duration, callback: { (remaining: TimeInterval)  in
            if remaining <= 0 {
                self.dismissNavBarActivity()
            }
        })

    }

    // MARK: - Activity Indicator in Navigation Bar
    func displayNavBarActivity() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.startAnimating()
        let item = UIBarButtonItem(customView: indicator)        
        self.navigationItem.rightBarButtonItem = item

    }
    
    func dismissNavBarActivity() {
        self.navigationItem.setRightBarButton(scanButton, animated: false)
    }
    
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KMBluetoothManager.sharedInstance.motors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scanCell", for: indexPath) as! KMScanCell
        cell.motor = KMBluetoothManager.sharedInstance.motors[indexPath.row]
        
        print(cell.motor?.peripheral ?? "No peripheral.")
        print(cell.motor?.name ?? "No name.")
        
        if let k = cell.motor?.isConnected {
            if k { cell.connectSwitch.setOn(true, animated: true) }
            else { cell.connectSwitch.setOn(false, animated: false)}
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! KMScanCell

        guard let m = cell.motor,
        let demoViewController = delegate as? KMDemoViewController
        else {return}
        
        if m.isConnected {
            delegate?.motorSelected(m)
            splitViewController?.showDetailViewController(demoViewController, sender: nil)
            
        } else {
            showAlert(title: "Connect \(m.name) first", message: nil)
        }
        
    }
    
    // MARK: - KMMotor Delegate
    func didConnected(_ sender:KMMotor)
    {
        // TODO performSegue(withIdentifier: "dataView", sender: self)
    }
    
    func didDisconnected(_ sender:KMMotor)
    {
        showAlert(title: "\(sender.name) disconnected", message: nil)
    }
    
    func didServiceFound(_ sender:KMMotor)
    {
        
    }
    
    // MARK: - KMScanCell Delegate
    func KMScanCellNameUpdated() {
        self.tableView.reloadData()
    }
    
    // MARK: - Alert
    

    

}

extension UIViewController {
    
    func showAlert(title:String, message:String?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}


