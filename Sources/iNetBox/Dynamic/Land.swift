//
//  Land.swift
//  
//
//  Created by Nail Sharipov on 07.04.2023.
//

import iSpace

public struct Land: IdItem {
    
    public let id: Int64
    public internal (set) var vel: FixVec = .zero
    public internal (set) var pos: FixVec
    
    public internal (set) var rotVel: FixFloat = 0
    public internal (set) var angle: FixFloat

    public internal (set) var collider: Collider = .empty
    
    public private (set) var isStatic: Bool = true
    
    public init(id: Int64, pos: FixVec, angle: FixFloat) {
        self.id = id
        self.pos = pos
        self.angle = angle
    }
    
    
}
