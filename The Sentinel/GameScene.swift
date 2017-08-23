//
//  GameScene.swift
//  The Sentinel
//
//  Created by Daniel De San Pedro V. on 28/01/16.
//  Copyright (c) 2016 Daniel De San Pedro V. All rights reserved.
//
/*

Tareas por realizar:

    Fase de Diseño y programación:

    Navegacion 
    IBDesignables
    Gesturas Touch 

    Para proteco:

    Menu principal 
    Mecanica basica del juego terminada 
    Pausa 

    


    
    Juego:
    - Spawneo de las naves *
    - Disparo *
    - Física *
    - Poner el background*
    - Componer el spwaneo de las naves *
    - Establecer el sprite de la base (Crear los assets de la base)
    - Establecer los sprites de las demás naves
    - Establecer el sistema de puntuacion y de avance de nivel 
    - Establecer las condiciones para Game Over 
    Diseño:
    - Buscar los assets apropiados para las naves (Se pueden crear en Sketch)
    - Buscar los assets para las animaciones (Se recomienda comprarlos) 
    - Buscar o crear assets para los disparos.
    - Crear un título para el inicio de la pantalla 
    - Buscar sonidos adecuados
    App:
    - Crear el menú principal
    - Crear el menú de Scores 
    - Crear base de datos interno para el guardado de puntuaciones
    - Crear el menú de pausas
    - Integración con Game-Center
    - Adecuar la App para los diferentes dispositivos Apple
    - Optimizar la App (pasos finales)

    Fase de Pruebas y certificacion:

    - Conseguir la cuenta de Desarrollador de Apple
    - Averiguar como usar TestFloght 
    - Conseguir una buena cantidad de Beta Testers (Las fases de pruebas deben de durar mínimo dos semanas)
    - Hacer los preparativos finales para enviar el código de la app y la app a Apple
    - Esperar a la certificacion
    _ Últimos pasos
    
    La app es finalmente publicada

Primero se debe de cubrir la parte del diseño del juego, luego a la par la parte del diseño de assets y el diseño completo de la App

    
RS-Tzion Out
*/

import SpriteKit




class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    //Variables globales de la clase
    var contantPlayer: SKNode! //Este sprite va a contener todos los elementos moviles de juego
    var background: SKNode!
    var xAxis : CGFloat!
    var updates: Int = 0
    var timeSpwaning: TimeInterval = 0.3 //Esta variable se encarga de establecer un lapso de tiempo entre los spwaneos de las naves, conforme va avanzando la dificultad el tiempo va disminuyendo. 
    var lessTimeSpwaning: TimeInterval = 0.02 // Esta variable contiene el lapso de tiempo que se va ir restando conforme se avanza de nivel.
    
    //Variables que almacenan las puntuaciones del juego
    var lifeBase: Int = 100
    var score: Int = 0
    
    //Label que despliegan las puntuaciones del juego
    var scoreLabel: SKLabelNode!
    var lifeBaseLabel: SKLabelNode!

    //Label que despliega el mensaje GameOver
    var gameoverLabel: SKLabelNode!
    
    //Variables contadores para aumentar la dificultad del juego
    var counter: Int = 0
    var velocity: TimeInterval = (1.5 as TimeInterval)
    var moreVelocity: TimeInterval = (0.1 as TimeInterval)
    var time = 0.0001
    
    //Botones para regresar al menu o para empezar de nuevo 
    
    var restart: SKSpriteNode!
    var backToMenu: SKSpriteNode!
    
    var gameOver: Bool = false
    
    //Structura para designar las caraterízticas físicas
    struct Physicscategories {
        static let none : UInt32 = 0
        static let projectile : UInt32 = 0x1 << 0
        static let enemyShip : UInt32 = 0x1 << 1
        static let base: UInt32 = 0x1 << 2
        
    }
    
    
    
    
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        physicsWorld.contactDelegate = self
        initBackground()
        initEnemyShip()
        initLabels()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        if let touch = touches.first as UITouch? {
            
            //Con esta variable conozco la locacion del toque
            
            let location = touch.location(in: self)
            
            if gameOver == false { //verificamos si el juego no ha terminado
            
                if location.y < 150 { //Los disparos se podran realizar en una area determinada
                    if self.isPaused == true {
                        if restart.contains(location) {
                            restartGame()
                        }
                        
                        if backToMenu.contains(location) {
                            goBackToStartView()
                        }
                    }else{
                        shot(location)
                    }
                }
                else{ // Si se toca fuera de la area de disparos se pone pausa el juego
                
                	if self.isPaused == true {
                        self.isPaused = false
                        removeButtons()
                    }else{
                        self.isPaused = true
                        initButtons()
                    }
                
                }
            }else{
                
                if restart.contains(location) {
                    restartGame()
                }
                
                if backToMenu.contains(location) {
                    goBackToStartView()
                }
            }
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        updates += 1
        if self.isPaused == true {
            return
        }
        if lifeBase == 0 { //Se despliega el mensaje de GameOver
            self.isPaused = true
            gameoverLabel = SKLabelNode(text: "Game Over")
            gameoverLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
            gameoverLabel.fontColor = UIColor.white
            gameoverLabel.fontName = "Futura-Medium"
            gameoverLabel.fontSize = 50
            gameoverLabel.zPosition = 4
            background.addChild(gameoverLabel)
            gameOver = true
            initButtons()
            
        }
        //time += 0.0001
        //scoreLabel.text = "\(time)"
        if counter == 10 {
            velocity -= moreVelocity
            counter = 0
        }
    }
    
    func initBackground() {
        
        let imgBackground = SKSpriteNode(imageNamed: "background");
        
        imgBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        imgBackground.size = CGSize(width: self.size.width, height: self.size.height)
        imgBackground.zPosition = 0
        
        
        background = SKNode()
        self.addChild(background)
        background.addChild(imgBackground)
        
        //Se agrega el sprite de la base
        
        let imgBase = SKSpriteNode(imageNamed: "base")
        imgBase.size = CGSize(width: self.size.width, height: 150)
        imgBase.position = CGPoint(x: self.size.width/2,y: imgBase.size.height/2)
        imgBase.zPosition = 1
        background.addChild(imgBase)
        
        imgBase.physicsBody = SKPhysicsBody(texture: imgBase.texture!, size: imgBase.size)
        imgBase.physicsBody?.categoryBitMask = Physicscategories.base
        imgBase.physicsBody?.isDynamic = false
        imgBase.physicsBody?.contactTestBitMask = Physicscategories.enemyShip
        imgBase.physicsBody?.collisionBitMask = Physicscategories.enemyShip
        imgBase.physicsBody?.usesPreciseCollisionDetection = true
        

        
        contantPlayer = SKNode()
        contantPlayer.zPosition = 2
        self.background.addChild(contantPlayer)
        
    }
    
    func shot(_ location: CGPoint){
    
        
        let projectile = SKSpriteNode(imageNamed: "laser")
        //Dando localizacion inicial del proyectil
        
        projectile.position = location
        projectile.zPosition = 0
        
        self.contantPlayer.addChild(projectile)
        
        
        
        
        let destino = CGPoint(x: location.x, y: 1000)
        
        let disparo = SKAction.move(to: destino, duration: 0.2)
        let desaparecer = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([disparo,desaparecer]))
        
        //Características físicas
        projectile.physicsBody = SKPhysicsBody(texture: projectile.texture!, size: projectile.size)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = Physicscategories.projectile
        projectile.physicsBody?.contactTestBitMask = Physicscategories.enemyShip
        projectile.physicsBody?.collisionBitMask = Physicscategories.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true

        
    }
    
    func createEnemyShips() -> SKSpriteNode {
        //Creamos el sprite
        
        let width = self.frame.size.width
        
        let enemyShip = SKSpriteNode(texture: SKTexture(imageNamed: "Spaceship"))
        //Determinamos posiciones aleatorias en el eje de las x
        let randomX = CGFloat(arc4random_uniform(UInt32(width-40+1)))
        //Otorgamos poscion de aparicion
        enemyShip.position.x = randomX + 20
        enemyShip.position.y = self.size.height + enemyShip.size.height
        enemyShip.zPosition = 1
        
        let movimiento = SKAction.move(to: CGPoint(x: randomX, y: 0), duration: velocity)
        let desaparecer = SKAction.removeFromParent()
        let secuenciaMovimiento = SKAction.sequence([movimiento,desaparecer])
        enemyShip.run(secuenciaMovimiento)
        
        //Características físicas
        enemyShip.physicsBody = SKPhysicsBody(texture: enemyShip.texture!, size: enemyShip.size)
        enemyShip.physicsBody?.categoryBitMask = Physicscategories.enemyShip
        enemyShip.physicsBody?.isDynamic = true
        enemyShip.physicsBody?.contactTestBitMask = Physicscategories.projectile
        enemyShip.physicsBody?.collisionBitMask = Physicscategories.none
        enemyShip.physicsBody?.usesPreciseCollisionDetection = true
        
        return enemyShip
        
    }
    
    func initEnemyShip(){
        let enemyShip = SKAction.run{ () -> Void in
            let tmpShip = self.createEnemyShips()
            self.contantPlayer.addChild(tmpShip)
            
        }
        
        let timeLapse = SKAction.wait(forDuration: 0.5, withRange: 0.5)
        let creationSequence = SKAction.sequence([enemyShip,timeLapse])
        let repeatSequence = SKAction.repeatForever(creationSequence)
        run(repeatSequence)
        
        
    }
    
    //Funcion que remueve de la pantalla las naves, y que ademas debe de reproducir una serie de texturas con el fin de animar una explosion de la nave.
    
    func colision(_ projectile: SKSpriteNode, enemySpaceship: SKSpriteNode) {
        projectile.removeFromParent()
        enemySpaceship.removeFromParent()
        score += 1
        counter += 1
        scoreLabel.text = "\(score)"

    }
    
    //Funcion que se encarga de bajar la vida a la base y de retirar la nave del juego
    func baseAtacked(_ enemySpaceship: SKSpriteNode){
        enemySpaceship.removeFromParent()
        lifeBase -= 5
        lifeBaseLabel.text = "\(lifeBase)%"

    }
    //Funcion quue detecta el contacto entre dos cuerpos
    
    func didBegin(_ contact: SKPhysicsContact){
        var cuerpoA : SKPhysicsBody
        var cuerpoB : SKPhysicsBody
        
        if updates == 0 {
            return
        }
        updates = 0
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            cuerpoA = contact.bodyA
            cuerpoB = contact.bodyB
        } else {
            cuerpoA = contact.bodyB
            cuerpoB = contact.bodyA
        }
        
        //Nos sercioramos de que sean los dos cuerpos 
        
        if (cuerpoA.categoryBitMask & Physicscategories.enemyShip != 0) && (cuerpoB.categoryBitMask & Physicscategories.enemyShip != 0) {
            colision(cuerpoA.node as! SKSpriteNode, enemySpaceship: cuerpoB.node as! SKSpriteNode)
        }
        
        if cuerpoA.categoryBitMask == Physicscategories.enemyShip || cuerpoB.categoryBitMask == Physicscategories.base {
            baseAtacked(cuerpoA.node as! SKSpriteNode)
            
        }else{
            colision(cuerpoA.node as! SKSpriteNode, enemySpaceship: cuerpoB.node as! SKSpriteNode)
            
        }
    }
    
    func initLabels() {
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontColor = UIColor.white
        scoreLabel.fontName = "Futura-Medium"
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height - 45)
        scoreLabel.zPosition = 3
        background.addChild(scoreLabel)
        
        lifeBaseLabel = SKLabelNode(text: "\(lifeBase)%")
        lifeBaseLabel.fontColor = UIColor.white
        lifeBaseLabel.fontName = "Futura-Medium"
        lifeBaseLabel.fontSize = 15
        lifeBaseLabel.position = CGPoint(x: self.frame.size.width-40, y: self.frame.size.height - 20)
        lifeBaseLabel.zPosition = 3
        background.addChild(lifeBaseLabel)
        
    }
    
    func initButtons() {
        restart = SKSpriteNode(imageNamed: "restart")
        restart.size = CGSize(width: self.size.width, height: 150)
        restart.position = CGPoint(x: self.frame.size.width/2, y: restart.size.height/2)
        restart.zPosition = 4
        background.addChild(restart)
        
        backToMenu = SKSpriteNode(imageNamed: "arrow")
        backToMenu.position = CGPoint(x: 0 + backToMenu.size.width/2 + 10, y: self.frame.size.height - 20)
        backToMenu.zPosition = 4
        background.addChild(backToMenu)
    }
    
    func removeButtons() {
        restart.removeFromParent()
        backToMenu.removeFromParent()
    }
    
    func restartGame() {
        let skView = self.view! as SKView
        
        let scene = GameScene(size: skView.bounds.size )
        skView.presentScene(scene)
    }
    
    func goBackToStartView() {
        print("back")
    }
}
