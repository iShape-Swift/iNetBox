//
//  BoundryBox.swift
//  
//
//  Created by Nail Sharipov on 05.04.2023.
//

import iSpace

public struct Boundary {

    public static let zero = Boundary(pMin: .zero, pMax: .zero)
    
    public let pMin: FixVec
    public let pMax: FixVec
    
    @inlinable
    public init(pMin: FixVec, pMax: FixVec) {
        self.pMin = pMin
        self.pMax = pMax
    }

    @inlinable
    public init(radius: FixFloat) {
        self.pMin = FixVec(-radius, -radius)
        self.pMax = FixVec(radius, radius)
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
    public init(boxes: [Boundary]) {
        let n = boxes.count
        guard n > 0 else {
            self = Boundary(pMin: .zero, pMax: .zero)
            return
        }
        
        var boundary = boxes[0]

        var i = 1

        while i < n {
            boundary = boundary.union(boxes[i])
            i += 1
        }
        self = boundary
    }

    public func translate(delta: FixVec) -> Boundary {
        Boundary(pMin: pMin + delta, pMax: pMax + delta)
    }
    
    @inlinable
    public func union(_ box: Boundary) -> Boundary {
        let minX = min(pMin.x, box.pMin.x)
        let minY = min(pMin.y, box.pMin.y)
        let maxX = max(pMax.x, box.pMax.x)
        let maxY = max(pMax.y, box.pMax.y)
        
        return Boundary(pMin: FixVec(minX, minY), pMax: FixVec(maxX, maxY))
    }
    
    @inlinable
    public func isCollide(box: Boundary) -> Bool {
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
    public func isCollideCircle(center: FixVec, radius: FixFloat) -> Bool {
        // Compute the closest point to the circle center within the box
        let cx = max(pMin.x, min(center.x, pMax.x))
        let cy = max(pMin.y, min(center.y, pMax.y))

        let sqrDist = FixVec(cx, cy).sqrDistance(center)

        return sqrDist <= radius.sqr
    }

}
