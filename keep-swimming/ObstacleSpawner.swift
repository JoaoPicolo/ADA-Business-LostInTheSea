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
    
    private var calls = 0
    
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
        calls += 1
        
        // Interval
        if currentTime > interval {
            spawn()
            updateInterval()
        }
        
        // Movement
        for obstacle in obstacles {
            obstacle.position.x -= GameManager.speed * deltaTime
            
//            print(deltaTime)
//            if obstaclePos == .middle) {
//                pipe.position.y = sin(pipe.position.x)
//            }
        }
        
        // Only the first must be removed
        if let firstObstacle = obstacles.first {
            if firstObstacle.position.x < -450 {
                firstObstacle.removeFromParent()
                obstacles.removeFirst()
            }
        }
    }
    
    func spawn() {
        let new = obstacleNode.copy() as! SKSpriteNode
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
    }
    
    func getMiddleObstacle(new: SKSpriteNode) {
        let options = ["jellyfish", "seahorse", "starfish"]
        let randomOption = options.randomElement()
        let texture = SKTexture(imageNamed: randomOption!)
        new.texture = texture
        
//        let move = SKAction.moveTo(y: sin(new.position.x), duration: 0.5)
//        let repeatForever = SKAction.repeatForever(move)
//        new.run(repeatForever)
        
    }
    
    func getTopObstacle(new: SKSpriteNode) {
        let options = ["seaweedDown"]
        let randomOption = options.randomElement()
        let texture = SKTexture(imageNamed: randomOption!)
        new.texture = texture
    }
    
    func reset() {
        for pipe in obstacles {
            pipe.removeFromParent()
        }
        obstacles.removeAll()
        
        setTimeConfig()
    }
}
