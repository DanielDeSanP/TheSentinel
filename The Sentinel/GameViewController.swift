//
//  GameViewController.swift
//  The Sentinel
//
//  Created by Daniel De San Pedro V. on 28/01/16.
//  Copyright (c) 2016 Daniel De San Pedro V. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView

        let scene = GameScene(size: skView.bounds.size )
            // Configure the view.
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.presentScene(scene)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
}
