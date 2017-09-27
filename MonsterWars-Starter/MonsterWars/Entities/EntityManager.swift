//
//  EntityManager.swift
//  MonsterWars
//
//  Created by cocoawork on 2017/9/27.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit

class EntityManager {
    var entities = Set<GKEntity>()
    var sence: SKScene!

    init(sence: SKScene) {
        self.sence = sence
    }

    func addEntity(_ entity: GKEntity) {
        entities.insert(entity)
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            sence.addChild(node)
        }
    }

    func removeEntity(_ entity: GKEntity) {
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            node.removeFromParent()
        }
        entities.remove(entity)
    }


}
