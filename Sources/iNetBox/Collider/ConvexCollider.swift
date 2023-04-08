//
//  ConvexCollider.swift
//  
//
//  Created by Nail Sharipov on 05.04.2023.
//

import iSpace

public struct ConvexCollider {

    public let center: FixVec
    public let points: [FixVec]
    public let normals: [FixVec]
    public let box: BoundryBox

    func set(pos: FixVec) {
        
        // recalculate boundary
    }

    func set(angle: FixVec) {
        
        // recalculate boundary
    }

    func set(pos: FixVec, angle: FixVec) {
        
        // recalculate boundary
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

        self.points = points
        self.center = FixVec(x, y)
        self.normals = normals
        self.box = BoundryBox(points: points)
    }
    
}
