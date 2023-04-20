//
//  Contact.swift
//  
//
//  Created by Nail Sharipov on 07.04.2023.
//

import iSpace

public enum ContactType {
    case outside
    case inside
    case collide
}

public struct Contact {
    
    static let outside = Contact(point: .zero, normalA: .zero, radiusA: 0, radiusB: 0, type: .outside)
    
    public let point: FixVec
    public let normalA: FixVec
    public let normalB: FixVec
    public let radiusA: FixFloat
    public let radiusB: FixFloat
    public let type: ContactType
    
    @inlinable
    init(point: FixVec, normalA: FixVec, radiusA: FixFloat, radiusB: FixFloat, type: ContactType) {
        self.point = point
        self.normalA = normalA
        self.normalB = FixVec(-normalA.x, -normalA.y)
        self.radiusA = radiusA
        self.radiusB = radiusB
        self.type = type
    }

    @inlinable
    init(point: FixVec, normalB: FixVec, radiusA: FixFloat, radiusB: FixFloat, type: ContactType) {
        self.point = point
        self.normalA = FixVec(-normalB.x, -normalB.y)
        self.normalB = normalB
        self.radiusA = radiusA
        self.radiusB = radiusB
        self.type = type
    }
    
    @inlinable
    func swap() -> Contact {
        Contact(point: point, normalA: normalB, radiusA: radiusB, radiusB: radiusA, type: type)
    }
}
