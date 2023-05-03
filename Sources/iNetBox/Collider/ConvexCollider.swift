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
    public let box: Boundary

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

        box = Boundary(pMin: FixVec(-a, -b), pMax: FixVec(a, b))
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

            let nm = FixVec(-e.y, e.x).normalize
            normals[j] = nm
            
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
        self.box = Boundary(points: points)
    }
    
    public init(transform: Transform, collider: ConvexCollider) {
        var pnts = [FixVec](repeating: .zero, count: collider.points.count)
        var nmls = [FixVec](repeating: .zero, count: collider.normals.count)
        for i in 0..<collider.points.count {
            pnts[i] = transform.convert(point: collider.points[i])
            nmls[i] = transform.convert(vector: collider.normals[i])
        }
        
        self.points = pnts
        self.normals = nmls
        self.box = transform.convert(boundary: collider.box)
        self.center = collider.center
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
            return Contact(
                point: faceCenter,
                normal: n1,
                penetration: 0,
                type: .inside
            )
        }

        // Compute barycentric coordinates
        let sqrRadius = circle.radius.sqr
        
        let u1 = (circle.center - v1).dotProduct(v2 - v1)

        if u1 <= 0 {
            guard circle.center.sqrDistance(v1) <= sqrRadius else {
                return .outside
            }

            return Contact(
                point: v1,
                normal: (circle.center - v1).normalize,
                penetration: 0,
                type: .collide
            )
        }

        let u2 = (circle.center - v2).dotProduct(v1 - v2)
        
        if u2 <= 0 {
            guard circle.center.sqrDistance(v2) <= sqrRadius else {
                return .outside
            }

            return Contact(
                point: v2,
                normal: (circle.center - v2).normalize,
                penetration: 0,
                type: .collide
            )
        }

        let s = (circle.center - faceCenter).dotProduct(n1)
        guard s <= circle.radius else {
            return .outside
        }
        
        let d = (circle.center - v2).dotProduct(n1)
        let m = circle.center - d * n1
        
        return Contact(
            point: m,
            normal: n1,
            penetration: 0,
            type: .collide
        )
    }

    public func intersectsWith(other: ConvexCollider) -> Bool {
        let polygons = [self, other]
        
        // Loop through both polygons (0 for self, 1 for other)
        for i in 0..<2 {
            let aPoly = polygons[i]
            let bPoly = polygons[1 - i]
            
            let edgeCount = aPoly.points.count
            
            // For each edge of the current polygon
            for edgeIndex in 0..<edgeCount {
                
                // Calculate the edge's normal vector (perpendicular vector)
                let normal = aPoly.normals[edgeIndex]
                
                // Initialize minimum and maximum projection values for both polygons
                var minProjectionCurrent = FixFloat.max
                var maxProjectionCurrent = FixFloat.min
                var minProjectionNext = FixFloat.max
                var maxProjectionNext = FixFloat.min
                
                // Project all vertices of both polygons onto the normal vector's line (using the dot product)
                for vertex in aPoly.points {
                    let projection = normal.dotProduct(vertex)
                    minProjectionCurrent = min(minProjectionCurrent, projection)
                    maxProjectionCurrent = max(maxProjectionCurrent, projection)
                }
                
                for vertex in bPoly.points {
                    let projection = normal.dotProduct(vertex)
                    minProjectionNext = min(minProjectionNext, projection)
                    maxProjectionNext = max(maxProjectionNext, projection)
                }
                
                // Calculate the separation between the two polygons
                let separation = minProjectionNext - maxProjectionCurrent
                
                // If a positive separation is found, the polygons do not intersect
                if separation > 0 {
                    return false
                }
            }
        }
        
        // If all the separations are negative (or zero), the polygons are intersecting
        return true
    }
    
}
