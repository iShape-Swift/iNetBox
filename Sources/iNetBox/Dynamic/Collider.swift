//
//  Collider.swift
//  
//
//  Created by Nail Sharipov on 06.04.2023.
//


public enum ColliderForm {
    case circle
    case box
    case complex
    case convex
    case empty
}

public struct Collider {
    
    public static let empty = Collider(form: .empty, data: 0, layer: 0)
    
    public let form: ColliderForm
    public let data: Int64          // id, radius, ab,
    public let layer: Int64
}
