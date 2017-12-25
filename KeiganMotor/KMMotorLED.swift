//
//  KMMotorLED.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/12/01.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation

/// Led state of Keigan Motor
public enum KMMotorLEDState : UInt8, CustomStringConvertible {
    
    case off = 0
    case onSolid = 1
    case onFlash = 2
    case onDim = 3
    
    public var description : String
    {
        switch self {
        case .off                 : return "[Motor LED] Off"
        case .onSolid             : return "[Motor LED] On Solid"
        case .onFlash             : return "[Motor LED] On Flash"
        case .onDim               : return "[Motor LED] On Dim"
        }
    }
}


/// Motor LED Class
open class KMMotorLED {
    
    var state: KMMotorLEDState?
    var red: UInt8
    var green: UInt8
    var blue: UInt8
    
    init() {
        self.state = .off
        self.red = 0
        self.green = 0
        self.blue = 0
    }
}

