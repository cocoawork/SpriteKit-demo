/**
 Copyright (c) 2016 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import SpriteKit

class GameScene: SKScene {
  
    var shadow: SKNode!
    var lowerTorso: SKNode!
    
    var upperTorso: SKNode!
    var upperArmFront: SKNode!
    var lowerArmFront: SKNode!
    var upperArmBack: SKNode!
    var lowerArmBack: SKNode!
    
    var head: SKNode!
    var targetNode = SKNode()
    
    
    var fistFront: SKNode!
    var fistBack: SKNode!
    
    let upperArmAngleDeg: CGFloat = -10
    let lowerArmAngleDeg: CGFloat = 130
    
    
    var rightPunch = true
    var firstTouch = false
    
    var lastSpawnTimeInterval: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    
    
  override func didMove(to view: SKView) {
    lowerTorso = childNode(withName: "torso_lower")
    lowerTorso.position = CGPoint(x: frame.midX, y: frame.midY - 30)
    
    //3
    shadow  = childNode(withName: "shadow")
    shadow.position = CGPoint(x: frame.midX, y: frame.midY - 100)
    
    upperTorso = lowerTorso.childNode(withName: "torso_upper")
    head = upperTorso.childNode(withName: "head")
    
    upperArmFront = upperTorso.childNode(withName: "arm_upper_front")
    lowerArmFront = upperArmFront.childNode(withName: "arm_lower_front")
    upperArmBack = upperTorso.childNode(withName: "arm_upper_back")
    lowerArmBack = upperArmBack.childNode(withName: "arm_lower_back")
    fistFront = lowerArmFront.childNode(withName: "fist_front")
    fistBack = lowerArmBack.childNode(withName: "fist_back")
    
    let rotationLimit = SKReachConstraints(lowerAngleLimit: CGFloat(0), upperAngleLimit: CGFloat(160))
    lowerArmFront.reachConstraints = rotationLimit
    lowerArmBack.reachConstraints = rotationLimit
    
    
    let headConstraint = SKConstraint.orient(to: targetNode, offset: SKRange(constantValue: 0))
    let range = SKRange(lowerLimit: CGFloat(-50).degreesToRadians(), upperLimit: CGFloat(80).degreesToRadians())
    let rotationConstraint = SKConstraint.zRotation(range)
    headConstraint.enabled = false
    rotationConstraint.enabled = false
    head.constraints = [headConstraint, rotationConstraint]
  }
    
    
    func punchAt(_ location: CGPoint, upperArmNode: SKNode, lowerArmNode: SKNode, fistNode: SKNode) {
        let punch = SKAction.reach(to: location, rootNode: upperArmNode, duration: 0.1)
        let restore = SKAction.run {
            upperArmNode.run(SKAction.rotate(toAngle: self.upperArmAngleDeg.degreesToRadians(), duration: 0.1))
            lowerArmNode.run(SKAction.rotate(toAngle: self.lowerArmAngleDeg.degreesToRadians(), duration: 0.1))
        }
        fistNode.run(SKAction.sequence([punch, restore]))
    }
    
    func punchAt(_ location: CGPoint) {
        // 2
        if rightPunch {
            punchAt(location, upperArmNode: upperArmFront, lowerArmNode: lowerArmFront, fistNode: fistFront)
        }
        else {
            punchAt(location, upperArmNode: upperArmBack, lowerArmNode: lowerArmBack, fistNode: fistBack)
        }
        // 3
        rightPunch = !rightPunch
    }
    
    // 3
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !firstTouch {
            for c in head.constraints! {
                c.enabled = true
            }
            firstTouch = true
        }
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            punchAt(location)
            targetNode.position = location
            lowerTorso.xScale = location.x > lowerTorso.frame.midX ? abs(lowerTorso.xScale) : abs(lowerTorso.xScale) * -1
            shadow.xScale = location.x > lowerTorso.frame.midX ? abs(shadow.xScale) : abs(shadow.xScale) * -1
        }
    }
    
    
    func addShuriken() {
        
        let shuriken = SKSpriteNode(imageNamed: "projectile")
        //得到随机Y位置
        let minY = lowerTorso.position.y - 60
        let maxY = lowerTorso.position.y + 100
        let actualY = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(maxY - minY)) + minY
        //得到随机X位置  0:屏幕左侧/1:屏幕右侧
        let leftOrRight = arc4random() % 2
        let actualX = leftOrRight == 0 ? -(shuriken.size.width / 2) : size.width + shuriken.size.width / 2
        shuriken.position = CGPoint(x: actualX, y: actualY)
        shuriken.zPosition = 1
        shuriken.name = "shuriken"
        self.addChild(shuriken)
        
        //运行动画
        //1.飞行动画
        let time = CGFloat(arc4random()).truncatingRemainder(dividingBy: 1) + 1.5
        let moveAction = SKAction.move(to: CGPoint(x: size.width / 2, y: actualY), duration: TimeInterval(time))
        let removeAction = SKAction.removeFromParent()
        shuriken.run(SKAction.sequence([moveAction, removeAction]))
        //旋转动画
        let rotationAction = SKAction.rotate(byAngle: CGFloat(-90).degreesToRadians(), duration: 0.1)
        let r = SKAction.repeatForever(rotationAction)
        shuriken.run(SKAction.repeatForever(r))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let res = currentTime.truncatingRemainder(dividingBy: 1)
        if res < 0.03 || (res > 0.47 && res < 0.5){
            self.addShuriken()
        }
    }
    
    
    func hitCheck(forNode: SKNode) -> SKAction {
        return SKAction.run {
            for object in self.children {
                if let node = object as? SKSpriteNode {
                    if node.name == "shuriken" {
                        let effectorInNode = self.convert(forNode.position, from: forNode.parent!)  //把待检测节点的位置转换到在其父节点坐标系统中的位置
                        let n = self.convert(node.frame.origin, from: node.parent!)
                    }
                }
            }
        }
    }
    
}
