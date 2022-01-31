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
    
    static var accelaration = CGFloat(0.2)
    
    static func updateDistance(deltaTime: TimeInterval) -> NSAttributedString {
        updateSpeed()
        distance += (deltaTime / 30) * speed
        distanceDisplayed = Int(distance)

        let value = "\(distanceDisplayed) m"
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let finalString = NSAttributedString(string: value, attributes: attributes)
        return finalString
    }
    
    static func updateSpeed() {
        speed = 100 + self.accelaration * self.distance
    }
    
    static func reset() {
        speed = CGFloat(100)
        distance = 0
        distanceDisplayed = 0
    }
}

enum GameStatus {
    case intro
    case playing
    case gameOver
}
