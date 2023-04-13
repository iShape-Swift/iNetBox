//
//  Land.swift
//  
//
//  Created by Nail Sharipov on 07.04.2023.
//

import iSpace

public struct Land: IdItem {
    
    public let id: Int64

    public internal (set) var shape: Shape = .empty
    public internal (set) var velocity: Velocity = .zero
    public internal (set) var material: Material = .normal
 
    public init(id: Int64) {
        self.id = id
    }
    
}
