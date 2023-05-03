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
    
    public static let outside = Contact(point: .zero, normal: .zero, penetration: 0, type: .outside)
    
    public let point: FixVec
    public let normal: FixVec
    public let penetration: FixFloat
    public let type: ContactType

    public init(point: FixVec, normal: FixVec, penetration: FixFloat, type: ContactType) {
        self.point = point
        self.normal = normal
        self.penetration = penetration
        self.type = type
    }
}
