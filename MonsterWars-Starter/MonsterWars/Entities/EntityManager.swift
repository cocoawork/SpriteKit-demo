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
    var toRemove = Set<GKEntity>()
    lazy var componentSystems: [GKComponentSystem] = {
        let castleSystem = GKComponentSystem(componentClass: CastleComponent.self)
        return [castleSystem]
    }()

    init(sence: SKScene) {
        self.sence = sence
    }

    func addEntity(_ entity: GKEntity) {
        entities.insert(entity)
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            sence.addChild(node)
        }
        for sys in componentSystems {
            sys.addComponent(foundIn: entity)
        }
    }

    func removeEntity(_ entity: GKEntity) {
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            node.removeFromParent()
        }
        entities.remove(entity)
        toRemove.insert(entity)
    }

    func update(_ deltaTime: CFTimeInterval) {
        // 1
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }

        // 2
        for currentRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        toRemove.removeAll()
    }

    func castle(for team: Team) -> GKEntity? {
        for entity in entities {
            if let component = entity.component(ofType: TeamComponent.self),
                let _ = entity.component(ofType: CastleComponent.self) {
                if component.team == team {
                    return entity
                }
            }
        }
        return nil
    }

    func addQurik(forTeam team: Team) {
        if let teamEntity = castle(for: team) {
            guard let teamCastleComponent = teamEntity.component(ofType: CastleComponent.self),
                let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else { return }


            if teamCastleComponent.coins < costQuirk {
                return
            }

            teamCastleComponent.coins -= costQuirk
            sence.run(SoundManager.sharedInstance.soundSpawn)

            let monster = Quirk(team: team)
            if let spriteComponent = monster.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: spriteComponent.node.size.width / 2, y: CGFloat.random(min: sence.size.height * 0.3, max: sence.size.height * 0.6))
                spriteComponent.node.zPosition = 2
            }
            addEntity(monster)

        }
    }


    func entities(forTeam team: Team) -> [GKEntity] {
        return entities.flatMap({ entity in
            if let teamComponent = entity.component(ofType: TeamComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
            return nil
        })
    }


    func moveComponent(forTeam team: Team) -> [MoveComponent] {
        let entityToMove = entities(forTeam: team)
        var moveComponents = [MoveComponent]()
        for entity in entityToMove {
            if let moveComponent = entity.component(ofType: MoveComponent.self) {
                moveComponents.append(moveComponent)
            }
        }
        return moveComponents
    }

}
