//
//  TypeUtility.swift
//  KeiganMotor
//
//  Created by Takashi Tokuda on 2017/12/02.
//  Copyright © 2017年 Takashi Tokuda. All rights reserved.
//

import Foundation

public typealias Byte = UInt8

/// Encoding and decoding data related to Bluetooth Low Energy data process with BigEndian
/// NOTE) On the condition that host computer is LittleEndian
/// Encode data to bytes array
/// Decode bytes array to data
public protocol TypeUtility {
    func encode() -> [Byte]
    static func decode(_ data: Array<Byte>) -> Self?
    func length() -> Int
}


extension UInt8 : TypeUtility {
    public func encode() -> [Byte]
    {
        return [self]
    }
    
    public static func decode<C: Collection>(_ data: C) -> UInt8? where C.Iterator.Element == Byte ,C.Index == Int
    {
        guard data.count >= 1 else {
            assert(false, #function)
            return nil
        }
        let bytes = Array(data)
        return bytes[0]
    }
    
    public func length() -> Int {
        return MemoryLayout<UInt8>.size
    }
}

extension Int8 : TypeUtility {
    public func encode() -> [Byte]
    {
        return [UInt8.init(bitPattern: self)]
    }
    
    public static func decode<C: Collection>(_ data: C) -> Int8? where C.Iterator.Element == Byte ,C.Index == Int
    {
        guard data.count >= 1 else {
            assert(false, #function)
            return nil
        }
        let bytes = Array(data)
        return Int8.init(bitPattern: bytes[0])
    }
    
    public func length() -> Int {
        return MemoryLayout<Int8>.size
    }
}

extension UInt16 : TypeUtility {
    public func encode() -> [Byte]
    {
        var buf = [UInt8](repeating: 0, count: 2)
        
        buf[1] = UInt8(UInt16(0x00ff) & self)
        buf[0] = UInt8(UInt16(0x00ff) & (self >> 8))

        return buf
    }
    
    public static func decode<C: Collection>(_ data: C) -> UInt16? where C.Iterator.Element == Byte ,C.Index == Int
    {
        guard data.count >= 2 else {
            assert(false, #function)
            return nil
        }
        let bytes = Array(data)
        return UInt16(bytes[0]) << 8 + UInt16(bytes[1])
    }
    
    public func length() -> Int {
        return MemoryLayout<UInt16>.size
    }
}

extension Int16 : TypeUtility {
    public func encode() -> [Byte]
    {
        let v = UInt16(bitPattern: self)
        return v.encode()
    }
    
    public static func decode<C: Collection>(_ data: C) -> Int16? where C.Iterator.Element == Byte ,C.Index == Int
    {
        guard let value = UInt16.decode(data) else {
            assert(false, #function)
            return nil
        }
        return Int16(bitPattern: value)
    }
    
    public func length() -> Int {
        return MemoryLayout<Int16>.size
    }
}

extension UInt32 : TypeUtility {
    public func encode() -> [Byte]
    {
        var buf = [UInt8](repeating: 0, count: 4)
        
        buf[3] = UInt8(UInt32(0x00ff) & (self >> 0))
        buf[2] = UInt8(UInt32(0x00ff) & (self >> 8))
        buf[1] = UInt8(UInt32(0x00ff) & (self >> 16))
        buf[0] = UInt8(UInt32(0x00ff) & (self >> 24))

        return buf
    }
    
    public static func decode<C: Collection>(_ data: C) -> UInt32? where C.Iterator.Element == Byte ,C.Index == Int
    {
        guard data.count >= 4 else {
            assert(false, #function)
            return nil
        }
        let bytes = Array(data)
        let b1 = UInt32(bytes[0]) << 24 + UInt32(bytes[1]) << 16
        let b2 = UInt32(bytes[2]) << 8  + UInt32(bytes[3])
        return b1 + b2

    }
    
    public func length() -> Int {
        return MemoryLayout<UInt32>.size
    }
}

extension Int32 : TypeUtility {
    public func encode() -> [Byte]
    {
        let v = UInt32(bitPattern: self)
        return v.encode()
    }
    
    public static func decode<C: Collection>(_ data: C) -> Int32? where C.Iterator.Element == Byte ,C.Index == Int
    {
        guard let value = UInt32.decode(data) else {
            assert(false, #function)
            return nil
        }
        return Int32(bitPattern: value)
    }
    
    public func length() -> Int {
        return MemoryLayout<Int32>.size
    }
}

extension Float32 : TypeUtility {
    public func encode() -> [Byte]
    {
        return self.bitPattern.encode()
    }
    public static func decode<C: Collection>(_ data: C) -> Float32? where C.Iterator.Element == Byte ,C.Index == Int
    {
        guard let value = UInt32.decode(data) else {
            assert(false, #function)
            return nil
        }
        return Float.init(bitPattern: value)
    }
    
    public func length() -> Int {
        return MemoryLayout<Float32>.size
    }
}


protocol _UInt8Type { }
extension UInt8: _UInt8Type {}
extension Array where Element : _UInt8Type {
    func toHexString() -> String
    {
        var s = String()
        for (_, value) in self.enumerated() {
            s += String(format:"0x%02x,", value as! CVarArg)
        }
        return s
    }
}

