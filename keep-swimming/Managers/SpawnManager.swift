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

struct ObjectType {
    var bottom = "bottomObstacle"
    var middle = "middleObstacle"
    var top = "topObstacle"
}


class SpawnManager {
    private var parent: SKNode!
    private var bottomObstacle: Obstacle!
    private var middleObstacle: Obstacle!
    private var topObstacle: Obstacle!
    private var types = ObjectType()
    
    private var life: Life!
    
    init(parent: SKNode) {
        self.parent = parent
        setSpawnObstacles()
    }
    
    func setSpawnObstacles() {
        let bottomNode = parent.childNode(withName: types.bottom) as! SKSpriteNode
        bottomObstacle = Obstacle(node: bottomNode, position: .bottom, parent: parent, upperInterval: CGFloat(5))
        
        let middleNode = parent.childNode(withName: types.middle) as! SKSpriteNode
        middleObstacle = Obstacle(node: middleNode, position: .middle, parent: parent, upperInterval: CGFloat(3))
        
        let topNode = parent.childNode(withName: types.top) as! SKSpriteNode
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
    
    func hasColided(node: SKNode) -> CGFloat {
        let obstacles: [SKNode]
        
        switch node.name {
        case types.bottom:
            obstacles = bottomObstacle.obstacles
        case types.middle:
            obstacles = middleObstacle.obstacles
        case types.top:
            obstacles = topObstacle.obstacles
            
        default:  // ground or ceil
            return 40
        }
        
//        for obstacle in obstacles {
//            if obstacle == node {
//                obstacle.node.
//                break
//
//            }
//        }
        return 20
    }
    
    func resetSpawns() {
        bottomObstacle.reset()
        middleObstacle.reset()
        topObstacle.reset()
        life.reset()
    }
}
