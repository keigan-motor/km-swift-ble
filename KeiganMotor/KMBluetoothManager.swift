//
//  KMBluetoothManager.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/11/07.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation
import CoreBluetooth

open class KMBluetoothManager : NSObject, CBCentralManagerDelegate
{
    // Singleton
    open static let sharedInstance: KMBluetoothManager = KMBluetoothManager()
    
    fileprivate var manager              : CBCentralManager?
    
    @objc dynamic open fileprivate(set) var managerState: CBManagerState = .unknown
    @objc dynamic open fileprivate(set) var motors:[KMMotor] = []
    @objc dynamic open fileprivate(set) var isScanning:Bool = false

    var scanTimer: DispatchSourceTimer?
    var scanCallback:((_ remaining: TimeInterval) -> Void)?
    
    fileprivate override init() {
        
        super.init()
        let queue = DispatchQueue(label: "km_ble", attributes: [])
        manager = CBCentralManager.init(delegate: self, queue: queue)
    }
    
    

    
    /// Start to scan KMMotor around and call callback per 1 second and ends at 0 second.
    ///
    /// - Parameters:
    ///   - duration: Time interval to call callback
    ///   - callback: To be called per duration (It can be used to control UI on ViewController)
    open func scan(_ duration:TimeInterval, callback:((_ remaining: TimeInterval) -> Void)?)
    {
        // デバイスリストをクリアする
        DispatchQueue.main.async(execute: {
            self.motors = []
        })
        
        // スキャン中、もしくはBTの電源がオフであれば、直ちに終了。
        if manager!.isScanning || manager!.state != .poweredOn {
            callback?(0)
            return
        }
        
        // スキャン時間は1秒以上、30秒以下に制約
        let scanDuration = max(1, min(30, duration))
        scanCallback = callback
        
        // 接続済のペリフェラルを取得する
        for peripheral in (manager!.retrieveConnectedPeripherals(withServices: [KMMotor.serviceUUID])) {
            addPeripheral(peripheral, name:nil)
        }
        
        // スキャンを開始する。
        manager!.scanForPeripherals(withServices: [KMMotor.serviceUUID], options: nil)
        isScanning = true
        
        var remaining = scanDuration
        scanTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main)
        scanTimer?.schedule(deadline: DispatchTime.now(), repeating:.seconds(1)) // 1秒ごとのタイマー
        scanTimer?.setEventHandler {
            // 時間を-1秒。
            remaining = max(0, remaining - 1)
            if remaining <= 0 {
                self.cancelScan()
            }
            // 継続ならばシグナリング
            self.scanCallback?(remaining)
        }
        scanTimer!.resume()
    }
    
    open func scan(_ duration:TimeInterval = 3.0)
    {
        scan(duration, callback: nil)
    }
    
    open func cancelScan()
    {
        guard manager!.isScanning else { return }
        
        scanTimer!.cancel()
        
        self.scanCallback?(0)
        self.scanCallback = nil
        
        self.manager!.stopScan()
        self.isScanning = false
    }
    
    // CentralManagerにデリゲートを設定して初期状態に戻します。
    // ファームウェア更新などで、CentralManagerを別に渡して利用した後、復帰するために使います。
    open func reset()
    {
        // デバイスリストをクリアする
        DispatchQueue.main.async(execute: {
            self.motors = []
        })
        
        manager?.delegate = self
    }
    
    // MARK: Private methods
    
    func addPeripheral(_ peripheral: CBPeripheral, name: String?)
    {
        //すでに配列にあるかどうか探す, なければ追加。KVOを活かすため、配列それ自体を代入する
        if !motors.contains(where: { element -> Bool in element.peripheral == peripheral }) {
            var devs = Array<KMMotor>(self.motors)
            devs.append(KMMotor(manager: self.manager!, peripheral: peripheral, name: name))
            DispatchQueue.main.async(execute: {
                self.motors = devs
            })
        }
    }
    
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        managerState = central.state
        var state : String
        switch(central.state){
        case .poweredOn:
            state = "Powered ON"
            break
        case .poweredOff:
            state = "Powered OFF"
            motors = []
            break
        case .resetting:
            state = "Resetting"
            break
        case .unauthorized:
            state = "Unautthorized"
            motors = []
            break
        case .unsupported:
            state = "Unsupported"
            motors = []
            break
        case .unknown:
            state = "Unknown"
            break
        }
        
        print("[Delegate] CBCentralManager did update state to: \(state)")
    }
    
    open func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        DispatchQueue.main.async(execute: {
            //self.addPeripheral(peripheral, name: advertisementData[CBAdvertisementDataLocalNameKey] as? String )
            self.addPeripheral(peripheral, name: peripheral.name )
        })
    }
    
    open func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        for motor in motors.filter({element -> Bool in element.peripheral == peripheral}) {
            DispatchQueue.main.async(execute: {
                motor.onConnected()
            })
        }
    }
    
    open func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
    {
        for motor in motors.filter({element -> Bool in element.peripheral == peripheral}) {
            DispatchQueue.main.async(execute: {
                motor.onDisConnected()
            })
        }
    }
    
    
}
