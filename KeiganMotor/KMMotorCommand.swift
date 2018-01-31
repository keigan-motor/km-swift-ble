//
//  KMMotorCommand.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/11/07.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation

/// Grobal CommandArray
public var commandArray: [KMMotorCommand] = KMMotorCommand.cases
public var commandStringArray:[String] { return commandArray.map({$0.description})}

/// Commands to send to Keigan Motor
public enum KMMotorCommand : UInt8, CustomStringConvertible, EnumEnumerable
{
    // Registers
    case maxSpeed               = 0x02
    case minSpeed               = 0x03
    case curveType              = 0x05
    case acc                    = 0x07
    case dec                    = 0x08
    case maxTorque              = 0x0E
    case qCurrentPIDp           = 0x18
    case qCurrentPIDi           = 0x19
    case qCurrentPIDd           = 0x1A
    case speedPIDp              = 0x1B
    case speedPIDi              = 0x1C
    case speedPIDd              = 0x1D
    case positionPIDp           = 0x1E
    case resetPID               = 0x22
    case limitCurrent           = 0x25
    case motorMeasurement       = 0x2C
    case interface              = 0x2E
    case logOutput              = 0x30
    case ownColor               = 0x3A
    case iMUMeasurement         = 0x3D
    case readRegister           = 0x40
    case saveAllRegisters       = 0x41
    case resetRegister          = 0x4E
    case resetAllRegisters      = 0x4F
    
    // Action
    case disable                = 0x50
    case enable                 = 0x51
    case speed                  = 0x58
    case presetPosition         = 0x5A
    case runForward             = 0x60
    case runReverse             = 0x61
    case runAtVelocity          = 0x62
    case moveTo                 = 0x66
    case moveBy                 = 0x68
    case free                   = 0x6C
    case stop                   = 0x6D
    case holdTorque             = 0x72
    
    // Do Taskset
    case doTaskset              = 0x81
    
    // Playback Motion
    case preparePlaybackMotion  = 0x86
    case startPlaybackMotion    = 0x87
    case stopPlaybackMotion     = 0x88
    
    // Recording Taskset
    case startRecordingTaskset  = 0xA0
    case stopRecordingTaskset   = 0xA2
    case eraseTaskset           = 0xA3
    case eraseAllTaskset        = 0xA4
    
    // Teaching Motion
    case prepareTeachingMotion  = 0xAA
    case startTeachingMotion    = 0xAB
    case stopTeachingMotion     = 0xAC
    case eraseMotion            = 0xAD
    case eraseAllMotion         = 0xAE
    
    
    // Motor Task Queue
    case pause                  = 0x90
    case resume                 = 0x91
    case wait                   = 0x92
    case reset                  = 0x95
    
    // LED
    case led                    = 0xE0
    
    // IMU
    case enableIMU              = 0xEA
    case disableIMU             = 0xEB
    
    // System
    case reboot                 = 0xF0
    case enterDeviceFirmwareUpdate = 0xFD
    
    
    public var description : String
    {
        switch self {
            
        case .maxSpeed                 : return "[CMD] Max Speed"
        case .minSpeed                 : return "[CMD] Min Speed"
        case .curveType                : return "[CMD] Curve Type"
        case .acc                      : return "[CMD] Acc"
        case .dec                      : return "[CMD] Dec"
        case .maxTorque                : return "[CMD] Max Torque"
        case .qCurrentPIDp             : return "[CMD] Q-axis Current PID P"
        case .qCurrentPIDi             : return "[CMD] Q-axis Current PID I"
        case .qCurrentPIDd             : return "[CMD] Q-axis Current PID D"
        case .speedPIDp                : return "[CMD] Speed PID P"
        case .speedPIDi                : return "[CMD] Speed PID I"
        case .speedPIDd                : return "[CMD] Speed PID D"
        case .positionPIDp             : return "[CMD] Position PID P"
        case .resetPID                 : return "[CMD] Reset PID"
        case .limitCurrent             : return "[CMD] Limit Current"
        case .motorMeasurement         : return "[CMD] Motor Measurement"
        case .interface                : return "[CMD] Interface"
        case .logOutput                : return "[CMD] Log Output"
        case .ownColor                 : return "[CMD] Own Color"
        case .iMUMeasurement           : return "[CMD] IMU Measurement"
        case .readRegister             : return "[CMD] Read Register"
        case .saveAllRegisters         : return "[CMD] Save All Registers"
        case .resetRegister            : return "[CMD] Reset Register"
        case .resetAllRegisters        : return "[CMD] Reset All Registers"
            
        case .disable                  : return "[CMD] Disable"
        case .enable                   : return "[CMD] Enable"
        case .speed                    : return "[CMD] Speed"
        case .presetPosition           : return "[CMD] Reset Position"
        case .runForward               : return "[CMD] Run Forward"
        case .runReverse               : return "[CMD] Run Reverse"
        case .runAtVelocity            : return "[CMD] Run At Velocity"
        case .moveTo                   : return "[CMD] Move To"
        case .moveBy                   : return "[CMD] Move By"
        case .free                     : return "[CMD] Free"
        case .stop                     : return "[CMD] Stop"
        case .holdTorque               : return "[CMD] HoldTorque"
            
        case .doTaskset                : return "[CMD] DoTaskset"
            
        case .preparePlaybackMotion    : return "[CMD] PreparePlaybackMotion"
        case .startPlaybackMotion      : return "[CMD] StartPlaybackMotion"
        case .stopPlaybackMotion       : return "[CMD] StopPlaybackMotion"
            
        case .startRecordingTaskset    : return "[CMD] StartRecordingTaskset"
        case .stopRecordingTaskset     : return "[CMD] StopRecordingTaskset"
        case .eraseTaskset             : return "[CMD] EraseTaskset"
        case .eraseAllTaskset          : return "[CMD] EraseAllTaskset"
            
        case .prepareTeachingMotion    : return "[CMD] PrepareTeachingMotion"
        case .startTeachingMotion      : return "[CMD] StartTeachingMotion"
        case .stopTeachingMotion       : return "[CMD] StopTeachingMotion"
        case .eraseMotion              : return "[CMD] EraseMotion"
        case .eraseAllMotion           : return "[CMD] EraseAllMotion"
            
        case .pause                    : return "[CMD] Pause"
        case .resume                   : return "[CMD] Resume"
        case .wait                     : return "[CMD] Wait"
        case .reset                    : return "[CMD] Reset"
            
        case .led                      : return "[CMD] Led"
            
        case .enableIMU                : return "[CMD] EnableIMU"
        case .disableIMU               : return "[CMD] DisableIMU"
            
        case .reboot                   : return "[CMD] Reboot"
        case .enterDeviceFirmwareUpdate: return "[CMD] EnterDeviceFirmwareUpdate"
            
        }
    }
    
    
}
