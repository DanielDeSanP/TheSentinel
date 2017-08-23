//
//  heavyShip.swift
//  The Sentinel
//
//  Created by Luis  Daniel De San Pedro on 07/02/16.
//  Copyright © 2016 Daniel De San Pedro V. All rights reserved.
//

import Foundation
import SpriteKit

class heavyShip: Ship {
    
    var shield = 5
    
    //Esta clase describe el modelo de la nave pesada que tendrá un escudo y 5 hitpoints
    
    override init(text: SKTexture){
        super.init(text: text) //Lllamamos al inicializador de la superclase
        HP = 5
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
