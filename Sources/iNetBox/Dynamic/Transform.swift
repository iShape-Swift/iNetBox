//
//  Transform.swift
//  
//
//  Created by Nail Sharipov on 11.04.2023.
//

import iSpace

public struct Transform {
    
    public static let zero = Transform(position: .zero, angle: 0)
    
    public let position: FixVec
    public let angle: FixFloat
    
    @usableFromInline
    var rotator: RotationMatrix
    
    @inlinable
    public init(position: FixVec, angle: FixFloat) {
        self.position = position
        self.angle = angle
        if angle != 0 {
            rotator = angle.radToFixAngle.rotator
        } else {
            rotator = .init(sin: 0, cos: .unit)
        }
    }
    
    @inlinable
    init(position: FixVec, angle: FixFloat, rotator: RotationMatrix) {
        self.position = position
        self.angle = angle
        self.rotator = rotator
    }
    
    @inlinable
    public func toLocal(point: FixVec) -> FixVec {
        rotator.rotateForward(point: point - position)
    }

    @inlinable
    public func toWorld(point: FixVec) -> FixVec {
        rotator.rotateBack(point: point) + position
    }

    @inlinable
    public func toLocal(vector: FixVec) -> FixVec {
        rotator.rotateForward(point: vector)
    }

    @inlinable
    public func toWorld(vector: FixVec) -> FixVec {
        rotator.rotateBack(point: vector)
    }
    
    @inlinable
    public func toWorld(boundary: Boundary) -> Boundary {
        if angle == 0 {
            return boundary.translate(delta: position)
        } else {
            let a0 = FixVec(boundary.pMin.x, boundary.pMin.y)
            let a1 = FixVec(boundary.pMin.x, boundary.pMax.y)
            let a2 = FixVec(boundary.pMax.x, boundary.pMax.y)
            let a3 = FixVec(boundary.pMax.x, boundary.pMin.y)
            
            let b0 = toWorld(point: a0)
            let b1 = toWorld(point: a1)
            let b2 = toWorld(point: a2)
            let b3 = toWorld(point: a3)
            
            let minX = min(min(b0.x, b1.x), min(b2.x, b3.x))
            let minY = min(min(b0.y, b1.y), min(b2.y, b3.y))
            
            let maxX = max(max(b0.x, b1.x), max(b2.x, b3.x))
            let maxY = max(max(b0.y, b1.y), max(b2.y, b3.y))
            
            return Boundary(pMin: FixVec(minX, minY), pMax: FixVec(maxX, maxY))
        }
    }
    
    @inlinable
    public func toWorld(contact: Contact) -> Contact {
        let point = toWorld(point: contact.point)
        let normalA = toWorld(vector: contact.normalA)
        
        return Contact(point: point, normalA: normalA, radiusA: contact.radiusA, radiusB: contact.radiusB, type: contact.type)
    }
    
    
    @inlinable
    public func apply(velocity v: Velocity, timeScale: Int64) -> Transform {
        let dv = v.linear.divTwo(timeScale)
        let p = position + dv
        
        if v.angular != 0 {
            let a = angle + v.angular >> timeScale
            return Transform(position: p, angle: a)
        } else {
            return Transform(position: p, angle: angle, rotator: rotator)
        }
    }
    
}


extension Transform: Equatable {
    
    @inlinable
    public static func == (lhs: Transform, rhs: Transform) -> Bool {
        lhs.angle == rhs.angle && lhs.position == rhs.position
    }
    
}
