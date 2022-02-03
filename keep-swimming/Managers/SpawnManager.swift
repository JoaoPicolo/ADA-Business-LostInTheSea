//
//  SpawnManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 28/01/22.
//

import Foundation
import SpriteKit

enum ObjectPosition: CaseIterable {
    case bottom
    case middle
    case top
}

class SpawnManager {
    private var parent: SKNode!
    private var bottomObstacle: Obstacle!
    private var middleObstacle: Obstacle!
    private var topObstacle: Obstacle!

    private var life: Life!
    
    init(parent: SKNode) {
        self.parent = parent
        setSpawnObstacles()
    }
    
    func setSpawnObstacles() {
        let bottomNode = parent.childNode(withName: "bottomObstacle") as! SKSpriteNode
        bottomObstacle = Obstacle(node: bottomNode, position: .bottom, parent: parent, upperInterval: CGFloat(5))
        
        let middleNode = parent.childNode(withName: "middleObstacle") as! SKSpriteNode
        middleObstacle = Obstacle(node: middleNode, position: .middle, parent: parent, upperInterval: CGFloat(3))
        
        let topNode = parent.childNode(withName: "topObstacle") as! SKSpriteNode
        topObstacle = Obstacle(node: topNode, position: .top, parent: parent, upperInterval: CGFloat(4))
        
        let lifeNode = parent.childNode(withName: "life") as! SKSpriteNode
        life = Life(node: lifeNode, position: .middle, parent: parent, upperInterval: CGFloat(25))
    }

    func updateSpawns(deltaTime: TimeInterval) {
        bottomObstacle.update(deltaTime: deltaTime)
        middleObstacle.update(deltaTime: deltaTime)
        topObstacle.update(deltaTime: deltaTime)
        life.update(deltaTime: deltaTime)
    }
    
    func resetSpawns() {
        bottomObstacle.reset()
        middleObstacle.reset()
        topObstacle.reset()
        life.reset()
    }
}
