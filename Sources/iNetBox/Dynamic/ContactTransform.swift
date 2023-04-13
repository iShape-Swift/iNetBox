//
//  ContactTransform.swift
//  
//
//  Created by Nail Sharipov on 12.04.2023.
//

import iSpace

struct ContactTransform {
    
    let v0: FixVec // ox
    let v1: FixVec // oy
    let pos: FixVec
    
    init(normal n: FixVec, pos: FixVec) {
        v0 = FixVec(n.y, -n.x)
        v1 = n
        self.pos = pos
    }
    
    @inlinable
    func toLocal(vector v: FixVec) -> FixVec {
        let x = v.dotProduct(v0)
        let y = v.dotProduct(v1)
        
        return FixVec(x, y)
    }

    @inlinable
    func toWorld(vector v: FixVec) -> FixVec {
        let i0 = FixVec(v0.x, v1.x)
        let i1 = FixVec(v0.y, v1.y)
        
        let x = v.dotProduct(i0)
        let y = v.dotProduct(i1)
        
        return FixVec(x, y)
    }
    
}
