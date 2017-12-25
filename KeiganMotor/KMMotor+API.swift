//
//  KMMotor+API.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/12/01.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation

extension KMMotor {
    
    // MARK: - Write Command to Motor
    
    // MARK: Registers
    
    @discardableResult
    open func maxSpeed(_ speed:Float32) -> Self
    {
        writeControl(KMMotorCommand.maxSpeed, value: [speed])
        return self
    }
    
    @discardableResult
    open func minSpeed(_ speed:Float32) -> Self
    {
        writeControl(KMMotorCommand.minSpeed, value:[speed])
        return self
    }
    
    @discardableResult
    open func curveType(_ curveType:KMMotorCurveType) -> Self
    {
        writeControl(KMMotorCommand.curveType, value:[curveType.rawValue])
        return self
    }
    
    @discardableResult
    open func acc(_ acc:Float32) -> Self
    {
        writeControl(KMMotorCommand.acc, value: [acc])
        return self
    }
    
    @discardableResult
    open func dec(_ dec:Float32) -> Self
    {
        writeControl(KMMotorCommand.dec, value: [dec])
        return self
    }
    
    @discardableResult
    open func maxTorque(_ torque:Float32) -> Self
    {
        writeControl(KMMotorCommand.maxTorque, value: [torque])
        return self
    }
    
    @discardableResult
    open func speedPIDp(_ p:Float32) -> Self
    {
        writeControl(KMMotorCommand.speedPIDp, value: [p])
        return self
    }
    
    @discardableResult
    open func speedPIDi(_ i:Float32) -> Self
    {
        writeControl(KMMotorCommand.speedPIDi, value: [i])
        return self
    }
    
    
    @discardableResult
    open func speedPIDd(_ d:Float32) -> Self
    {
        writeControl(KMMotorCommand.speedPIDd, value: [d])
        return self
    }
    
    @discardableResult
    open func positionPIDp(_ p:Float32) -> Self
    {
        writeControl(KMMotorCommand.positionPIDp, value: [p])
        return self
    }
    
    @discardableResult
    open func resetPID() -> Self
    {
        writeControl(KMMotorCommand.resetPID)
        return self
    }
    
    @discardableResult
    open func limit(current:Float32) -> Self
    {
        writeControl(KMMotorCommand.limitCurrent, value: [current])
        return self
    }

// TODO
//    open func motorMeasurement(flag:UInt8)
//    {
//        writeControl(KMMotorCommand.motorMeasurement, value: [flag])
//    }
//
//    open func interface(flag:UInt8)
//    {
//        writeControl(KMMotorCommand.interface, value: [flag])
//    }
//
//    open func logOutput(flag:UInt8)
//    {
//        writeControl(KMMotorCommand.logOutput, value: [flag])
//    }
//
//    open func ownColor(red:UInt8, green:UInt8, blue:UInt8)
//    {
//        writeControl(KMMotorCommand.ownColor, value: [red,green,blue])
//    }
//
//    open func iMUMeasurement(flag:UInt8)
//    {
//        writeControl(KMMotorCommand.iMUMeasurement, value: [flag])
//    }
    
    @discardableResult
    open func read(register:UInt8) -> Self
    {
        writeControl(KMMotorCommand.iMUMeasurement, value: [register])
        return self
    }
    
    open func saveAllRegisters()
    {
        writeControl(KMMotorCommand.saveAllRegisters)
    }
    
    @discardableResult
    open func reset(register:UInt8) -> Self
    {
        writeControl(KMMotorCommand.resetRegister, value: [register])
        return self
    }
    
    open func resetAllRegisters()
    {
        writeControl(KMMotorCommand.resetAllRegisters)
    }
    
    // MARK: Motor Action
    @discardableResult
    open func disable() -> Self
    {
        writeControl(KMMotorCommand.disable)
        isEnabled = false
        return self
    }
    
    
    @discardableResult
    open func enable() -> Self
    {
        writeControl(KMMotorCommand.enable)
        isEnabled = true
        return self
    }
    
    // Action (Movement)
    @discardableResult
    open func speed(_ speed:Float32) -> Self
    {
        writeControl(KMMotorCommand.speed, value: [speed])
        return self
    }
    
    // Action (Movement)
    @discardableResult
    open func speed(rpm:Float32) -> Self
    {
        let spd:Float32 = rpm * 0.10471975512
        return speed(spd)
    }
    
    
    
    @discardableResult
    open func preset(position:Float32) -> Self
    {
        writeControl(KMMotorCommand.presetPosition, value: [position])
        return self
    }
    
    @discardableResult
    open func runForward() -> Self
    {
        writeControl(KMMotorCommand.runForward)
        return self
    }
    
    @discardableResult
    open func runReverse() -> Self
    {
        writeControl(KMMotorCommand.runReverse)
        return self
    }
    
    @discardableResult
    open func free() -> Self
    {
        writeControl(KMMotorCommand.free)
        return self
    }
    
    @discardableResult
    open func stop() -> Self
    {
        writeControl(KMMotorCommand.stop)
        return self
    }
    
    @discardableResult
    open func move(to position:Float32) -> Self
    {
        writeControl(KMMotorCommand.moveTo, value: [position])
        return self
    }
    
    @discardableResult
    open func move(toDeg:Float32) -> Self
    {
        let pos = toDeg * 0.01745329251
        return move(to: pos)
    }
    
    
    
    @discardableResult
    open func move(by distance:Float32) -> Self
    {
        writeControl(KMMotorCommand.moveBy, value: [distance])
        return self
    }
    
    @discardableResult
    open func move(byDeg:Float32) -> Self
    {
        let dist = byDeg * 0.01745329251
        return move(by:dist)
    }
    
    
    @discardableResult
    open func hold(torque:Float32) -> Self
    {
        writeControl(KMMotorCommand.holdTorque, value: [torque])
        return self
    }
    
    
    // MARK: Do Taskset
    open func doTaskset(at index:UInt16, repeating:UInt32, x:Double)
    {
        writeControl(KMMotorCommand.doTaskset, value:[index, repeating])
    }
    
    // MARK: Playback Motion
    // TODO: repeating and option arguments are not supported
    open func preparePlaybackMotion(at index:UInt16, repeating:UInt32, option:UInt8)
    {
        writeControl(KMMotorCommand.preparePlaybackMotion, value: [index, repeating, option])
    }
    
    open func startPlaybackMotion()
    {
        writeControl(KMMotorCommand.startPlaybackMotion)
    }
    
    open func stopPlaybackMotion()
    {
        writeControl(KMMotorCommand.stopPlaybackMotion)
        
    }
    
    // MARK: Recording Taskset
    open func startRecordingTaskset(at index:UInt16)
    {
        writeControl(KMMotorCommand.startRecordingTaskset, value: [index])
    }
    
    open func stopRecordingTaskset()
    {
        writeControl(KMMotorCommand.stopRecordingTaskset)
    }
    
    open func eraseTaskset(at index: UInt16)
    {
        writeControl(KMMotorCommand.eraseTaskset, value: [index])
    }
    
    open func eraseAllTasksets()
    {
        writeControl(KMMotorCommand.eraseAllTaskset)
    }
    
    
    // MARK: Teaching Motion
    open func prepareTeachingMotion(at index:UInt16, for time:UInt32)
    {
        writeControl(KMMotorCommand.prepareTeachingMotion, value: [index, time])
    }
    
    
    open func startTeachingMotion()
    {
        writeControl(KMMotorCommand.startTeachingMotion)
    }
    
    open func stopTeachingMotion()
    {
        writeControl(KMMotorCommand.stopTeachingMotion)
    }
    
    open func eraseMotion(at index:UInt16)
    {
        writeControl(KMMotorCommand.eraseMotion, value: [index])
    }
    
    open func eraseAllMotion()
    {
        writeControl(KMMotorCommand.eraseAllMotion)
    }
    
    
    // MARK: Queue
    open func pause()
    {
        writeControl(KMMotorCommand.pause)
        isQueuePaused = true
    }
    
    open func resume()
    {
        writeControl(KMMotorCommand.resume)
        isQueuePaused = false
    }
    
    @discardableResult
    open func wait(for time: UInt32) -> Self
    {
        writeControl(KMMotorCommand.wait, value:[time])
        return self
    }
    
    open func reset()
    {
        writeControl(KMMotorCommand.reset)
    }
    
    // MARK: LED
    @discardableResult
    open func led(state:UInt8, red:UInt8, green:UInt8, blue:UInt8) -> Self
    {
        writeControl(KMMotorCommand.led, value:[state, red, green, blue])
        return self
        
    }
    
    // MARK: IMU
    open func enableIMU()
    {
        writeControl(KMMotorCommand.enableIMU)
    }
    
    open func disableIMU()
    {
        writeControl(KMMotorCommand.disableIMU)
    }
    
    // MARK: System
    open func reboot()
    {
        writeControl(KMMotorCommand.reboot)
    }
    
    open func enterDeviceFirmwareUpdate()
    {
        writeControl(KMMotorCommand.enterDeviceFirmwareUpdate)
    }
    
}

// MARK: - Unit Conversion related to Physics and IMU Measurement

public protocol unitConvert {
    // Physics
    func radToDeg() -> Float32
    func DegToRad() -> Float32
    func radPerSecToRPM() -> Float32
    func rPMToRadiansPerSec() -> Float32
    // IMU Measurement
    func accelGravity() -> Float32
    func temperature() -> Float32
    func gyroDegPerSec() -> Float32
    func gyroRadPerSec() -> Float32
}

extension Float32 : unitConvert {
    
    public func radToDeg() -> Float32
    {
        return self * 180 / Float.pi
    }
    public func DegToRad() -> Float32
    {
        return self * Float.pi / 180
    }
    
    public func radPerSecToRPM() -> Float32
    {
        return self * 60 / (2 * Float.pi)
    }
    
    public func rPMToRadiansPerSec() -> Float32
    {
        return self * 2 * Float.pi / 60
    }
    
    public func accelGravity() -> Float32
    {
        return self * 2 / 32767
    }
    
    public func temperature() -> Float32
    {
        return self / 340.00 + 36.53
    }
    
    public func gyroDegPerSec() -> Float32
    {
        return self * 250 / 32767
    }
    
    public func gyroRadPerSec() -> Float32
    {
        return self * 0.00013316211
    }
    
}
