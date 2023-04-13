//
//  Body.swift
//  
//
//  Created by Nail Sharipov on 06.04.2023.
//

import iSpace

public enum BodyType {
    case player
    case bullet
}

public struct Body: IdItem {
    
    public let id: Int64
    public let type: BodyType

    public internal (set) var shape: Shape = .empty
    public internal (set) var mass: FixFloat
    public internal (set) var velocity: Velocity = .zero
    public internal (set) var material: Material = .normal
    
    public init(id: Int64, type: BodyType, mass: FixFloat) {
        self.id = id
        self.type = type
        self.mass = mass
    }
    
}
