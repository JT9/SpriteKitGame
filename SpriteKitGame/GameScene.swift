//
//  GameScene.swift
//  SpriteKitGame
//
//  Created by Caleb Tsosie on 11/25/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    var contentCreated = false
    //From GameplayKit
    var randomSource = GKLinearCongruentialRandomSource.sharedRandom()
    //Used for mouse
    var selected: SKNode?
    var points = 0
    var introScene: IntroScene? = nil
    var music: AVAudioPlayer? = nil

    
    
    override func didMove(to view: SKView) {
        if contentCreated == false {
            createSceneContents()
            loadMusic()
            contentCreated = true
        }
    }
    

    
   //Used to load music
    func loadMusic() {
        let path = Bundle.main.path(forResource: "gameMusic.mp3", ofType: nil)!
        let audioURL = URL(fileURLWithPath: path)
        do {
            let backgroundMusic = try AVAudioPlayer(contentsOf: audioURL)
            music = backgroundMusic
            backgroundMusic.play()
        } catch {
            print("unable to load audio file")
        }
    }
 
    
    func createSceneContents() {
        backgroundColor = SKColor.black
        scaleMode = .aspectFit
        
        //loadMusic()
        let shuttle = newShuttle()
        //Starting position of shuttle
        shuttle.position = CGPoint(x: self.frame.size.width / 2, y: shuttle.size.height / 2 + 50)
        addChild(shuttle)
        
        let makeRocks = SKAction.sequence([
            SKAction.perform(#selector(GameScene.addRock), onTarget: self),
            //Puts a random value with the range
            SKAction.wait(forDuration: 0.1, withRange: 0.15)])
        run(SKAction.repeatForever(makeRocks))
        
        let makeEnemies = SKAction.sequence([
            SKAction.perform(#selector(GameScene.newEnemy), onTarget: self),
            SKAction.wait(forDuration: 1.0, withRange: 0.25)])
        run(SKAction.repeatForever(makeEnemies))
        
        physicsWorld.contactDelegate = self
        
        score()
        
    }
 

    func addRock() {
        let rock = SKSpriteNode(color: SKColor.white, size: CGSize(width: 10, height: 10))
        rock.position = CGPoint(x: CGFloat(randomSource.nextUniform()) * size.width, y: size.height-10)
        //rock has name 'rock'
        rock.name = "rock"
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.physicsBody?.usesPreciseCollisionDetection = true
        //Test for same objects that have the same bitMask or overlap
        rock.physicsBody?.contactTestBitMask = 1
        addChild(rock)
    }
 
    
    //Used to remove nodes of falling rocks are not displayed anymore
    override func didSimulatePhysics() {
        enumerateChildNodes(withName: "rock", using: { node, _ in
            //Check to see if it's offscreen
            if node.position.y < 0.0 {
                //Used to test if this is working
                //print("bye")
                node.removeFromParent()
                
            }
        })
    }

    
    //Create ship
    func newShuttle() -> (SKSpriteNode) {
        
        let texture = SKTexture(imageNamed: "bgbattleship.png")
        let hull = SKSpriteNode(texture: texture)
        hull.name = "shuttle"
        
        let light1 = newLight()
        light1.position = CGPoint(x:-28.0, y:6.0)
        hull.addChild(light1)
        
        let light2 = newLight()
        light2.position = CGPoint(x:28.0, y: 6.0)
        hull.addChild(light2)
        
        //Used to set the size of the png to PhysicsBody
        hull.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: 120, height: 120))
        hull.physicsBody?.usesPreciseCollisionDetection = true
        hull.physicsBody?.contactTestBitMask = 1
        
        //PhysicsBody is still there but not used to dynamically change the position on the spaceship
        hull.physicsBody?.isDynamic = false
        
        //Scaling ship from png file
        hull.setScale(0.75)
        
        return hull
    }
    
    //Used to create lights on the shuttle
    func newLight() -> (SKSpriteNode) {
        
        //Creates light color and size
        let light = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 5, height: 5))
        
        //Creates blinking sequence and repeats it
        let blink = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.25),
            SKAction.fadeIn(withDuration: 0.25)])
        let blinkRepeat = SKAction.repeatForever(blink)
        light.run(blinkRepeat)
        
        return light
    }
    
    //Create enemy ship
    func newEnemy() {
        
        let node = Ship()
        node.name = "ship"
        let texture = SKTexture(imageNamed: "enemy_ship.png")
        let enemyShip = Ship(texture: texture)
        enemyShip.position = CGPoint(x: CGFloat(randomSource.nextUniform()) * size.width, y: size.height - 50)
        
        enemyShip.name = "enemy"
        
        enemyShip.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: 426, height: 269))
        //enemyShip.physicsBody = SKPhysicsBody(rectangleOf: enemyShip.size)
        
        enemyShip.physicsBody?.usesPreciseCollisionDetection = true
        enemyShip.physicsBody?.contactTestBitMask = 1
        
        enemyShip.setScale(0.5)
        
        node.addChild(enemyShip)
        
        addChild(node)

        //Used to run Ship.process in Ship.swift
        node.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 10.0/60.0),
            SKAction.perform(#selector(Ship.process), onTarget: node)])))
    }
    
    //Used to create score and place it in the upper left corner
    func score() {
        let scoreNode = SKLabelNode(fontNamed: "Impact")
        scoreNode.text = "0"
        scoreNode.fontSize = 40.0
        scoreNode.fontColor = SKColor.yellow
        scoreNode.position = CGPoint(x: 20.0, y: size.height - 50.0)
        scoreNode.zPosition = 15.0
        scoreNode.name = "Score"
        scoreNode.horizontalAlignmentMode = .left
        addChild(scoreNode)
    }
    
    func points(value: Int) {
        points += value
        if let scoreNode = childNode(withName: "Score") as! SKLabelNode?
        {
            scoreNode.text = "\(points)"
        }
    }
    
    //Used to end the game when shuttle is in contact with enemy
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "shuttle" || contact.bodyB.node?.name == "shuttle"  {
            introScene?.updateHighScore(value: points)
            if music != nil {
                music?.stop()
                music = nil
            }
            let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
            view?.presentScene(introScene!, transition: doors)
        }
        
    }
 
    
    override func mouseDown(with event: NSEvent) {
        //Current location of mouse pointer
        let point = event.location(in: self)
        let nodesAtPoint = nodes(at: point)
        if nodesAtPoint.count > 0 {
            selected = nodesAtPoint[0]
            //Cancel out movement of spaceship when holding the mouse down
            selected?.removeAllActions()
        }
        else {
            selected = nil
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if let node = selected {
            //Current location of mouse pointer
            let point = event.location(in: self)
            //Use SKAction.move to move to that point while dragging the mouse
            node.run(SKAction.move(to: point, duration: 0))
        }
    }

}
