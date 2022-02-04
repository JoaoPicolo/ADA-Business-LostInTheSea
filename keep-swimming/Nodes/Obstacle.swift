//
//  Obstacle.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 03/02/22.
//

import Foundation
import SpriteKit

class Obstacle {
     var node: SKSpriteNode
     var position: ObjectPosition
     var parent: SKNode // Scene root node
     var obstacles = [ObstacleSpriteNode]()
    
    // Will spawn every 3 seconds
    private var lowerInterval = CGFloat(1)
    private var upperInterval: CGFloat
    private var interval = TimeInterval(3)
    private var currentTime = TimeInterval(0)
    
    private var calls = 0
    
    init(node: SKSpriteNode, position: ObjectPosition, parent: SKNode, upperInterval: CGFloat) {
        self.node = node
        self.position = position
        self.parent = parent
        self.upperInterval = upperInterval
        
        setTimeConfig()
    }
    
    func setTimeConfig() {
        interval = CGFloat.random(in: 1...upperInterval)
        currentTime = interval
    }
    
    func updateInterval() {
        // Keep incrementing a value, instead of using just game speed -> Adds a value
        let newValue = (upperInterval * GameManager.shared.initialSpeed) / GameManager.shared.speed
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
            obstacle.position.x -= GameManager.shared.speed * deltaTime
        }
        
        // Only the first must be removed
        if let firstObstacle = obstacles.first {
            if firstObstacle.position.x < -450 {
                firstObstacle.removeFromParent()
                obstacles.removeFirst()
            }
        }
    }
    
    func spawn() { // to do (fix)
        let new = node.copy() as! ObstacleSpriteNode
        
        let body = SKPhysicsBody(circleOfRadius: 20)
        body.isDynamic = false
        body.categoryBitMask = Masks.obstacleMask
        body.contactTestBitMask = Masks.playerMask
        body.collisionBitMask = Masks.none
        new.physicsBody = body
        
        if position == .middle {
            new.position.y = CGFloat.random(in: -80...120)
        }
        
        getSpawnObject(new: new)
        parent.addChild(new)
        obstacles.append(new)
    }
    
    func getSpawnObject(new: SKSpriteNode) {
        var obstacle: ObstacleSpriteNode
        
        switch position {
        case .bottom:
            obstacle = Obstacles.obstaclesBottom.randomElement()!
        case .middle:
            obstacle = Obstacles.obstaclesMiddle.randomElement()!
        case .top:
            obstacle = Obstacles.obstaclesTop.randomElement()!
        }
        
        addAnimations(new: new, obstacle: obstacle)
    }
    
    func addAnimations(new: SKSpriteNode, obstacle: ObstacleSpriteNode) {
        var textures = [SKTexture]()
        for frame in obstacle.imageSequence {
            textures.append(SKTexture(imageNamed: frame))
        }
        let frames = SKAction.animate(with: textures, timePerFrame: 0.5, resize: false, restore: true)
        let animation = SKAction.repeatForever(frames)
        new.run(animation)
        
        if position == .middle {
            // Change start pointing depending on object initial position
            // Calibrate range, timing, etc
            let move = SKAction.moveTo(y: 5, duration: 1)
            move.timingMode = .easeInEaseOut // Does sin()
            let moveBack = SKAction.moveTo(y: -5, duration: 1)
            move.timingMode = .easeInEaseOut
            let sequence = SKAction.sequence([move, moveBack])
            let repeatForever = SKAction.repeatForever(sequence)
            new.run(repeatForever)
        }
        print(new)
    }
    
    func reset() {
        for obstacle in obstacles {
            obstacle.removeFromParent()
        }
        obstacles.removeAll()
        
        setTimeConfig()
    }
}

