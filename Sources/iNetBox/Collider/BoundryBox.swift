//
//  BoundryBox.swift
//  
//
//  Created by Nail Sharipov on 05.04.2023.
//

import iSpace

public struct BoundryBox {

    public let pMin: FixVec
    public let pMax: FixVec
    
    @inlinable
    public init(pMin: FixVec, pMax: FixVec) {
        self.pMin = pMin
        self.pMax = pMax
    }
    
    @inlinable
    public init(points: [FixVec]) {
        let n = points.count
        var i = 1

        let p0 = points[0]
        var minX = p0.x
        var maxX = p0.x
        var minY = p0.y
        var maxY = p0.y

        while i < n {
            let p = points[i]
            i += 1

            if minX > p.x {
                minX = p.x
            } else if maxX < p.x {
                maxX = p.x
            }

            if minY > p.y {
                minY = p.y
            } else if maxY < p.y {
                maxY = p.y
            }
        }
        
        self.pMin = FixVec(minX, minY)
        self.pMax = FixVec(maxX, maxY)
    }

    @inlinable
    public func union(_ box: BoundryBox) -> BoundryBox {
        let minX = min(pMin.x, box.pMin.x)
        let minY = min(pMin.y, box.pMin.y)
        let maxX = max(pMax.x, box.pMax.x)
        let maxY = max(pMax.y, box.pMax.y)
        
        return BoundryBox(pMin: FixVec(minX, minY), pMax: FixVec(maxX, maxY))
    }
    
    @inlinable
    public func isCollide(box: BoundryBox) -> Bool {
        // Check if the bounding boxes intersect in any dimension
        if pMax.x < box.pMin.x || pMin.x > box.pMax.x {
            return false
        }
        if pMax.y < box.pMin.y || pMin.y > box.pMax.y {
            return false
        }
        return true
    }

    
    @inlinable
    public func isCollide(circle: BoundryCircle) -> Bool {
        // Compute the closest point to the circle center within the box
        let closestX = max(pMin.x, min(circle.center.x, pMax.x))
        let closestY = max(pMin.y, min(circle.center.y, pMax.y))
        
        // Check if the distance from the closest point to the circle center is less than the circle radius
        let dx = closestX - circle.center.x
        let dy = closestY - circle.center.y
        let distanceSquared = dx.sqr + dy.sqr

        return distanceSquared <= circle.sqrRadius
    }

}
