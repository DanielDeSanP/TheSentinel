//
//  assaultShip.swift
//  The Sentinel
//
//  Created by Luis  Daniel De San Pedro on 06/02/16.
//  Copyright © 2016 Daniel De San Pedro V. All rights reserved.
//

import Foundation
import SpriteKit

class assaultShip: Ship {
    let atackPoints = 4
    //Con esta clase vamos a crear el modelo de las naves de assalto
    
    /*
    Acerca de esta clase:
    
    Esta clase es una subclase de la clase SKSPriteNode, lo cual implica que tengo que agregar en dos cosas: La primera el inicializador que tiene por default, es decir el inicializador que no esta definida como "convenience", eso lo tengo que agregar por lo menos en algun inicializador, luego tengo que agregar el required init?(coder: NSCoder) 
    
    
    
    */
    
    
    //La diferencia que vva a tener esta clase con respecto a las demas, es que esta va a tener hitPoints es decir será necesario disparale a la nave mas de una vez para destruirlo.
    override init(text: SKTexture) {
        super.init(text: text)
        HP = 3
    }
    


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
