//
//  GameScene.swift
//  SpaceShooter
//
//  Created by David Penagos on 23/03/20.
//  Copyright © 2020 David Penagos. All rights reserved.

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: - Properties
    var player: SKSpriteNode?
    var projectile: SKSpriteNode?
    var enemy: SKSpriteNode?
    var stars: SKSpriteNode?
    
    var scoreLabel: SKLabelNode?
    var mainLabel: SKLabelNode?
    
    var playerSize = CGSize(width: 50, height: 50)
    var projectileSize = CGSize(width: 10, height: 10)
    var enemySize = CGSize(width: 40, height: 40)
    var starSize: CGPoint?
    
    var fireProjectileRate = 0.2
    var projectileSpeed = 0.9
    var enemySpeed = 2.1
    var enemySpawnRate = 0.6
    
    var isAlive: Bool = true
    var score = 0
    var touchLocation: CGPoint = CGPoint()
    
    
    //MARK: - LifeCycle
    override func didMove(to view: SKView) {
        self.backgroundColor = .offBlackColor
        physicsWorld.contactDelegate = self
        resetGameVariablesOnStart()
        spawnPlayer()
        spawnScoreLabel()
        spawnMainLabel()
        mainLabel?.run(SKAction.fadeOut(withDuration: 1))
        fireProjectile()
        timerSpawnEnemies()
        timerStarSpawn()
    }
    
    //MARK: - Actions on game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //ANNOTATION: - Take specific point location when user tap screen
        for _ in touches {
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            if isAlive {
                movePlayerOnTouch()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !isAlive {
            movePlayerOffScreen()
        }
    }
    
    func movePlayerOnTouch() {
        player!.position.x = touchLocation.x
    }
    
    func movePlayerOffScreen() {
        player?.position.x = -1000
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        //ANNOTATION: - Collision between projectile and enemy
        if ((firstBody.categoryBitMask == PhysicsCategory.enemy) && (secondBody.categoryBitMask == PhysicsCategory.projectile) ||
            (firstBody.categoryBitMask == PhysicsCategory.projectile) && (secondBody.categoryBitMask == PhysicsCategory.enemy)) {
            spawnExplosion(enemyTemp: firstBody.node as! SKSpriteNode)
            enemyProjectileCollision(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
        }
        //ANNOTATION: - Collision between player and enemy
        if ((firstBody.categoryBitMask == PhysicsCategory.player) && (secondBody.categoryBitMask == PhysicsCategory.enemy) ||
            (firstBody.categoryBitMask == PhysicsCategory.enemy) && (secondBody.categoryBitMask == PhysicsCategory.player)) {
            playerEnemyCollision(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
        }
    }
    
    //MARK: - Functions
    func spawnPlayer() {
        //ANNOTATION: - Create player object and put in some specific point of screen.
        player = SKSpriteNode(imageNamed: "SpaceShip")
        player?.size = CGSize(width: 100, height: 100)
        player?.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 450)
        player?.physicsBody = SKPhysicsBody(rectangleOf: playerSize)
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.allowsRotation = false
        player?.physicsBody?.isDynamic = false
        player?.physicsBody?.categoryBitMask = PhysicsCategory.player
        player?.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        player?.name = "playerName"
        self.addChild(player!)
    }
    
    func spawnProjectile() {
        //ANNOTATION: - Create projectile object and put in some specific point of screen based on player object.
        projectile = SKSpriteNode(color: .offWhiteColor, size: CGSize(width: 10, height: 10))
        projectile?.position = CGPoint(x: (player?.position.x)!, y: (player?.position.y)!)
        projectile?.physicsBody = SKPhysicsBody(rectangleOf: projectileSize)
        projectile?.zPosition = -1
        projectile?.physicsBody?.affectedByGravity = false
        projectile?.physicsBody?.allowsRotation = false
        projectile?.physicsBody?.isDynamic = false
        projectile?.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile?.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        projectile?.name = "projectileName"
        moveProjectileToTop()
        self.addChild(projectile!)
    }
    
    func moveProjectileToTop() {
        let moveForward = SKAction.moveTo(y: 1000, duration: projectileSpeed)
        let destroy = SKAction.removeFromParent()
        projectile?.run(SKAction.sequence([moveForward, destroy]))
    }
    
    func spawnEnemy() {
        //ANNOTATION: - Create enemy object and put in some random point of screen.
        let randomX = Int.random(in: -300..<300)
        enemy = SKSpriteNode(imageNamed: "Ovni")
        enemy?.size = CGSize(width: 100, height: 100)
        enemy?.position = CGPoint(x: CGFloat(integerLiteral: randomX), y: self.frame.maxY - 100)
        enemy?.physicsBody = SKPhysicsBody(rectangleOf: enemySize)
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody?.allowsRotation = false
        enemy?.physicsBody?.isDynamic = true
        enemy?.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy?.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        enemy?.name = "enemyName"
        moveEnemyToFloor()
        self.addChild(enemy!)
    }
    
    func moveEnemyToFloor() {
        let moveTo = SKAction.moveTo(y: -500, duration: enemySpeed)
        let destroy = SKAction.removeFromParent()
        enemy?.run(SKAction.sequence([moveTo, destroy]))
    }
    
    func spawnStars() {
        //ANNOTATION: - Create stars object with a random size and put in some random point of screen.
        let randomSize = Int(arc4random_uniform(4) + 2)
        let randomX = Int.random(in: -300..<300)
        stars = SKSpriteNode(color: .offWhiteColor, size: CGSize(width: randomSize, height: randomSize))
        stars?.position = CGPoint(x: CGFloat(integerLiteral: randomX), y: self.frame.maxY - 100)
        starsMove()
        self.addChild(stars!)
    }
    
    func starsMove() {
        let randonTime = Int(arc4random_uniform(2))
        let doubleRandomTime = (Double(randonTime) / 10) + 2
        let moveTo = SKAction.moveTo(y: -500, duration: doubleRandomTime)
        let destroy = SKAction.removeFromParent()
        stars?.run(SKAction.sequence([moveTo, destroy]))
    }
    
    func spawnMainLabel() {
        //ANNOTATION: - Create MainLabel object and put in some specific point of screen.
        mainLabel = SKLabelNode(fontNamed: "Futura")
        mainLabel?.fontSize = 100
        mainLabel?.fontColor = .offWhiteColor
        mainLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)
        mainLabel?.text = "Start!"
        self.addChild(mainLabel!)
    }
    
    func spawnScoreLabel() {
        //ANNOTATION: - Create MainLabel object and put in some specific point of screen.
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel?.fontSize = 40
        scoreLabel?.fontColor = .offWhiteColor
        scoreLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 580)
        scoreLabel?.text = "Score: \(score)"
        self.addChild(scoreLabel!)
    }
    
    func fireProjectile() {
        let timer = SKAction.wait(forDuration: fireProjectileRate)
        let spawn = SKAction.run {
            if self.isAlive {
                self.spawnProjectile()
            }
        }
        let sequence = SKAction.sequence([timer, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func timerSpawnEnemies() {
        let timer = SKAction.wait(forDuration: enemySpawnRate)
        let spawn = SKAction.run {
            if self.isAlive {
                self.spawnEnemy()
            }
        }
        let sequence = SKAction.sequence([timer, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func timerStarSpawn() {
        let wait = SKAction.wait(forDuration: 0.2)
        let spawn = SKAction.run {
            if self.isAlive {
                self.spawnStars()
                self.spawnStars()
                self.spawnStars()
            }
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func enemyProjectileCollision(contactA: SKSpriteNode, contactB: SKSpriteNode) {
        if contactA.name == "enemyName" && contactB.name == "projectileName" {
            //ANNOTATION: - Make an animation of FadeOut when projectile impact enemy
            score += 1
            let destroy = SKAction.removeFromParent()
            contactA.run(SKAction.sequence([destroy]))
            contactB.removeFromParent()
            updateScore()
        }
        
        if contactB.name == "enemyName" && contactA.name == "projectileName" {
            //ANNOTATION: - Make an animation of FadeOut when projectile impact enemy
            score += 1
            let destroy = SKAction.removeFromParent()
            contactB.run(SKAction.sequence([destroy]))
            contactA.removeFromParent()
            updateScore()
        }
    }
    
    func playerEnemyCollision(contactA: SKSpriteNode, contactB: SKSpriteNode) {
        //ANNOTATION: - Collition player/enemy
        if contactA.name == "enemyName" && contactB.name == "playerName" {
            isAlive = false
            gameOverLogic()
        }
        
        if contactB.name == "enemyName" && contactA.name == "playerName" {
            isAlive = false
            gameOverLogic()
        }
    }
    
    func spawnExplosion(enemyTemp: SKSpriteNode) {
        let explosionEmitterPath = Bundle.main.path(forResource: "ParticleSpark", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObject(withFile: explosionEmitterPath! as String) as! SKEmitterNode
        explosion.position = CGPoint(x: enemyTemp.position.x, y: enemyTemp.position.y)
        explosion.zPosition = 1
        explosion.targetNode = self
        self.addChild(explosion)
        removeExplosion(explosion: explosion)
    }
    
    func removeExplosion(explosion: SKEmitterNode) {
        let wait = SKAction.wait(forDuration: 0.5)
        let removeExplosion = SKAction.run {
            explosion.removeFromParent()
        }
        self.run(SKAction.sequence([wait, removeExplosion]))
    }
    
    func gameOverLogic() {
        mainLabel?.run(SKAction.fadeIn(withDuration: 1))
        mainLabel?.text = "Game Over"
        mainLabel?.fontSize = 90
        resetGame()
    }
    
    func resetGame() {
        let wait = SKAction.wait(forDuration: 3.0)
        let titleScene = TitleScene(fileNamed: "TitleScene")
        titleScene?.scaleMode = .aspectFill
        let transitionScene = SKTransition.doorway(withDuration: 0.4)
        
        //ANNOTATION: - Make transition for TitleScene to start a new game.
        let changeScene = SKAction.run {
            self.scene?.view?.presentScene(titleScene!, transition: transitionScene)
        }
        
        let sequence = SKAction.sequence([wait, changeScene])
        self.run(SKAction.repeat(sequence, count: 1))
    }
    
    func resetGameVariablesOnStart() {
        isAlive = true
        score = 0
    }
    
    func updateScore() {
        scoreLabel?.text = "Score: \(score)"
    }
}
