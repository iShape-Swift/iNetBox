//
//  Body.swift
//  
//
//  Created by Nail Sharipov on 06.04.2023.
//

import iSpace

public struct Body: IdItem {
    
    public let id: Int64
    public let isBullet: Bool
    public let isPlayer: Bool

    var vel: FixVec
    var pos: FixVec
    
    var rotVel: FixFloat
    var angle: FixFloat
    
    var mass: FixFloat
    var collider: Collider

}
