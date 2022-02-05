//
//  Operations.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 05/02/22.
//

import Foundation
import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func + (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x + scalar, y: left.y + scalar)
}

func - (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x - scalar, y: left.y - scalar)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * scalar, y: left.y * scalar)
}

func / (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / scalar, y: left.y / scalar)
}
