//
//  ConvexCollider.swift
//  
//
//  Created by Nail Sharipov on 05.04.2023.
//

import iSpace

public struct ConvexCollider {

    // in local parent cordinat system
    public let center: FixVec
    public let points: [FixVec]
    public let normals: [FixVec]
    public let box: BoundaryBox

    public init(width w: FixFloat, height h: FixFloat) {
        let a = (w + 1) >> 1
        let b = (h + 1) >> 1
        center = FixVec(0, 0)
        points = [
            FixVec(-a, -b),
            FixVec(-a, b),
            FixVec(a, b),
            FixVec(a, -b)
        ]

        normals = [
            FixVec(-FixFloat.unit, 0),
            FixVec(0, FixFloat.unit),
            FixVec(FixFloat.unit, 0),
            FixVec(0, -FixFloat.unit)
        ]

        box = BoundaryBox(pMin: FixVec(-a, -b), pMax: FixVec(a, b))
    }

    public init(points: [FixVec]) {
        let n = points.count
        assert(n >= 3)
        var normals = [FixVec](repeating: .zero, count: n)

        var centroid = FixVec.zero
        var area: FixFloat = 0
        
        var j = n - 1
        var p0 = points[j]
        
        var i = 0
        while i < n {
            let p1 = points[i]
            let e = p1 - p0

            normals[j] = FixVec(-e.y, e.x).normalize
            
            let crossProduct = p1.crossProduct(p0)
            area += crossProduct
            
            let sp = p0 + p1
            centroid = centroid + sp * crossProduct

            p0 = p1
            
            j = i
            i += 1
        }
        
        area = area >> 1
        let s = 6 * area
        
        let x = centroid.x.div(s)
        let y = centroid.y.div(s)

        self.center = FixVec(x, y)
        self.points = points
        self.normals = normals
        self.box = BoundaryBox(points: points)
    }
    
    // do not work correct with degenerate points
    public func collide(circle: CircleCollider) -> Contact {

        // Find the min separating edge.
        var normalIndex = 0
        var sqrD: FixFloat = Int64.max
        var separation = FixFloat.min
        let n = points.count

        var i = 0
        
        let r = circle.radius + 10
        
        while i < n {
            let d = circle.center - points[i]
            let s = normals[i].dotProduct(d)

            if s > r {
                return .outside
            }

            if s > separation {
                separation = s
                normalIndex = i
                sqrD = d.sqrLength
            } else if s == separation {
                let dd = d.sqrLength
                if dd < sqrD {
                    separation = s
                    normalIndex = i
                    sqrD = dd
                }
            }
            
            i += 1
        }

        // Vertices that subtend the incident face.
        let vertIndex1 = normalIndex
        let vertIndex2 = (vertIndex1 + 1) % n
        let v1 = points[vertIndex1]
        let v2 = points[vertIndex2]
        let n1 = normals[vertIndex1]

        let faceCenter = v1.middle(v2)
        
        // If the center is inside the polygon ...
        if separation < 0 {
            return Contact(point: faceCenter, normalB: n1, type: .inside)
        }

        // Compute barycentric coordinates
        let sqrRadius = circle.radius.sqr
        
        let u1 = (circle.center - v1).dotProduct(v2 - v1)

        if u1 <= 0 {
            guard circle.center.sqrDistance(v1) <= sqrRadius else {
                return .outside
            }

            return Contact(point: v1, normalB: (circle.center - v1).normalize, type: .collide)
        }

        let u2 = (circle.center - v2).dotProduct(v1 - v2)
        
        if u2 <= 0 {
            guard circle.center.sqrDistance(v2) <= sqrRadius else {
                return .outside
            }

            return Contact(point: v2, normalB: (circle.center - v2).normalize, type: .collide)
        }

        let s = (circle.center - faceCenter).dotProduct(n1)
        guard s <= circle.radius else {
            return .outside
        }
        
        let d = (circle.center - v2).dotProduct(n1)
        let m = circle.center - d * n1
        
        return Contact(point: m, normalB: n1, type: .collide)
    }
    
}
