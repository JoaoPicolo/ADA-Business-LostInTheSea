//
//  Player.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class Player: GameNode {
    private var jumpVelocity = CGFloat(300)
    var life = CGFloat(100)
    
    override init(node: SKSpriteNode) {
        //        node.xScale = 0.5
        //        node.yScale = 0.5
   node.texture = SKTexture(imageNamed: "coral1")
        var textures = [SKTexture]()
                textures.append(SKTexture(imageNamed: "coral1"))
                textures.append(SKTexture(imageNamed: "coral2"))
                textures.append(SKTexture(imageNamed: "coral3"))
                textures.append(SKTexture(imageNamed: "coral1"))
                
                let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: true)
                let animation = SKAction.repeatForever(frames)
                node.run(animation)
        
        super.init(node: node)
        
        physicsSetup()
    }
    
    func physicsSetup() {
        let body = SKPhysicsBody(circleOfRadius: 8)
        body.isDynamic = false
        body.affectedByGravity = true
        body.categoryBitMask = Masks.playerMask
        body.contactTestBitMask = Masks.groundMask | Masks.obstacleMask | Masks.lifeMask
        
        node.physicsBody = body
    }
    
    
    func start() {
        node.physicsBody?.isDynamic = true
        jump()
    }
    
    func jump() {
        node.physicsBody?.velocity.dy = jumpVelocity
    }
    
    func updateLife(points: CGFloat) {
        if points < 0 && life == 0 {
            return
        }
        
        if points > 0 && life == 100 {
            return
        }
        
        life += points
        if life < 0 {
            life = 0
        } else if life > 100 {
            life = 100
        }
        
    }
    
    func die() {
        node.yScale = startScaleY * -1
        node.physicsBody?.linearDamping = 5
        node.removeAllActions()
    }
    
    func reset() {
        node.zRotation = 0
        node.yScale = startScaleY
        node.xScale = startScaleX
        node.position = startPosition
        node.physicsBody?.linearDamping = 0.1
        node.physicsBody?.isDynamic = false
    }
}
