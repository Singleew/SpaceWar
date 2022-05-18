//
//  GameScene.swift
//  SpaceWar
//
//  Created by ilia nikashov on 18.05.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let spaceShipCategory: UInt32 = 0x1 << 0
    let asteroidCategory: UInt32 = 0x1 << 1
    var spaceShip: SKSpriteNode!
    
    var score: 0
    var scoreLabel: SKLabelNode
    
    
    override func didMove(to view: SKView) {
  
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        
        scene?.size = UIScreen.main.bounds.size
        
        let spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        addChild(spaceBackground)
        
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
        
        addChild(spaceShip)
        
        let asteroidCreate = SKAction.run {
            let asteroid = self.createAsteroid()
            self.addChild(asteroid)
        }
        let asteroidPerSecond: Double = 2.0
        let asteroidCreateDelay = SKAction.wait(forDuration: 1.0 / asteroidPerSecond, withRange: 0.5)
        let asteroidSequenseAction = SKAction.sequence([asteroidCreate, asteroidCreateDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenseAction)
    
        run(asteroidRunAction)
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - scoreLabel.calculateAccumulatedFrame().height - 15)
        
        addChild(scoreLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            let distance = distanceCalculate(a: spaceShip.position, b: touchLocation)
            let speed: CGFloat = 500
            let time = timeToInterval(distance: distance, speed: speed)
            
            let moveAction = SKAction.move(to: touchLocation, duration: time)
            print(distance, time)
            spaceShip.run(moveAction)
        }
    }
    
    
    func createAsteroid() -> SKSpriteNode {
    
        let asteroid = SKSpriteNode(imageNamed: "asteroidImg")
        
        let randomScale = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 6)) / 10
        asteroid.xScale = randomScale
        asteroid.yScale = randomScale
        
        asteroid.position.x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 6))
        asteroid.position.y = frame.size.height/2 + asteroid.size.width
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        asteroid.name = "asteroid"
        
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory
        return asteroid
    }
    
    override func update(_ currentTime: TimeInterval) {
        let asteroid = createAsteroid()
        addChild(asteroid)
        
    }
    
    
    func distanceCalculate(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y))
    }
    
    
    func timeToInterval(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
    }
    
    
    override func didSimulatePhysics() {
        enumerateChildNodes(withName: "asteroid") { asteroid, stop in
            let hightScreen = UIScreen.main.bounds.height
            if asteroid.position.y < -hightScreen {
                asteroid.removeFromParent()
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact!")
    }
    
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }

}
