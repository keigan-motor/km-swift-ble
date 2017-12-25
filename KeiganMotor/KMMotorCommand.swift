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
            
        case .maxSpeed                 : return "[Motor Command] Max Speed"
        case .minSpeed                 : return "[Motor Command] Min Speed"
        case .curveType                : return "[Motor Command] Curve Type"
        case .acc                      : return "[Motor Command] Acc"
        case .dec                      : return "[Motor Command] Dec"
        case .maxTorque                : return "[Motor Command] Max Torque"
        case .qCurrentPIDp             : return "[Motor Command] Q-axis Current PID P"
        case .qCurrentPIDi             : return "[Motor Command] Q-axis Current PID I"
        case .qCurrentPIDd             : return "[Motor Command] Q-axis Current PID D"
        case .speedPIDp                : return "[Motor Command] Speed PID P"
        case .speedPIDi                : return "[Motor Command] Speed PID I"
        case .speedPIDd                : return "[Motor Command] Speed PID D"
        case .positionPIDp             : return "[Motor Command] Position PID P"
        case .resetPID                 : return "[Motor Command] Reset PID"
        case .limitCurrent             : return "[Motor Command] Limit Current"
        case .motorMeasurement         : return "[Motor Command] Motor Measurement"
        case .interface                : return "[Motor Command] Interface"
        case .logOutput                : return "[Motor Command] Log Output"
        case .ownColor                 : return "[Motor Command] Own Color"
        case .iMUMeasurement           : return "[Motor Command] IMU Measurement"
        case .readRegister             : return "[Motor Command] Read Register"
        case .saveAllRegisters         : return "[Motor Command] Save All Registers"
        case .resetRegister            : return "[Motor Command] Reset Register"
        case .resetAllRegisters        : return "[Motor Command] Reset All Registers"
            
        case .disable                  : return "[Motor Command] Disable"
        case .enable                   : return "[Motor Command] Enable"
        case .speed                    : return "[Motor Command] Speed"
        case .presetPosition           : return "[Motor Command] Reset Position"
        case .runForward               : return "[Motor Command] Run Forward"
        case .runReverse               : return "[Motor Command] Run Reverse"
        case .runAtVelocity            : return "[Motor Command] Run At Velocity"
        case .moveTo                   : return "[Motor Command] Move To"
        case .moveBy                   : return "[Motor Command] Move By"
        case .free                     : return "[Motor Command] Free"
        case .stop                     : return "[Motor Command] Stop"
        case .holdTorque               : return "[Motor Command] HoldTorque"
            
        case .doTaskset                : return "[Motor Command] DoTaskset"
            
        case .preparePlaybackMotion    : return "[Motor Command] PreparePlaybackMotion"
        case .startPlaybackMotion      : return "[Motor Command] StartPlaybackMotion"
        case .stopPlaybackMotion       : return "[Motor Command] StopPlaybackMotion"
            
        case .startRecordingTaskset    : return "[Motor Command] StartRecordingTaskset"
        case .stopRecordingTaskset     : return "[Motor Command] StopRecordingTaskset"
        case .eraseTaskset             : return "[Motor Command] EraseTaskset"
        case .eraseAllTaskset          : return "[Motor Command] EraseAllTaskset"
            
        case .prepareTeachingMotion    : return "[Motor Command] PrepareTeachingMotion"
        case .startTeachingMotion      : return "[Motor Command] StartTeachingMotion"
        case .stopTeachingMotion       : return "[Motor Command] StopTeachingMotion"
        case .eraseMotion              : return "[Motor Command] EraseMotion"
        case .eraseAllMotion           : return "[Motor Command] EraseAllMotion"
            
        case .pause                    : return "[Motor Command] Pause"
        case .resume                   : return "[Motor Command] Resume"
        case .wait                     : return "[Motor Command] Wait"
        case .reset                    : return "[Motor Command] Reset"
            
        case .led                      : return "[Motor Command] Led"
            
        case .enableIMU                : return "[Motor Command] EnableIMU"
        case .disableIMU               : return "[Motor Command] DisableIMU"
            
        case .reboot                   : return "[Motor Command] Reboot"
        case .enterDeviceFirmwareUpdate: return "[Motor Command] EnterDeviceFirmwareUpdate"
            
        }
    }
    
    
}
