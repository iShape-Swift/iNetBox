//
//  Collider.swift
//  
//
//  Created by Nail Sharipov on 06.04.2023.
//


public enum ColliderForm {
    case circle
    case convex
    case complex
    case empty
}

public struct Collider {
    
    public static let empty = Collider(boundry: .zero, form: .empty,  data: 0)
    
    public let boundry: Boundary
    public let form: ColliderForm
    public let data: Int64          // id, radius
}
