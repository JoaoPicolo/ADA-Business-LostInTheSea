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
    private var animation = SKAction()
    var life = CGFloat(100)
    
    override init(node: SKSpriteNode) {
        super.init(node: node)
        
        physicsSetup()
        setTextures()
    }
    
    private func physicsSetup() {
        let body = SKPhysicsBody(circleOfRadius: 8)
        body.isDynamic = false
        body.affectedByGravity = true
        body.categoryBitMask = Masks.playerMask
        body.contactTestBitMask = Masks.groundMask | Masks.obstacleMask | Masks.lifeMask
        body.collisionBitMask = Masks.groundMask
        
        node.physicsBody = body
        
        let xConstraint = SKConstraint.positionX(SKRange(constantValue: node.position.x))
        let zConstraint = SKConstraint.zRotation(SKRange(constantValue: 0))
        node.constraints = [xConstraint, zConstraint]
    }
    
    private func setTextures() {
        node.texture = SKTexture(imageNamed: "coral1")
        
        var textures = [SKTexture]()
        textures.append(SKTexture(imageNamed: "coral1"))
        textures.append(SKTexture(imageNamed: "coral2"))
        textures.append(SKTexture(imageNamed: "coral3"))
        textures.append(SKTexture(imageNamed: "coral1"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: true, restore: true)
        animation = SKAction.repeatForever(frames)
        
        node.run(animation)
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
        life = 100

        node.yScale = startScaleY
        node.xScale = startScaleX
        node.position = startPosition
        node.physicsBody?.linearDamping = 0.1
        node.physicsBody?.isDynamic = false
        node.run(animation)
    }
}
