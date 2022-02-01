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
    private var lowerInterval = CGFloat(1)
    private var upperInterval: CGFloat
    private var interval = TimeInterval(3)
    private var currentTime = TimeInterval(0)
    
    init(obstacleNode: SKSpriteNode, obstaclePos: ObstaclePosition, parent: SKNode, upperInterval: CGFloat) {
        self.obstacleNode = obstacleNode
        self.obstaclePos = obstaclePos
        self.parent = parent
        self.upperInterval = upperInterval
        
        setTimeConfig()
    }
    
    func setTimeConfig() {
        interval = CGFloat.random(in: 1...upperInterval)
        currentTime = interval
    }
    
    func updateInterval() {
        let newValue = (upperInterval * GameManager.initialSpeed) / GameManager.speed
        if newValue >= lowerInterval {
            interval = CGFloat.random(in: lowerInterval...newValue)
        }
        
        currentTime -= interval
    }
    
    func update(deltaTime: TimeInterval) {
        currentTime += deltaTime
        
        // Interval
        if currentTime > interval {
            spawn()
            updateInterval()
        }
        
        // Movement
        for pipe in obstacles {
            pipe.position.x -= GameManager.speed * deltaTime
        }
        
        // Only the first must be removed
        if let firstPipe = obstacles.first {
            if firstPipe.position.x < -450 {
                firstPipe.removeFromParent()
                obstacles.removeFirst()
            }
        }
    }
    
    func spawn() {
        let new = obstacleNode.copy() as! SKSpriteNode
//        new.xScale = 0.5
//        new.yScale = 0.5
        new.alpha = 1
        
        let body = SKPhysicsBody(circleOfRadius: 20)
        body.isDynamic = false
        body.categoryBitMask = Masks.obstacleMask
        body.contactTestBitMask = Masks.playerMask
        new.physicsBody = body
        
        if obstaclePos == .middle {
            new.position.y = CGFloat.random(in: -80...120)
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
        let texture = SKTexture(imageNamed: randomOption!)
        new.texture = texture
//        new.physicsBody = getObstacleBodyMask(texture: texture)
    }
    
    func getMiddleObstacle(new: SKSpriteNode) {
        let options = ["jellyfish", "seahorse", "starfish"]
        let randomOption = options.randomElement()
        let texture = SKTexture(imageNamed: randomOption!)
        new.texture = texture
//        new.physicsBody = getObstacleBodyMask(texture: texture)
    }
    
    func getTopObstacle(new: SKSpriteNode) {
        let options = ["seaweedDown"]
        let randomOption = options.randomElement()
        let texture = SKTexture(imageNamed: randomOption!)
        new.texture = texture
//        new.physicsBody = getObstacleBodyMask(texture: texture)
    }
    
    func getObstacleBodyMask(texture: SKTexture) -> SKPhysicsBody {
        let body = SKPhysicsBody(texture: texture, size: texture.size())
        body.isDynamic = false
        body.categoryBitMask = Masks.obstacleMask
        body.contactTestBitMask = Masks.playerMask
        return body
    }
    
    func reset() {
        for pipe in obstacles {
            pipe.removeFromParent()
        }
        obstacles.removeAll()
        
        setTimeConfig()
    }
}
