//
//  Material.swift
//  
//
//  Created by Nail Sharipov on 12.04.2023.
//

import iSpace

public struct Material {

    public static let normal = Material(bounce: .unit, friction: .unit)
    
    public let bounce: FixFloat
    public let friction: FixFloat
    
}
