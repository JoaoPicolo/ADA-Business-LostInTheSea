//
//  Masks.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 31/01/22.
//

import Foundation

class Masks {
    static var playerMask: UInt32 = 0x1 << 0
    static var groundMask: UInt32 = 0x1 << 1
    static var obstacleMask: UInt32 = 0x1 << 2
    static var lifeMask: UInt32 = 0x1 << 3
    static var none: UInt32 = 0x0
}
