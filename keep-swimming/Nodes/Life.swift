//
//  Life.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 03/02/22.
//

import Foundation
import SpriteKit

class Life {
    private var node: SKSpriteNode
    private var position: ObjectPosition
    private var parent: SKNode // Scene root node
    private var nodes = [SKNode]()
    
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
        for item in nodes {
            item.position.x -= GameManager.shared.speed * deltaTime
        }
        
        // Only the first must be removed
        if let firstItem = nodes.first {
            if firstItem.position.x < -450 {
                firstItem.removeFromParent()
                nodes.removeFirst()
            }
        }
    }
    
    func spawn() {
        let new = node.copy() as! SKSpriteNode
        
        let body = SKPhysicsBody(circleOfRadius: 20)
        body.isDynamic = false
        body.categoryBitMask = Masks.obstacleMask
        body.contactTestBitMask = Masks.playerMask
        body.collisionBitMask = Masks.none
        new.physicsBody = body
        
        new.texture = SKTexture(imageNamed: "life")
        new.position.y = CGFloat.random(in: -80...120)
        parent.addChild(new)
        nodes.append(new)
    }
    

    func reset() {
        for item in nodes {
            item.removeFromParent()
        }
        nodes.removeAll()
        
        setTimeConfig()
    }
}


