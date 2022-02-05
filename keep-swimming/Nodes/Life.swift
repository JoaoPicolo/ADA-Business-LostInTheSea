//
//  Life.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 03/02/22.
//

import Foundation
import SpriteKit

class Life: GameNode {
    override init(node: SKSpriteNode) {
        super.init(node: node)
        
        node.userData = NSMutableDictionary()
        node.userData?.setValue("life", forKey: "category")
        
        setStructConfig()
    }
    
    private func setStructConfig() {
        setTexture()
        setPhysics()
        setAnimations()
        node.position.y = CGFloat.random(in: -80...100)
    }
    
    private func setPhysics() {
        let body = SKPhysicsBody(circleOfRadius: 10)
        body.isDynamic = false
        body.categoryBitMask = Masks.obstacleMask
        body.contactTestBitMask = Masks.playerMask
        body.collisionBitMask = Masks.none
        
        node.physicsBody = body
    }
    
    private func setTexture() {
        let texture = SKTexture(imageNamed: "life")
        node.texture = texture
        node.size = texture.size()
    }
    
    private func setAnimations() {
        // Change start pointing depending on object initial position
        // Calibrate range, timing, etc
        let moveUp = SKAction.moveTo(y: 3, duration: 1)
        moveUp.timingMode = .easeInEaseOut
        
        let moveDown = SKAction.moveTo(y: -3, duration: 1)
        moveDown.timingMode = .easeInEaseOut
        
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeatForever = SKAction.repeatForever(sequence)
        
        node.run(repeatForever)
    }
}


