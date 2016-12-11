//
//  ViewController.swift
//  SpriteKitGame
//
//  Created by Caleb Tsosie on 11/25/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {
    
    @IBOutlet var spriteView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let intro = IntroScene(size: CGSize(width: view.frame.width, height: view.frame.height))
        spriteView.presentScene(intro)
        
    
    }

    /*override func viewWillAppear() {
        let spriteView = view as! SKView
        
        if let visibleFrame = view.window?.screen?.visibleFrame {
            let newFrame = NSRect(x: visibleFrame.origin.x, y: visibleFrame.origin.y + 200.00, width: visibleFrame.width, height: visibleFrame.height - 200.0)
            view.window?.setFrame(newFrame, display: true)
        }
        
        let intro = IntroScene(size: CGSize(width: view.frame.width, height: view.frame.height))
        
        spriteView.presentScene(intro)
    }
 */
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

