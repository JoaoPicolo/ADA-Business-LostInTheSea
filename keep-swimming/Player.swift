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
    
    override init(node: SKSpriteNode) {
        node.xScale = 0.3
        node.yScale = 0.3
        super.init(node: node)
        
        node.texture = SKTexture(imageNamed: "fish")
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
    
    // Start physics
    func start() {
        node.physicsBody?.isDynamic = true
        jump()
    }
    
    func jump() {
        node.physicsBody?.velocity.dy = jumpVelocity
    }
    
    func die() {
        node.yScale = startScaleY * -1
        node.removeAllActions()
    }
    
    func reset() {
        node.zRotation = 0
        node.yScale = startScaleY
        node.xScale = startScaleX
        node.position = startPosition
        node.physicsBody?.isDynamic = false
    }
}
