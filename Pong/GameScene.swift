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
        
        labels["gameStatusLabel"] = self.childNode(withName: "gameStatusLabel") as? SKLabelNode
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        labels["gameStatusLabel"]?.text = "\(self.seconds)"
        
        let frameBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        frameBody.friction = 0
        frameBody.restitution = 1
        
        self.physicsBody = frameBody
        
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.ballEffect), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        self.labels["gameStatusLabel"]?.text = "\(self.seconds)"
        if(seconds == 0){
            gameTimer.invalidate()
            self.labels["gameStatusLabel"]?.text = ""
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
            
            _ = setTimeout(3, block: { () -> Void in
                self.applyImpulseBall()
            })
        }
        if(Float((elements["ball"]?.position.y)!) > Float((elements["playerTop"]?.position.y)!)){
            labels["playerBottomScore"] = self.childNode(withName: "playerBottomScore") as? SKLabelNode
            playerBottomScore += 1
            labels["playerBottomScore"]?.text = "\(playerBottomScore)"
            
            self.resetBall()
            
            _ = setTimeout(3, block: { () -> Void in
                self.applyImpulseBall()
            })
        }
    }
    
    @objc func ballEffect(){
        let rand = Int(arc4random_uniform(2))
        if(rand == 0){
            self.labels["gameStatusLabel"]?.text = "The ball is fastest"
            self.elements["ball"]?.physicsBody?.mass = 0.02
            return
        }else{
            self.labels["gameStatusLabel"]?.text = "The ball is growing"
            self.elements["ball"]?.size.width = 120
            self.elements["ball"]?.size.height = 120
            return
        }
    }
    
    func resetBall(){
        labels["gameStatusLabel"]?.text = ""
        elements["ball"]?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        elements["ball"]?.physicsBody?.mass = 0.0500000081956387
        elements["ball"]?.run(SKAction.moveTo(x: 0, duration: 0))
        elements["ball"]?.run(SKAction.moveTo(y: 0, duration: 0))
        self.elements["ball"]?.size.width = 40
        self.elements["ball"]?.size.height = 40
    }
    
    func applyImpulseBall(){
        let rand = Int(arc4random_uniform(2))
        let rand2 = Int(arc4random_uniform(2))
        
        elements["ball"]?.physicsBody?.applyImpulse(CGVector(dx: rand == 0 ? 30 : -30, dy: rand2 == 0 ? 30 : -30))
    }
}
