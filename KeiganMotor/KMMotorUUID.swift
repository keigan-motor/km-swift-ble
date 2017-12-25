//
//  KMMotorUUID.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/11/07.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation
import CoreBluetooth

class KMMotorUUID: NSObject {
    
    static let serviceUUIDString =            "f140ea35-8936-4d35-a0ed-dfcd795baa8c"
    
    static let charControlUUIDString =        "f1400001-8936-4d35-a0ed-dfcd795baa8c"
    // static let charLogUUIDString =            "f1400002-8936-4d35-a0ed-dfcd795baa8c"
    static let charLEDUUIDString =            "f1400003-8936-4d35-a0ed-dfcd795baa8c"
    static let charMeasurementUUIDString =    "f1400004-8936-4d35-a0ed-dfcd795baa8c"
    static let charIMUMeasurementUUIDString = "f1400005-8936-4d35-a0ed-dfcd795baa8c"
    static let charSettingUUIDString =        "f1400006-8936-4d35-a0ed-dfcd795baa8c"
    
}
