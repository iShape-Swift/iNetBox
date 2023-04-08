//
//  BoundryCircle.swift
//  
//
//  Created by Nail Sharipov on 05.04.2023.
//

import iSpace

public struct BoundryCircle {
    
    public let center: FixVec
    public let radius: FixFloat
    public let sqrRadius: FixFloat
    
    @inlinable
    public init(center: FixVec, radius: FixFloat) {
        self.center = center
        self.radius = radius
        self.sqrRadius = radius.sqr
    }
    
    @inlinable
    public func isCollide(circle: BoundryCircle) -> Bool {
        let sqrD = circle.center.sqrDistance(center)
        return sqrD >= circle.sqrRadius + sqrRadius
    }
    
}
