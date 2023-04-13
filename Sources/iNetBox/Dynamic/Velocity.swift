//
//  Velocity.swift
//  
//
//  Created by Nail Sharipov on 12.04.2023.
//

import iSpace

public struct Velocity {
    
    public static let zero = Velocity(linear: .zero, angular: 0)
    
    public let linear: FixVec
    public let angular: FixFloat
    
    @inlinable
    public var isZero: Bool {
        linear == .zero && angular == 0
    }
    
    public init(linear: FixVec, angular: FixFloat = 0) {
        self.linear = linear
        self.angular = angular
    }

}
