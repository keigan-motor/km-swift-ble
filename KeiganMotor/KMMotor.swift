//
//  KMMotor.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/11/07.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit


/// Delegate
public protocol KMMotorDelegate : class {
    func didConnected(_ sender:KMMotor)
    func didDisconnected(_ sender:KMMotor)
    func didServiceFound(_ sender:KMMotor)
    func didCommandChanged(_ sender:KMMotor, command:KMMotorCommand)
    func didLedStateUpdate(_ sender:KMMotor, state: KMMotorLEDState, color red:UInt8, green:UInt8, blue:UInt8)
    func didMeasurementUpdate(_ sender:KMMotor, position:Float32, velocity:Float32, torque:Float32)
    func didIMUMeasurementUpdate(_ sender:KMMotor, accelX:Int16, accelY:Int16, accelZ:Int16, temp:Int16, gyroX:Int16, gyroY:Int16, gyroZ:Int16)
}

public extension KMMotorDelegate {
    func didServiceFound(_ sender:KMMotor){
        print("didServiceFound motor:\(sender)")
    }
    func didCommandChanged(_ sender:KMMotor, command:KMMotorCommand){
        print("didCommandChanged motor:\(sender), command:\(command)")
    }
    func didLedStateUpdate(_ sender:KMMotor, state: KMMotorLEDState, color red:UInt8, green:UInt8, blue:UInt8){
        print("didLedStateupdated motor:\(sender), state:\(state), color red:\(red), green:\(green), blue:\(blue)")
    }
    func didMeasurementUpdate(_ sender:KMMotor, position:Float32, velocity:Float32, torque:Float32){
        print("didServiceFound \(sender)")
    }
    func didIMUMeasurementUpdate(_ sender:KMMotor, accelX:Int16, accelY:Int16, accelZ:Int16, temp:Int16, gyroX:Int16, gyroY:Int16, gyroZ:Int16){
        print("didServiceFound \(sender)")
    }
}
    
/// Keigan Motor Class including Bluetooth Peripheral
open class KMMotor : NSObject, CBPeripheralDelegate
{
    open unowned let manager: CBCentralManager
    open let peripheral:      CBPeripheral
    open var name: String
    open fileprivate(set) var isConnected: Bool
    
    open weak var delegate: KMMotorDelegate?
    
    static let serviceUUID = CBUUID(string: KMMotorUUID.serviceUUIDString)
    static let controlCharUUID = CBUUID(string: KMMotorUUID.charControlUUIDString)
    static let lEDCharUUID = CBUUID(string: KMMotorUUID.charLEDUUIDString)
    static let measurementCharUUID = CBUUID(string: KMMotorUUID.charMeasurementUUIDString)
    static let iMUMeasurementCharUUID = CBUUID(string: KMMotorUUID.charIMUMeasurementUUIDString)
    static let settingCharUUID = CBUUID(string: KMMotorUUID.charSettingUUIDString)
    
    static let charUUIDs = [KMMotor.controlCharUUID, KMMotor.lEDCharUUID, KMMotor.measurementCharUUID, KMMotor.iMUMeasurementCharUUID, KMMotor.settingCharUUID]
    
    var controlChar: CBCharacteristic?
    var lEDChar: CBCharacteristic?
    var measurementChar: CBCharacteristic?
    var iMUMeasurementChar: CBCharacteristic?
    var settingChar: CBCharacteristic?
    
    public var led: KMMotorLED
    public var command: KMMotorCommand?
    public var taskID: UInt16 = 0
    
    public var isEnabled: Bool
    public var isQueuePaused: Bool
    public var isRecordingTaskset: Bool
    public var isTeachingMotion: Bool
    
    // MARK: Initializer
    init(manager: CBCentralManager, peripheral:CBPeripheral, name: String?)
    {
        self.manager    = manager
        self.peripheral = peripheral
        self.isConnected = false
        self.name        = name ?? peripheral.name ?? ""
        self.led = KMMotorLED.init()

        // TODO: should read the properties from Keigan Motor
        isEnabled = false
        isQueuePaused = false
        isRecordingTaskset = false
        isTeachingMotion = false
        
        super.init()
        
        self.peripheral.delegate = self
        if self.peripheral.state == .connected {
            self.isConnected = true
            //findKMServices()
        }
    }
    

    internal func onConnected()
    {
        print("\(self) connected.")
        self.isConnected = true
        DispatchQueue.main.async(execute: {
            self.delegate?.didConnected(self)
        })
        
        findKMServices()
    }
    
    internal func onDisConnected()
    {
        print("\(self) disconnected.")
        self.isConnected = false
        
        DispatchQueue.main.async(execute: {
            self.delegate?.didDisconnected(self)
        })
    }
    
    // Private methods
    func findKMServices()
    {
        // サービスの発見
        peripheral.discoverServices([KMMotor.serviceUUID])
    }
    
    // MARK: Public methods
    open func connect()
    {
        if peripheral.state == .disconnected || peripheral.state == .disconnecting {
            manager.connect(peripheral, options:nil)
        }
    }
    
    open func cancelConnection()
    {
        manager.cancelPeripheralConnection(peripheral)
    }
    
    // MARK: CBPeripheralDelegate
    
    open func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {

        if error != nil {
            debugPrint("Unexpected error in \(#function), \(String(describing: error)).")
            return
        }
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(KMMotor.charUUIDs, for: service)
        }
        
        DispatchQueue.main.async(execute: {
            self.delegate?.didServiceFound(self)
        })
    }
    

    open func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        if error != nil {
            debugPrint("Unexpected error in \(#function), \(String(describing: error)).")
            return
        }
        
        if let service = findService(KMMotor.serviceUUID) {
            if let c = findCharacteristic(service, uuid: KMMotor.controlCharUUID){
                controlChar = c
            }
            if let c = findCharacteristic(service, uuid: KMMotor.lEDCharUUID){
                lEDChar = c
            }
            if let c = findCharacteristic(service, uuid: KMMotor.measurementCharUUID){
                measurementChar = c
                self.setNotify(c, enabled: true)
            }
            if let c = findCharacteristic(service, uuid: KMMotor.iMUMeasurementCharUUID){
                iMUMeasurementChar = c
                self.setNotify(c, enabled: true)
            }
            if let c = findCharacteristic(service, uuid: KMMotor.settingCharUUID){
                settingChar = c
            }
        }

    }
    
    open func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if error != nil {
            debugPrint("didUpdate: \(characteristic.uuid) \(String(describing: error))")
            return
        }
        

        guard let characteristics_nsdata = characteristic.value else { return }
        
        var data = [UInt8](repeating: 0, count: characteristics_nsdata.count)
        (characteristics_nsdata as NSData).getBytes(&data, length: data.count)
        
        guard data.count > 0  else { return }
        
        switch characteristic.uuid {
        case KMMotor.controlCharUUID:
            if let s = KMMotorCommand(rawValue: data[0]) {
                self.command = s
            }
            break
            
        case KMMotor.lEDCharUUID:
            guard data.count == 4 else { return }
            if let s = KMMotorLEDState(rawValue: data[0]) {
                self.led.state = s
            }
            break
            
        case KMMotor.measurementCharUUID:
            guard data.count == 12 else { return }
            let pos = Float32.decode(data[0...3])
            let vel = Float32.decode(data[4...7])
            let trq = Float32.decode(data[8...11])
            self.delegate?.didMeasurementUpdate(self, position: pos!, velocity: vel!, torque: trq!)
            break
            
        case KMMotor.iMUMeasurementCharUUID:
            let accX = Int16.decode(data[0...1])
            let accY = Int16.decode(data[2...3])
            let accZ = Int16.decode(data[4...5])
            let temp = Int16.decode(data[6...7])
            let gyrX = Int16.decode(data[8...9])
            let gyrY = Int16.decode(data[10...11])
            let gyrZ = Int16.decode(data[12...13])
            
            self.delegate?.didIMUMeasurementUpdate(self, accelX: accX!, accelY: accY!, accelZ: accZ!, temp: temp!, gyroX: gyrX!, gyroY: gyrY!, gyroZ: gyrZ!)
            
            break
            
        default:
            debugPrint("\(#function) unexpedted characteristics UUID, \(characteristic).")
            break
        }
    }
    
    open func peripheralDidUpdateName(_ peripheral: CBPeripheral)
    {
        self.name = peripheral.name ?? "(unknown)"
    }
    
}


extension KMMotor {
    
    // Find Service from a specified UUID
    func findService(_ uuid: CBUUID) -> CBService?
    {
        return (self.peripheral.services?.filter{$0.uuid == uuid}.first)
    }
    
    // Find Characteristic from a specified UUID.
    func findCharacteristic(_ service: CBService, uuid: CBUUID) -> CBCharacteristic?
    {
        return (service.characteristics?.filter{$0.uuid == uuid}.first)
    }
    
    /// Get Task Identifier to manage command tasks
    ///
    /// - Returns: The latest task ID
    private func updateTaskID() -> UInt16
    {
        if taskID >= 65535 {taskID = 0}
        else {taskID += 1}
        return taskID
    }
    
    
    /// Get initial own LED Color from DeviceName
    ///
    /// - Returns: LED Color array with CGFloat type
    public func getOwnColorFromDeviceName() -> [CGFloat]
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        
        let idx = name.index(of: "#")
        
        if let index = idx {
            let red_index = name.index(index, offsetBy: 1)
            let green_index = name.index(index, offsetBy: 2)
            let blue_index = name.index(index, offsetBy: 3)
            
            let r_str = String(name[red_index])
            let g_str = String(name[green_index])
            let b_str = String(name[blue_index])
            
            r = CGFloat(Double(Int(r_str, radix: 16)!) * 17 / 0.5 / 255)
            g = CGFloat(Double(Int(g_str, radix: 16)!) * 17 / 0.5 / 255)
            b = CGFloat(Double(Int(b_str, radix: 16)!) * 17 / 0.5 / 255)
        }
        
        // print("RGB color is \(r,g,b).")
        return [r, g, b]
    }
}




// MARK: - Keigan Motor Read, Write and Notify method via Bluetooth Low Energy
extension KMMotor {
    
    // Set Notification and enable didUpdateValue delegate.
    internal func setNotify(_ characteristic: CBCharacteristic, enabled: Bool)
    {
        peripheral.setNotifyValue(enabled, for: characteristic)
    }
    // Read Value from characteristic
    internal func readValue(_ characteristic: CBCharacteristic)
    {
        peripheral.readValue(for: characteristic)
    }
    // Write bytes to characteristic
    internal func writeValue(_ characteristic: CBCharacteristic, value: [UInt8])
    {
        let data = Data(bytes: UnsafePointer<UInt8>(value), count: value.count)
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse) // Without Respose

        //debugPrint("writeValue: \(characteristic.uuid) value: \(value)")
    }
    // Write data to characteristic
    internal func writeValue(_ characteristic: CBCharacteristic, data: Data)
    {
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse) // Without Respose
        // debugPrint("writeValue: \(characteristic.uuid) data: \(data)")
    }
    

    // Public methods
    public func writeControl(_ command:KMMotorCommand, id:UInt16)
    {
        if let c = controlChar {
            let d = NSMutableData()
            var i = command.rawValue
            taskID = id
            var idt = id.encode()
            d.append(&i, length:1)
            d.append(&idt, length:2)
            
            var crc:UInt16 = 0
            if let c = d.cRC16(){
                crc = c
            } else {
                crc = 0
            }
            d.append(&crc, length:2)
            writeValue(c, data: d as Data)
            
            print("Write \(command), ID:\(id), Value:\(d), CRC16:\(crc)]")
        }
    }
    
    
    public func writeControl(_ command:KMMotorCommand)
    {
        writeControl(command, id: updateTaskID())
    }
    
    
    public func writeControl(_ command:KMMotorCommand, id:UInt16, value:[TypeUtility]){
        
        if let c = controlChar {
            let d = NSMutableData()
            var i = command.rawValue
            taskID = id
            var idt = id.encode()
            d.append(&i, length:1)
            d.append(&idt, length:2)
            
            for v in value {
                var data = v.encode()
                print(data)
                d.append(&data, length:v.length())
            }
            
            var crc:UInt16 = 0
            if let c = d.cRC16(){
                crc = c
            } else {
                crc = 0
            }
            d.append(&crc, length:2)
            writeValue(c, data: d as Data)
            
            print("Write to \(name), \(command), ID:\(id), Value:\(value), CRC16:\(crc)]")
        }
    }
    
    public func writeControl(_ command:KMMotorCommand, value:[TypeUtility]){
        writeControl(command, id: updateTaskID(), value: value)
    }
    
    
    
}


