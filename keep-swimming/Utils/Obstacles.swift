//
//  Obstacles.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 03/02/22.
//

import SpriteKit

struct ObstacleStruct {
    var position: ObjectPosition
    var imageSequence: [String]
    var range: Int = 0
    var damage: CGFloat
    var contactEnabled: Bool = true
}

struct Obstacles {
    struct ObstaclesBottom {
        static let seaweed1 = ObstacleStruct(position: .bottom, imageSequence: ["s1", "s2", "s3", "s1"], damage: 5)
        static let seaweed2 = ObstacleStruct(position: .bottom, imageSequence: [], damage: 5)
    }
    
    struct ObstaclesTop {
        static let seaweed3 = ObstacleStruct(position: .top, imageSequence: [], damage: 5)
    }

    struct ObstaclesMiddle {
        static let fishes = ObstacleStruct(position: .middle, imageSequence: [], range: 10, damage: 10)
        static let starsea = ObstacleStruct(position: .middle, imageSequence: [], range: 5, damage: 5)
        static let whale = ObstacleStruct(position: .middle, imageSequence: [], range: 5, damage: 30)
        static let turtle = ObstacleStruct(position: .middle, imageSequence: [], range: 10, damage: 5)
        static let jellyfish = ObstacleStruct(position: .middle, imageSequence: [], range: 10, damage: 15)
    }
}

