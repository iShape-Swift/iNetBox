//
//  Shape.swift
//  
//
//  Created by Nail Sharipov on 07.04.2023.
//

import iSpace

public struct Shape {
    
    static let empty = Shape(transform: .zero, boundry: .zero, collider: .empty)

    public var transform: Transform
    public private (set) var boundry: Boundary
    public var collider: Collider
    
    mutating func revalidateBoundary() {
        boundry = transform.toWorld(boundary: collider.boundry)
    }
    
}
