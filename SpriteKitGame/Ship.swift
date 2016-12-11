//
//  Ship.swift
//  SpriteKitGame
//
//  Created by Caleb Tsosie on 11/27/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Cocoa
import SpriteKit

class Ship: SKSpriteNode {
    
    var didScore = false
    
    //Used to update score with a point
    func process() {
        
        let gameScene = scene as! GameScene
        
        if didScore == false && position.y < ((gameScene.size.width / 2.0) - 65.0) {
            gameScene.points(value: 1)
            didScore = true
        }
        
        if position.y < -200.0 {
            removeFromParent()
        }
        else {
            run(SKAction.moveBy(x: 0, y: -2.0, duration: 0))
        }
    }
}
