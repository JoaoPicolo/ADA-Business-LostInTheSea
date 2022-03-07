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
    
    private let lock = NSLock()
    private var lookedDistances = [Int]()
    
    func updateDistance(deltaTime: TimeInterval) -> NSAttributedString {
        if speed <= 500 {
            updateSpeed()
        }
        
        distance += (deltaTime / 30) * speed
        distanceDisplayed = Int(distance)
        
        if (distanceDisplayed % 100 == 0) && (distanceDisplayed > 0) {
            updateAchievements(distance: distanceDisplayed)
        }
        
        let value = "\(distanceDisplayed) m"
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont(name: "SingleDay-Regular", size: 16)!]
        let finalString = NSAttributedString(string: value, attributes: attributes)
        return finalString
    }
    
    func updateSpeed() {
        speed = initialSpeed + self.accelaration * self.distance
    }
    
    func updateAchievements(distance: Int) {
        lock.lock()
        if !lookedDistances.contains(distance) {
            lookedDistances.append(distance)
            if distance == 100 {
                LeaderboardManager.shared.updateAchievement(id: "distance100", value: 100, total: 100)
            } else if distance == 500 {
                LeaderboardManager.shared.updateAchievement(id: "distance500", value: 500, total: 500)
            } else if distance == 1000 {
                LeaderboardManager.shared.updateAchievement(id: "distance1000", value: 1000, total: 1000)
            } else if distance == 15000 {
                LeaderboardManager.shared.updateAchievement(id: "distance15000", value: 15000, total: 15000)
            } else if distance == 20000 {
                LeaderboardManager.shared.updateAchievement(id: "distance20000", value: 20000, total: 20000)
            } else if distance == 100000 {
                LeaderboardManager.shared.updateAchievement(id: "distance100000", value: 100000, total: 100000)
            }
        }
        lock.unlock()
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
    case adChoice
}
