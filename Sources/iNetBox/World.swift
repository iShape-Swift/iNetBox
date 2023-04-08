//
//  World.swift
//  
//
//  Created by Nail Sharipov on 04.04.2023.
//

import iSpace

public struct WorldSettings {
    
    let timeScale: Int = 4
    
    let bodyTimeScale: Int = 2
    
    let bodyRatio: Int
    
    let isBvB = false
    let isPvP = false
    
    let playerRadius: FixFloat = .unit
    
    init() {
        bodyRatio = timeScale / bodyTimeScale
    }

}

public struct World {
    
    public var settings = WorldSettings()
    
    var playerList = SortedList<Body>()
    var bulletList = SortedList<Body>()
    var landList = SortedList<Land>()

    var complexColliders = [Int64: ComplexCollider]()
    var time: Int64

    mutating func iterate() {
        let timeScale = settings.timeScale
        
        var  i = 0

        // update lands first
        
        while i < landList.items.count {
            var land = landList.items[i]
            if !land.isStatic {
                
                let x = land.pos.x + land.vel.x << timeScale
                let y = land.pos.y + land.vel.y << timeScale
                
                land.pos = FixVec(x, y)
                
                if land.rotVel != 0 {
                    land.angle = land.angle + land.rotVel << timeScale
                }
                
                landList.items[i] = land
                
                // TODO update colliders
            }
            i += 1
        }
        
        // update players
        
        let playerTimeScale = settings.bodyTimeScale
        var playerRatio = settings.bodyRatio
        
        var s = 0
        let plCount = playerList.items.count
        let btCount = bulletList.items.count

        while s < playerRatio {
            s += 1
            
            // update players
            
            var j = 0
            
            while j < plCount {
                var player = playerList.items[j]

                let x = player.pos.x + player.vel.x << playerTimeScale
                let y = player.pos.y + player.vel.y << playerTimeScale
                
                player.pos = FixVec(x, y)
                player.angle = player.angle + player.rotVel << playerTimeScale

                playerList.items[j] = player
                
                // TODO collide with land

                j += 1
            }
            
            // update bullets
            
            j = 0
            
            while j < btCount {
                var bullet = playerList.items[j]

                let x = bullet.pos.x + bullet.vel.x << playerTimeScale
                let y = bullet.pos.y + bullet.vel.y << playerTimeScale
                
                bullet.pos = FixVec(x, y)
                bullet.angle = bullet.angle + bullet.rotVel << playerTimeScale

                playerList.items[j] = bullet
                
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
                        
                        plA
                        
                        i += 1
                    }
                    
                    j += 1
                }
            }

            // collide bullet vs player
            
            if plCount > 0 && btCount > 0 {
                
                
                
            }
            
            // collide bullet vs bullet
            
            if settings.isBvB && btCount > 1 {
                j = 0
                // TODO optimize
                while j < plCount - 1 {
                    var plA = playerList.items[j]
                    var i = j + 1
                    while i < plCount {
                        var plB = playerList.items[i]
                        
                        // collide with player
                        
                        plA
                        
                        i += 1
                    }
                    
                    j += 1
                }
            }
            
        }
    }
    
    
    mutating func addBody(_ body: Body) {
        playerList.add(body)
    }

    func addLand(body: Body, collider: ComplexCollider) {
        
    }
    
}
