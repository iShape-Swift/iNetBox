//
//  CollisionResult.swift
//  
//
//  Created by Nail Sharipov on 07.04.2023.
//

import iSpace

struct CollisionResult {
    
    static let empty: CollisionResult = CollisionResult(isCollide: false, contact: .zero, penration: .zero, normal: .zero)
    
    let isCollide: Bool
    let contact: FixVec
    let penration: FixVec
    let normal: FixVec
    
}
