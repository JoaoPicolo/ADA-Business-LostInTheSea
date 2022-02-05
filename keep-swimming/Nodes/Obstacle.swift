//
//  Obstacle.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 05/02/22.
//

import Foundation
import SpriteKit

class Obstacle {
    var node: SKSpriteNode
    var obstacleStruct: ObstacleStruct
    private var position: Positions
    
    init(node: SKSpriteNode, obstacleStruct: ObstacleStruct, position: Positions) {
        self.node = node
        self.obstacleStruct = obstacleStruct
        self.position = position
        
        node.userData = NSMutableDictionary()
        node.userData?.setValue("obstacle", forKey: "category")
        
        setStructConfig()
    }
    
    private func setStructConfig() {
        setPhysics()
        setTextures()
        
        if position == .middle {
            setAnimations()
            node.position.y = CGFloat.random(in: -80...100)
        }
    }
    
    private func setPhysics() {
        let body = SKPhysicsBody(circleOfRadius: 30)
        body.isDynamic = false
        body.categoryBitMask = Masks.obstacleMask
        body.contactTestBitMask = Masks.playerMask
        body.collisionBitMask = Masks.none
        
        node.physicsBody = body
    }
    
    private func setTextures() {
        var textures = [SKTexture]()
        for image in obstacleStruct.imageSequence {
            textures.append(SKTexture(imageNamed: image))
        }
        let frames = SKAction.animate(with: textures, timePerFrame: 0.5, resize: true, restore: true)
        let animation = SKAction.repeatForever(frames)

        node.xScale = obstacleStruct.scale
        node.yScale = obstacleStruct.scale
        node.run(animation)
    }
    
    private func setAnimations() {
        // Change start pointing depending on object initial position
        // Calibrate range, timing, etc
        let moveUp = SKAction.moveTo(y: obstacleStruct.range, duration: 1)
        moveUp.timingMode = .easeInEaseOut
        
        let moveDown = SKAction.moveTo(y: -obstacleStruct.range, duration: 1)
        moveDown.timingMode = .easeInEaseOut

        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeatForever = SKAction.repeatForever(sequence)

        node.run(repeatForever)
    }
}
