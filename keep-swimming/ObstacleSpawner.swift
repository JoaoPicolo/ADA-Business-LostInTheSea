//
//  ObstacleSpawner.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class ObstacleSpawner {
    private var obstacleNode: SKSpriteNode
    private var obstaclePos: ObstaclePosition
    private var parent: SKNode // Scene root node
    private var obstacles = [SKNode]()
    
    // Will spawn every 3 seconds
    private var interval = TimeInterval(3)
    private var currentTime = TimeInterval(0)
    
    init(obstacleNode: SKSpriteNode, obstaclePos: ObstaclePosition, parent: SKNode, interval: TimeInterval) {
        self.obstacleNode = obstacleNode
        self.obstaclePos = obstaclePos
        self.parent = parent
        self.interval = interval

        currentTime = self.interval
    }
    
    func update(deltaTime: TimeInterval) {
        currentTime += deltaTime
        
        // Interval
        if currentTime > interval {
            spawn()
            currentTime -= interval
        }
        
        // Movement
        for pipe in obstacles {
            pipe.position.x -= GameManager.speed * deltaTime
        }
        
        // Only the first must be removed
        if let firstPipe = obstacles.first {
            if firstPipe.position.x < -400 {
                firstPipe.removeFromParent()
                obstacles.removeFirst()
            }
        }
    }
    
    func spawn() {
        let new = obstacleNode.copy() as! SKSpriteNode
        
        if obstaclePos == .middle {
            new.position.y = CGFloat.random(in: -110...130)
        }
        
        getSpawnObject(new: new)
        parent.addChild(new)
        obstacles.append(new)
    }
    
    func getSpawnObject(new: SKSpriteNode) {
        switch obstaclePos {
        case .bottom:
            getBottomObstacle(new: new)
        case .middle:
            getMiddleObstacle(new: new)
        case .top:
            getTopObstacle(new: new)
        }
    }
    
    func getBottomObstacle(new: SKSpriteNode) {
        let options = ["seaweedUp-1", "seaweedUp-2"]
        let randomOption = options.randomElement()
        new.texture = SKTexture(imageNamed: randomOption!)
    }
    
    func getMiddleObstacle(new: SKSpriteNode) {
        let options = ["jellyfish", "seahorse", "starsea"]
        let randomOption = options.randomElement()
        new.texture = SKTexture(imageNamed: randomOption!)
    }
    
    func getTopObstacle(new: SKSpriteNode) {
        let options = ["seaweedDown"]
        let randomOption = options.randomElement()
        new.texture = SKTexture(imageNamed: randomOption!)
    }
    
    func reset() {
        for pipe in obstacles {
            pipe.removeFromParent()
        }
        obstacles.removeAll()
        
        currentTime = interval
    }
}
