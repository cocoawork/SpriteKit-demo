//
//  GameScene.swift
//  PlayPlain
//
//  Created by cocoawork on 2017/9/29.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {

    var player: PlayerNode!
    var lastShotTime = TimeInterval(0)
    var winLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.gravity = CGVector.zero
        self.physicsWorld.contactDelegate = self
        addPlayer()
        addMinion()
        self.run(SoundManager.shareInstance.backgroundMusic)
        minionShot()
    }

    func addPlayer() {
        //创建玩家
        let texture = SKTexture(imageNamed: "player")
        self.player = PlayerNode(texture: texture, color: UIColor.white, size: CGSize(width: 90, height: 100))
        player.position = CGPoint(x: size.width / 2, y: size.height / 3)
        player.zPosition = 5
        self.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = 3
        self.physicsBody?.contactTestBitMask = 4
        player.name = "player"
        self.addChild(player)
    }

    func addMinion() {
        //每行放置8个小兵
        let total = 8
        for idx in 0..<total {
            let minionType = arc4random() % 2 == 0 ? "1" : "2"
            let texture = SKTexture(imageNamed: "minion\(minionType)")
            let m = MinionNode(texture: texture, color: UIColor.clear, size: CGSize(width: 30, height: 30))
            let x = (size.width - 240 ) / 2
            m.position = CGPoint(x: CGFloat(Int(x)  + 30 * idx), y: size.height / 3 * 2)
            m.zPosition = 2
            m.name = "minion"
            m.physicsBody = SKPhysicsBody(rectangleOf: m.size)
            m.physicsBody?.isDynamic = true
            m.physicsBody?.categoryBitMask = 2
            m.physicsBody?.contactTestBitMask = 1
            self.addChild(m)
        }
    }

    func playerShot() {
        //创建子弹
        let bullet = SKSpriteNode(color: UIColor.white, size: CGSize(width: 5, height: 5))
        bullet.position = CGPoint(x: player.position.x, y: player.position.y)
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = 1
        bullet.physicsBody?.contactTestBitMask = 2
        bullet.run(SKAction.sequence([SKAction.moveBy(x: 0, y: UIScreen.main.bounds.size.height, duration: 1.8), SKAction.removeFromParent()]))
        bullet.zPosition = 2
        bullet.name = "playerShotBullet"
        self.addChild(bullet)
    }

    func minionShot() {
        var idx = 0
        let a: Double = Double(self.children.count + 1)
        let tmp = arc4random() % UInt32(a)
        for node in self.children {
            if tmp == idx {
                if node.isKind(of: MinionNode.self) {
                    let bullet = SKSpriteNode(color: UIColor.groupTableViewBackground, size: CGSize(width: 3, height: 3))
                    bullet.position = node.position
                    bullet.run(SKAction.sequence([SKAction.moveBy(x: 0, y: -UIScreen.main.bounds.size.height, duration: 2.5), SKAction.removeFromParent()]))
                    bullet.zPosition = 5
                    bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
                    bullet.physicsBody?.isDynamic = true
                    bullet.physicsBody?.categoryBitMask = 4
                    bullet.physicsBody?.contactTestBitMask = 3
                    bullet.name = "minionShotBullet"
                    self.addChild(bullet)
                }
            }
            idx += 1
        }
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if currentTime - lastShotTime > 1 {
            let shotAction = SKAction.run {
                self.playerShot()
                self.minionShot()
            }
            self.run(SKAction.repeatForever(SKAction.sequence([shotAction, SKAction.wait(forDuration: 1)])))
        }
        lastShotTime = currentTime

        var minions = [MinionNode]()
        for node in self.children {
            if node.isKind(of: MinionNode.self) {
                minions.append(node as! MinionNode)
            }
        }

        if minions.count == 0 {
            if winLabel == nil {
                self.winLabel = SKLabelNode(text: "Win!")
                winLabel.fontSize = 50
                winLabel.fontColor = UIColor.white
                winLabel.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
                winLabel.zPosition = 6
                winLabel.fontName = "VCR OSD Mono"
                self.addChild(winLabel)
            }
        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //得到触摸位置
        let point = touches.first?.location(in: self)
        player.moveTo(location: point!)

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let point = touches.first?.location(in: self)
        player.moveTo(location: point!)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact){

        if (contact.bodyA.node?.physicsBody?.categoryBitMask == 2 && contact.bodyB.node?.physicsBody?.categoryBitMask == 1) {
            self.run(SoundManager.shareInstance.hitMusic)
            contact.bodyA.node?.run(SKAction.removeFromParent())
            contact.bodyB.node?.run(SKAction.removeFromParent())
        }

        print("bodyA = \(contact.bodyA.node?.name) || bodyB = \(contact.bodyB.node?.name)")

        if ([UInt32(3), UInt32(4)].contains((contact.bodyA.node?.physicsBody?.categoryBitMask)!) && [UInt32(3), UInt32(4)].contains((contact.bodyB.node?.physicsBody?.categoryBitMask)!) ){
            self.run(SoundManager.shareInstance.hitMusic)
        }
    }
}
