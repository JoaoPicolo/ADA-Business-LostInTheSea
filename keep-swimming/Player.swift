//
//  Player.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class Player: GameNode {
    private var jumpVelocity = CGFloat(500)
    private var animation: SKAction = SKAction()
    
    override init(node: SKSpriteNode) {
        super.init(node: node)
        physicsSetup()
        animationSetup()
    }
    
    func physicsSetup() {
        let body = SKPhysicsBody(circleOfRadius: 12)
        body.isDynamic = false
        body.affectedByGravity = true
        
        node.physicsBody = body
    }
    
    func animationSetup() {
        // Can use atlas
        var textures = [SKTexture]()
        textures.append(SKTexture(imageNamed: "bluebird-downflap"))
        textures.append(SKTexture(imageNamed: "bluebird-midflap"))
        textures.append(SKTexture(imageNamed: "bluebird-upflap"))
        textures.append(SKTexture(imageNamed: "bluebird-midflap"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: true)
        animation = SKAction.repeatForever(frames)
        node.run(animation)
    }
    
    // Start physics
    func start() {
        node.physicsBody?.isDynamic = true
        jump()
    }
    
    func jump() {
        node.physicsBody?.velocity.dy = jumpVelocity
    }
    
    func die() {
        node.yScale = -1
        node.removeAllActions()
    }
    
    func reset() {
        node.yScale = 1
        node.physicsBody?.isDynamic = false
        node.position = startPosition
    }
}
