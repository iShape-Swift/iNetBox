//
//  World.swift
//  
//
//  Created by Nail Sharipov on 04.04.2023.
//

import iSpace

public struct WorldSettings {
    
    let timeScale: Int = 4 // 2^4
    
    let bodyTimeScale: Int = 2 // 2^2
    
    let isBvB = false
    let isPvP = false
    
    let playerRadius: FixFloat = .unit
}

public struct World {
    
    public var settings = WorldSettings()
    
    var playerList = SortedList<Body>()
    var bulletList = SortedList<Body>()
    var landList = SortedList<Land>()

    var complexColliders = [Int64: ComplexCollider]()
    var convexColliders = [Int64: ConvexCollider]()
    var time: Int64

    public init(time: Int64) {
        self.time = time
    }
    
    public mutating func iterate() {
        let timeScale = 10 - settings.timeScale
        
        var i = 0

        // update lands first
        
        while i < landList.items.count {
            var land = landList.items[i]
            if !land.velocity.isZero {
                var shape = land.shape
                shape.transform = shape.transform.apply(velocity: land.velocity, timeScale: timeScale)
                shape.revalidateBoundary()
                
                land.shape = shape
                landList.items[i] = land
                
                // TODO update colliders
            }
            i += 1
        }
        
        // update players
        
        let bodyTimeScale = 10 - settings.bodyTimeScale
        let bodySteps = 1 << (settings.timeScale - settings.bodyTimeScale)
        
        var s = 0
        let plCount = playerList.items.count
        let btCount = bulletList.items.count

        while s < bodySteps {
            s += 1
            
            // update players
            
            var j = 0
            
            while j < plCount {
                var player = playerList.items[j]

                var shape = player.shape
                shape.transform = shape.transform.apply(velocity: player.velocity, timeScale: bodyTimeScale)
                shape.revalidateBoundary()
                
                player.shape = shape
                playerList.items[j] = player
                
                // TODO collide with land
                
                i = 0
                while i < landList.items.count {
                    self.collide(index: j, player, landList.items[i])
                    i += 1
                }

                j += 1
            }
            
            // update bullets
            
            j = 0
            
            while j < btCount {
                var bullet = bulletList.items[j]
                
                var shape = bullet.shape
                shape.transform = shape.transform.apply(velocity: bullet.velocity, timeScale: bodyTimeScale)
                shape.revalidateBoundary()
                
                bullet.shape = shape

                bulletList.items[j] = bullet
                
                // TODO collide with land

                j += 1
            }
            
            // collide player vs player
            
            if settings.isPvP && plCount > 1 {
                j = 0
                // TODO optimize
                while j < plCount - 1 {
                    var plA = playerList.items[j]
                    var i = j + 1
                    while i < plCount {
                        var plB = playerList.items[i]
                        
                        // collide with player
                        
                        let contact = self.collide(shapeA: plA.shape, shapeB: plB.shape)
                        switch contact.type {
                        case .inside:
                            break
                        case .collide:
                            break
                        default:
                            break
                        }
                        
                        
                        i += 1
                    }
                    
                    j += 1
                }
            }

            // collide bullet vs player
            
            if plCount > 0 && btCount > 0 {
                j = 0
                // TODO optimize
                while j < plCount - 1 {
                    var plA = playerList.items[j]
                    var i = j + 1
                    while i < btCount {
                        var btA = bulletList.items[i]
                        
                        // collide with player
                        
                        let contact = self.collide(shapeA: plA.shape, shapeB: btA.shape)
                        switch contact.type {
                        case .inside:
                            break
                        case .collide:
                            break
                        default:
                            break
                        }
                        
                        
                        i += 1
                    }
                    
                    j += 1
                }
            }
            
            // collide bullet vs bullet
            
            if settings.isBvB && btCount > 1 {
                j = 0
                // TODO optimize
                while j < btCount - 1 {
                    var btA = bulletList.items[j]
                    var i = j + 1
                    while i < btCount {
                        var btB = bulletList.items[i]
                        
                        // collide with player
                        let contact = self.collide(shapeA: btA.shape, shapeB: btB.shape)
                        switch contact.type {
                        case .inside:
                            break
                        case .collide:
                            break
                        default:
                            break
                        }
                        
                        
                        i += 1
                    }
                    
                    j += 1
                }
            }
            
        }
    }
    
    
    public mutating func add(body: Body) {
        playerList.add(body)
    }

    public mutating func add(land: Land) {
        landList.add(land)
    }
    
    public func getBody(id: Int64) -> Body {
        let index = playerList.index(id: id)
        return playerList.items[index]
    }
    
    public func getLand(id: Int64) -> Land {
        let index = landList.index(id: id)
        return landList.items[index]
    }
    
    // set collider
    
    public mutating func setPlayerCollider(circleRadius: FixFloat, playerId: Int64) {
        let index = playerList.index(id: playerId)
        
        var shape = playerList.items[index].shape
        shape.collider = Collider(boundry: BoundaryBox(radius: circleRadius), form: .circle, data: circleRadius)
        shape.revalidateBoundary()
        playerList.items[index].shape = shape
    }
    
    public mutating func setBulletCollider(circleRadius: FixFloat, bulletId: Int64) {
        let index = bulletList.index(id: bulletId)
        
        var shape = bulletList.items[index].shape
        shape.collider = Collider(boundry: BoundaryBox(radius: circleRadius), form: .circle, data: circleRadius)
        shape.revalidateBoundary()
        bulletList.items[index].shape = shape
    }

    public mutating func setLandCollider(circleRadius: FixFloat, landId: Int64) {
        let landId = landList.index(id: landId)
        
        var shape = landList.items[landId].shape
        shape.collider = Collider(boundry: BoundaryBox(radius: circleRadius), form: .circle, data: circleRadius)
        shape.revalidateBoundary()
        
        landList.items[landId].shape = shape
    }

    public mutating func setLandCollider(convex: ConvexCollider, landId: Int64) {
        let index = landList.index(id: landId)
        
        convexColliders[landId] = convex
        var shape = landList.items[index].shape
        shape.collider = Collider(boundry: convex.box, form: .convex, data: landId)
        shape.revalidateBoundary()
        
        landList.items[index].shape = shape
    }
    
    // set position

    public mutating func setPlayer(position: FixVec, angle: FixFloat, playerId: Int64) {
        let index = playerList.index(id: playerId)
        
        var shape = playerList.items[index].shape
        shape.transform = Transform(position: position, angle: angle)
        shape.revalidateBoundary()
        
        playerList.items[index].shape = shape
    }

    public mutating func setBullet(position: FixVec, angle: FixFloat, bulletId: Int64) {
        let index = bulletList.index(id: bulletId)
        
        var shape = bulletList.items[index].shape
        shape.transform = Transform(position: position, angle: angle)
        shape.revalidateBoundary()
        
        bulletList.items[index].shape = shape
    }
    
    public mutating func setLand(position: FixVec, angle: FixFloat, landId: Int64) {
        let index = landList.index(id: landId)
        
        var shape = landList.items[index].shape
        shape.transform = Transform(position: position, angle: angle)
        shape.revalidateBoundary()
        
        landList.items[index].shape = shape
    }
    
    // set velocity

    public mutating func setPlayer(velocity: Velocity, playerId: Int64) {
        let index = playerList.index(id: playerId)
        var body = playerList.items[index]
        body.velocity = velocity
        playerList.items[index] = body
    }

    public mutating func setBullet(velocity: Velocity, bulletId: Int64) {
        let index = bulletList.index(id: bulletId)
        var body = bulletList.items[index]
        body.velocity = velocity
        bulletList.items[index] = body
    }
    
    public mutating func setLand(velocity: Velocity, landId: Int64) {
        let index = landList.index(id: landId)
        var land = landList.items[index]
        land.velocity = velocity
        landList.items[index] = land
    }
}
