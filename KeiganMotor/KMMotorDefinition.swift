//
//  KMMotorDefinition.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/12/02.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation

// Grobal
public var curveTypeArray: [KMMotorCurveType] = KMMotorCurveType.cases
public var curveTypeStringArray:[String] { return curveTypeArray.map({$0.description})}

public enum KMMotorCurveType: UInt8,CustomStringConvertible, EnumEnumerable
{
    
    case none         = 0
    case trapezoid    = 1
    
    public var description : String
    {
        switch self {
            
        case .none            : return "Motion Curve None"
        case .trapezoid          : return "Motion Curve Trapezoid"
            
        }
    }
}

// Taskset Index Array
public let tasksetIndexArray:[UInt16] = ([UInt16])(0...49)
// Motion Index Array
public let motionIndexArray:[UInt16] = ([UInt16])(0...9)
