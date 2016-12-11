//
//  IntroScene.swift
//  SpriteKitGame
//
//  Created by Caleb Tsosie on 11/25/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Cocoa
import SpriteKit

class IntroScene: SKScene {
    
    var contentsCreated = false
    var highScore = 0
    
    
    override func didMove(to view: SKView) {
        //Creating background
        backgroundColor = SKColor.red
        scaleMode = .aspectFit
        //Checking to see if the scene was created
        if contentsCreated == false {
            createIntroScene()
            contentsCreated = true
        }
    }
    
    func createIntroScene() {
        let textNode = SKLabelNode(fontNamed: "Futura")
        textNode.text = "Hold Down Your Mouse To Start"
        textNode.fontSize = 48.0
        //Text position is in the middle of the screen
        textNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        textNode.name = "IntroText"
        addChild(textNode)
        
        let highScoreNode = SKLabelNode(fontNamed: "Futura")
        highScoreNode.text = "High Score: \(highScore)"
        highScoreNode.fontSize = 40.0
        highScoreNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - 70.0)
        highScoreNode.name = "HighScore"
        addChild(highScoreNode)
    }
    //Used to update high score
    func updateHighScore(value: Int) {
        if value > highScore {
            highScore = value
            if let node = childNode(withName: "HighScore") as! SKLabelNode? {
                node.text = "High score: \(highScore)"
            }
        }
    }
    
    //Used to transition to GameScene
    override func mouseDown(with event: NSEvent) {
        
        let newScene = GameScene(size: self.size)
        newScene.introScene = self
        let doors = SKTransition.doorsCloseVertical(withDuration: 0.5)
        self.view?.presentScene(newScene, transition: doors)
    }
}
