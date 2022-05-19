//
//  GameScene.swift
//  SpaceWar
//
//  Created by ilia nikashov on 18.05.2022.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let spaceShipCategory: UInt32 = 0x1 << 0
    let asteroidCategory: UInt32 = 0x1 << 1
    var spaceShip: SKSpriteNode!
    var score = 0
    var scoreLabel: SKLabelNode!
    var spaceBackground: SKSpriteNode!
    var asteroidLayer: SKNode!
    var gameIsPaused: Bool = false
    var starsLayer: SKNode!
    var musicPlayer: AVAudioPlayer!
    var spaceShipLayer: SKNode!
    var soundIsOn: Bool = true
    
    
    func soundOnOff () {
        if soundIsOn {
            playMusic()
        } else {
            musicPlayer.pause()
        }
    }
    
    
    func pauseTheGame() {
        musicPlayer.stop()
        gameIsPaused = true
        self.asteroidLayer.isPaused = true
        physicsWorld.speed = 0
        starsLayer.isPaused = true
    }
    
    
    func continueGame() {
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
        starsLayer.isPaused = false
        soundOnOff()
    }
    
    func resetGame() {
        score = 0
        scoreLabel.text = "Score: \(score)"
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
        starsLayer.isPaused = false
    }
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        
        scene?.size = UIScreen.main.bounds.size
        
        spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        spaceBackground.size = CGSize(width: self.size.width + 50, height: self.size.width)
        addChild(spaceBackground)
        
        let starsPath = Bundle.main.path(forResource: "Stars", ofType: "sks")
        let starsEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: starsPath!) as? SKEmitterNode
        
        starsEmitter?.zPosition = 1
        starsEmitter?.position = CGPoint(x: frame.midX, y: frame.height / 3)
        starsEmitter?.particlePositionRange.dx = frame.width
        starsEmitter?.advanceSimulationTime(10)
        
        starsLayer = SKNode()
        starsLayer.zPosition = 1
        addChild(starsLayer)
        starsLayer.addChild(starsEmitter!)
        
        let width = UIScreen.main.bounds.width*2
        let heihgt = UIScreen.main.bounds.height*2
        spaceBackground.size = CGSize(width: width , height: heihgt)
        
        spaceShip = SKSpriteNode(imageNamed: "spaceShipImg")
        spaceShip.size = CGSize(width: 150, height: 150)
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        
        spaceShip.physicsBody?.categoryBitMask = spaceShipCategory
        spaceShip.physicsBody?.collisionBitMask = asteroidCategory
        spaceShip.physicsBody?.contactTestBitMask = asteroidCategory
        
        let colorAction1 = SKAction.colorize(with: .yellow, colorBlendFactor: 1, duration: 1)
        let colorAction2 = SKAction.colorize(with: .purple, colorBlendFactor: 0, duration: 1)
        
        let colorSequence = SKAction.sequence([colorAction1, colorAction2])
        let colorActionRepeat = SKAction.repeatForever(colorSequence)
        spaceShip.run(colorActionRepeat)
        
        //addChild(spaceShip)
        
        spaceShipLayer = SKNode()
        spaceShipLayer.addChild(spaceShip)
        spaceShipLayer.zPosition = 3
        spaceShip.zPosition = 1
        spaceShipLayer.position = CGPoint(x: 0, y: 0)
        addChild(spaceShipLayer)
        
        
        let firePath = Bundle.main.path(forResource: "Fire", ofType: "sks")
        let fireEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: firePath!) as? SKEmitterNode
        fireEmitter?.zPosition = 0
        fireEmitter?.position.y = -60
        fireEmitter?.targetNode = self
        spaceShipLayer.addChild(fireEmitter!)
        
        
        asteroidLayer = SKNode()
        asteroidLayer.zPosition = 2
        addChild(asteroidLayer)
        
        let asteroidCreate = SKAction.run {
            let asteroid = self.createAsteroid()
            self.asteroidLayer.addChild(asteroid)
            asteroid.zPosition = 2
        }
        let asteroidPerSecond: Double = 5
        let asteroidCreateDelay = SKAction.wait(forDuration: TimeInterval(1) / asteroidPerSecond, withRange: TimeInterval (0.5))
        let asteroidSequenseAction = SKAction.sequence([asteroidCreate, asteroidCreateDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenseAction)
        
        self.asteroidLayer.run(asteroidRunAction)
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: 0, y: 376)
        
        addChild(scoreLabel)
        
        spaceBackground.zPosition = 0
        //spaceShip.zPosition = 1
        scoreLabel.zPosition = 3
        
        playMusic()
    }
    
    func playMusic() {
        if soundIsOn && !gameIsPaused {
            let musicPath = Bundle.main.url(forResource: "musicGame", withExtension: "mp3")!
            musicPlayer = try! AVAudioPlayer(contentsOf: musicPath, fileTypeHint: nil)
            musicPlayer.play()
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.2 }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameIsPaused {
            if let touch = touches.first {
                
                let touchLocation = touch.location(in: self)
                
                let distance = distanceCalculate(a: spaceShip.position, b: touchLocation)
                let speed: CGFloat = 500
                let time = timeToInterval(distance: distance, speed: speed)
                
                let moveAction = SKAction.move(to: touchLocation, duration: time)
                moveAction.timingMode = SKActionTimingMode.easeInEaseOut
                
                print(distance, time)
                spaceShipLayer.run(moveAction)
                
                let bgMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x / 20, y: -touchLocation.y / 20), duration: time)
                spaceBackground.run(bgMoveAction)
            }
        }
    }
    
    
    func createAsteroid() -> SKSpriteNode {
        
        let asteroid = SKSpriteNode(imageNamed: "asteroidImg")
        
        
        
        asteroid.position.x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 6))
        asteroid.position.y = frame.size.height + asteroid.size.width
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        asteroid.name = "asteroid"
        
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory | asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory
        
        
        let asteroidSpeedX: CGFloat = 100
        asteroid.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 3
        asteroid.physicsBody?.velocity.dx = CGFloat(drand48() * 2 - 1) * asteroidSpeedX
        
        return asteroid
    }
    
    
    func distanceCalculate(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y))
    }
    
    
    func timeToInterval(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
    }
    
    
    override func didSimulatePhysics() {
        asteroidLayer.enumerateChildNodes(withName: "asteroid") { asteroid, stop in
            let hightScreen = UIScreen.main.bounds.height
            if asteroid.position.y < -hightScreen {
                asteroid.removeFromParent()
                self.score = self.score + 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == spaceShipCategory && contact.bodyB.categoryBitMask == asteroidCategory || contact.bodyB.categoryBitMask == spaceShipCategory && contact.bodyA.categoryBitMask == asteroidCategory {
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
        }
        if soundIsOn {
            let hitSoundAction = SKAction.playSoundFileNamed("kick", waitForCompletion: true)
            run(hitSoundAction)} else {
            }
        
        print("Contact!")
    }
    
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
