//
//  GameScene.swift
//  Game_Kursovaya
//
//  Created by Роман Лабунский on 11.05.2019.
//  Copyright © 2019 Роман Лабунский. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: ParentScene {
    
    var backgroundMusic: SKAudioNode!
    
    fileprivate let hud = HUD()
    fileprivate var player: PlayerSpaceShip!
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate var lives = 3{
        didSet{
            switch lives {
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            default:
                break
            }
        }
    }
    
    
    
    
    override func didMove(to view: SKView) {
        
        gameSettings.loadGameSettings()
        
        if gameSettings.isMusic && backgroundMusic == nil {
            if let musicURL = Bundle.main.url(forResource: "BGMusic", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        }
        
        self.scene?.isPaused = false
        // checking if scene persists
        guard sceneManager.gameScene == nil else { return }
        
        sceneManager.gameScene = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        
        configurateStartScene()
        spawnIslands()
        self.player.performeFly()
        
        spawnEnemies()
        
        createHUD()
    }
    
    fileprivate func createHUD(){
        addChild(hud)
        hud.configureUI(screenSize: screenSize)
    }
   
    
    // Генерация врагов
    fileprivate func spawnEnemies() {
        let waitAction = SKAction.wait(forDuration: 3.0)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnSpiralOfEnemies()
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction, spawnSpiralAction])))
    }
    
    
    fileprivate func spawnSpiralOfEnemies() {
        let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas //SKTextureAtlas(named: "Enemy_1")
        let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas //SKTextureAtlas(named: "Enemy_2")
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
            
            let randomNumber = Int(arc4random_uniform(2))
            let arrayOfAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
            let textureAtlas = arrayOfAtlases[randomNumber]
            
            let waitAction = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run({ [unowned self] in
                let textureNames = textureAtlas.textureNames.sorted()
                let texture = textureAtlas.textureNamed(textureNames[0]) 
                let enemy = Enemy(enemyTexture: texture)
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 110)
                self.addChild(enemy)
                enemy.flySpiral()
            })
            
            let spawnAction = SKAction.sequence([waitAction, spawnEnemy])
            let repeatAction = SKAction.repeat(spawnAction, count: 3)
            self.run(repeatAction)
        }
    }
    
    // Генерация космических камней
    fileprivate func spawnIslands() {
        let spawnIslandWait = SKAction.wait(forDuration: 2)
        let spawnIslandAction = SKAction.run {
            let island = Island.populate(at: nil)
            self.addChild(island)
        }
        
        let spawnIslandSequence = SKAction.sequence([spawnIslandWait, spawnIslandAction])
        let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
        run(spawnIslandForever)
    }
    
    fileprivate func configurateStartScene(){
        // create center point for Bachground
        let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        // init Backgraund and give point
        let BG = Background.populatedBackground(at: screenCenterPoint)
        // BG in fullScreen
        BG.size = self.size
        // add BG on the screen
        self.addChild(BG)
        
        // geberate the island
        let screen = UIScreen.main.bounds
        
        let island1 = Island.populate(at: CGPoint(x: 100, y: 200))
        self.addChild(island1)
        
        let island2 = Island.populate(at: CGPoint(x: self.size.width - 100, y: self.size.height - 200))
        self.addChild(island2)
        
        player = PlayerSpaceShip.populate(at: CGPoint(x: screen.size.width / 2, y: 100))
        self.addChild(player)
        
    }
    
    override func didSimulatePhysics() {
        
        player.checkXPosition()
        
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
    }
    
    fileprivate func playerFire() {
        let shot = GreenShot()
        shot.position = self.player.position
        shot.startMovement()
        self.run(SKAction.playSoundFileNamed("shotSound", waitForCompletion: false))
        self.addChild(shot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pause" {
            self.scene?.isPaused = true
            sceneManager.gameScene = self
            let transition = SKTransition.fade(withDuration: 0.3)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        } else {
            playerFire()
        }
    }
}


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
        let contactPoint = contact.contactPoint
        explosion?.position = contactPoint
        let waitForExplosionAction = SKAction.wait(forDuration: 2.0)
        
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        switch contactCategory {
        case [.enemy, .player]: print("enemy vs player")
            self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
        
        if contact.bodyA.node?.name == "sprite" {
            if contact.bodyA.node?.parent != nil{
                contact.bodyA.node?.removeFromParent()
                lives -= 1
            }
        } else {
            if contact.bodyB.node?.parent != nil{
                contact.bodyB.node?.removeFromParent()
                lives -= 1
            }
        }
        addChild(explosion!)
        self.run(waitForExplosionAction){ explosion?.removeFromParent() }
            
        if lives == 0 {
            
            gameSettings.currentScore = hud.score
            gameSettings.saveScores()
            
            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: 0.1)
            self.scene!.view?.presentScene(gameOverScene, transition: transition)
        }
        
        case [.powerUp, .player]: print("powerUp vs player")
            
        case [.enemy, .shot]: print("enemy vs shot")
        if contact.bodyA.node?.parent != nil{
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
            hud.score += 4 //GKRandomDistribution(lowestValue: 1, highestValue: 4)
            addChild(explosion!)
            self.run(waitForExplosionAction){ explosion?.removeFromParent()}
        }
            
        default: preconditionFailure("Unable to detect collision category")
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
