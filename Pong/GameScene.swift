//
//  GameScene.swift
//  Pong
//
//  Created by Guillaume Etendard on 08/03/2018.
//  Copyright © 2018 Guillaume Etendard. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    
    var elements = [String: SKSpriteNode]()
    var labels = [String: SKLabelNode]()

    var playerTopScore = 0
    var playerBottomScore = 0
    
    var type: String = ""
    var difficulty: Double = 0.3
    
    var seconds: Int = 3
    
    var gameTimer: Timer!

    override func didMove(to view: SKView) {
        elements["playerTop"] = self.childNode(withName: "playerTop") as? SKSpriteNode
        elements["playerBottom"] = self.childNode(withName: "playerBottom") as? SKSpriteNode
 
        elements["ball"] = self.childNode(withName: "ball") as? SKSpriteNode
        print("did move")
        
        labels["gameStatusLabel"] = self.childNode(withName: "gameStatusLabel") as? SKLabelNode
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        labels["gameStatusLabel"]?.text = "\(self.seconds)"
        
        let frameBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        frameBody.friction = 0
        frameBody.restitution = 1
        
        self.physicsBody = frameBody
    }
    
    @objc func updateTimer() {
        seconds -= 1
        labels["gameStatusLabel"]?.text = "\(self.seconds)"
        if(seconds == 0){
            gameTimer.invalidate()
            labels["gameStatusLabel"]?.text = ""
            self.applyImpulseBall()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.type == "computerGame"){
            for touch in touches{
                elements["playerBottom"]?.run(SKAction.moveTo(x: touch.location(in: self).x, duration: 0.5))
            }
        }else{
            for touch in touches{
                if(touch.location(in: self).y > 0){
                    elements["playerTop"]?.run(SKAction.moveTo(x: touch.location(in: self).x, duration: 0.5))
                }
                if(touch.location(in: self).y < 0){
                    elements["playerBottom"]?.run(SKAction.moveTo(x: touch.location(in: self).x, duration: 0.5))
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.type == "computerGame"){
            for touch in touches{
                elements["playerBottom"]?.run(SKAction.moveTo(x: touch.location(in: self).x, duration: 0.5))
            }
        }else{
            for touch in touches{
                if(touch.location(in: self).y > 0){
                    elements["playerTop"]?.run(SKAction.moveTo(x: touch.location(in: self).x, duration: 0.5))
                }
                if(touch.location(in: self).y < 0){
                    elements["playerBottom"]?.run(SKAction.moveTo(x: touch.location(in: self).x, duration: 0.5))
                }
            }
        }
    }
    
    func setTimeout(_ delay:TimeInterval, block:@escaping ()->Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(self.type == "computerGame"){
            elements["playerTop"]?.run(SKAction.moveTo(x: (elements["ball"]?.position.x)!, duration: self.difficulty))
        }
        
        if(Float((elements["ball"]?.position.y)!) < Float((elements["playerBottom"]?.position.y)!)){
            labels["playerTopScore"] = self.childNode(withName: "playerTopScore") as? SKLabelNode
            playerTopScore += 1
            labels["playerTopScore"]?.text = "\(playerTopScore)"
            
            self.resetBall()
            
            setTimeout(3, block: { () -> Void in
                self.applyImpulseBall()
            })
        }
        if(Float((elements["ball"]?.position.y)!) > Float((elements["playerTop"]?.position.y)!)){
            labels["playerBottomScore"] = self.childNode(withName: "playerBottomScore") as? SKLabelNode
            playerBottomScore += 1
            labels["playerBottomScore"]?.text = "\(playerBottomScore)"
            
            self.resetBall()
            
            setTimeout(3, block: { () -> Void in
                self.applyImpulseBall()
            })
        }
    }
    
    func resetBall(){
        elements["ball"]?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        elements["ball"]?.run(SKAction.moveTo(x: 0, duration: 0))
        elements["ball"]?.run(SKAction.moveTo(y: 0, duration: 0))
    }
    
    func applyImpulseBall(){
        let rand = Int(arc4random_uniform(2))
        let rand2 = Int(arc4random_uniform(2))
        
        var xPos = 30
        var yPos = 30
        if(rand == 0){
            xPos = 30
        }else{
            xPos = -30
        }
        if(rand2 == 0){
            yPos = 30
        }else{
            yPos = -30
        }
        
        print(xPos)
        print(yPos)
        elements["ball"]?.physicsBody?.applyImpulse(CGVector(dx: xPos, dy: yPos))
    }
}