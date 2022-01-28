//
//  GameManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class GameManager {
    static var speed = CGFloat(100)
    static var distance = CGFloat(0)
    static var distanceDisplayed = Int(0)
    
    static func updateDistance(deltaTime: TimeInterval) -> String {
        distance += (deltaTime / 60) * speed
        distanceDisplayed = Int(distance)
        
        return "\(distanceDisplayed) m"
    }
    
    static func reset() {
        distance = 0
        distanceDisplayed = 0
    }
}

enum GameStatus {
    case intro
    case playing
    case gameOver
}
