//
//  instructionsViewController.swift
//  The Sentinel
//
//  Created by Luis  Daniel De San Pedro on 14/02/16.
//  Copyright © 2016 Daniel De San Pedro V. All rights reserved.
//

import UIKit

class instructionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func play_btn(_ sender: AnyObject) {
        let gameView = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController")
        self.present(gameView!, animated: false, completion: nil)
        
    }
    
    @IBAction func back_btn(_ sender: AnyObject) {
        let startView = self.storyboard?.instantiateViewController(withIdentifier: "startViewController")
        self.present(startView!, animated: true, completion: nil)
        
    }
}
