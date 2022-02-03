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
        static let seaweed1 = ObstacleStruct(position: .bottom, imageSequence: ["seeweed1", "seeweed2", "seeweed3", "seeweed1"], damage: 5)
        static let seaweed2 = ObstacleStruct(position: .bottom, imageSequence: ["seeweeda1", "seeweeda2", "seeweeda3", "seeweeda1"], damage: 5)
    }
    
    struct ObstaclesTop {
        static let seaweed3 = ObstacleStruct(position: .top, imageSequence: ["seeweedb1", "seeweedb2","seeweedb3","seeweedb1"], damage: 5)
    }

    struct ObstaclesMiddle {
        static let fishes = ObstacleStruct(position: .middle, imageSequence: ["fish1", "fish2","fish1"], range: 10, damage: 10)
        static let starsea = ObstacleStruct(position: .middle, imageSequence: ["star1", "star2","star3","star1" ], range: 5, damage: 5)
        static let whale = ObstacleStruct(position: .middle, imageSequence: ["whale1", "whale2","whale3","whale1", ], range: 5, damage: 30)
        static let turtle = ObstacleStruct(position: .middle, imageSequence: ["turtle1", "turtle2","turtle3","turtle1" ], range: 10, damage: 5)
        static let jellyfish = ObstacleStruct(position: .middle, imageSequence: ["jelly1","jelly2","jelly3","jelly4","jelly1", ], range: 10, damage: 15)
    }
}

