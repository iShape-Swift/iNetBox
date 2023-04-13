//
//  CircleCollider.swift
//  
//
//  Created by Nail Sharipov on 10.04.2023.
//

import iSpace

public struct CircleCollider {
    
    // in local parent cordinat system
    public let center: FixVec
    public let radius: FixFloat

    public init(center: FixVec, radius: FixFloat) {
        self.center = center
        self.radius = radius
    }
    
    public func collide(circle: CircleCollider) -> Contact {
        let ca = center
        let cb = circle.center
        
        let ra = radius
        let rb = circle.radius

        let sqrC = ca.sqrDistance(cb)

        guard (ra + rb).sqr >= sqrC else {
            return .outside
        }
        
        let sqrA = ra.sqr
        let sqrB = rb.sqr
        
        if sqrC >= sqrA && sqrC >= sqrB {
            let k = (sqrB - sqrA + sqrC).div(sqrC) >> 1
            
            let dv = ca - cb
            
            let p = cb + dv * k

            return Contact(point: p, normalA: dv.normalize, type: .collide)
        } else {
            let p = (ca + cb).half
            return Contact(point: p, normalA: .zero, type: .inside)
        }
    }
}
