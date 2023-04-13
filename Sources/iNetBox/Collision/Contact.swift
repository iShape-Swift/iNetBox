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
    
    static let outside = Contact(point: .zero, normalA: .zero, type: .outside)
    
    public let point: FixVec
    public let normalA: FixVec
    public let normalB: FixVec
    public let type: ContactType
    public let debug: FixVec
    
    @inlinable
    init(point: FixVec, normalA: FixVec, type: ContactType, debug: FixVec = .zero) {
        self.point = point
        self.normalA = normalA
        self.normalB = FixVec(-normalA.x, -normalA.y)
        self.type = type
        self.debug = debug
    }

    @inlinable
    init(point: FixVec, normalB: FixVec, type: ContactType, debug: FixVec = .zero) {
        self.point = point
        self.normalA = FixVec(-normalB.x, -normalB.y)
        self.normalB = normalB
        self.type = type
        self.debug = debug
    }
    
    @inlinable
    func swapNormal() -> Contact {
        Contact(point: point, normalA: normalB, type: type)
    }
}
