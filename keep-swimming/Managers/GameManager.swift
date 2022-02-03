//
//  GameManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class GameManager: NSObject {
    static let shared = GameManager()
    
    var initialSpeed = CGFloat(100)
    var speed = CGFloat(100)
    var distance = CGFloat(0)
    var distanceDisplayed = Int(0)
    
    var accelaration = CGFloat(1)
    
    func updateDistance(deltaTime: TimeInterval) -> NSAttributedString {
        if speed <= 500 {
            updateSpeed()
        }
        
        distance += (deltaTime / 30) * speed
        distanceDisplayed = Int(distance)

        let value = "\(distanceDisplayed) m"
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let finalString = NSAttributedString(string: value, attributes: attributes)
        return finalString
    }
    
    func updateSpeed() {
        speed = initialSpeed + self.accelaration * self.distance
    }
    
    func reset() {
        speed = initialSpeed
        distance = 0
        distanceDisplayed = 0
    }
}

enum GameStatus {
    case intro
    case playing
    case gameOver
}
