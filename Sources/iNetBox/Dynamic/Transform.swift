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
    public let rotator: FixVec
    
    @inlinable
    public init(position: FixVec, angle: FixFloat) {
        self.position = position
        self.angle = angle
        if angle != 0 {
            rotator = angle.radToFixAngle.rotator
        } else {
            rotator = FixVec(x: .unit, y: 0)
        }
    }
    
    @inlinable
    public func convert(point: FixVec) -> FixVec {
        convert(vector: point) + position
    }
    
    @inlinable
    public func convert(vector: FixVec) -> FixVec {
        let x = (rotator.x * vector.x - rotator.y * vector.y) >> 10
        let y = (rotator.y * vector.x + rotator.x * vector.y) >> 10
        return FixVec(x, y)
    }
    
    @inlinable
    init(position: FixVec, angle: FixFloat, rotator: FixVec) {
        self.position = position
        self.angle = angle
        self.rotator = rotator
    }

    @inlinable
    public func convert(points: [FixVec]) -> [FixVec] {
        var result = [FixVec]()
        for p in points {
            result.append(convert(point: p))
        }
        return result
    }

    
    @inlinable
    public func convert(vectors: [FixVec]) -> [FixVec] {
        var result = [FixVec]()
        for v in vectors {
            result.append(convert(vector: v))
        }
        return result
    }
    
    @inlinable
    public func convert(boundary: Boundary) -> Boundary {
        if angle == 0 {
            return boundary.translate(delta: position)
        } else {
            let a0 = FixVec(boundary.pMin.x, boundary.pMin.y)
            let a1 = FixVec(boundary.pMin.x, boundary.pMax.y)
            let a2 = FixVec(boundary.pMax.x, boundary.pMax.y)
            let a3 = FixVec(boundary.pMax.x, boundary.pMin.y)
            
            let b0 = convert(point: a0)
            let b1 = convert(point: a1)
            let b2 = convert(point: a2)
            let b3 = convert(point: a3)
            
            let minX = min(min(b0.x, b1.x), min(b2.x, b3.x))
            let minY = min(min(b0.y, b1.y), min(b2.y, b3.y))
            
            let maxX = max(max(b0.x, b1.x), max(b2.x, b3.x))
            let maxY = max(max(b0.y, b1.y), max(b2.y, b3.y))
            
            return Boundary(pMin: FixVec(minX, minY), pMax: FixVec(maxX, maxY))
        }
    }
    
    
    @inlinable
    public func convert(contact: Contact) -> Contact {
        let point = convert(point: contact.point)
        let normal = convert(vector: contact.normal)
        
        return Contact(point: point, normal: normal, penetration: contact.penetration, type: contact.type)
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

    public func invert() -> Transform {
        let x = (-rotator.x * position.x - rotator.y * position.y) >> 10
        let y = ( rotator.y * position.x + rotator.x * position.y) >> 10
        
        return Transform(position: FixVec(x, y), angle: -angle, rotator: FixVec(rotator.x, -rotator.y))
    }
    
    public static func convert(from b: Transform, to a: Transform) -> Transform {
        let ang = b.angle - a.angle
        let rot = ang.radToFixAngle.rotator
        
        let cosA = a.rotator.x
        let sinA = a.rotator.y
        
        let dv = b.position - a.position

        let x = (cosA * dv.x + sinA * dv.y) >> 10
        let y = (cosA * dv.y - sinA * dv.x) >> 10
        
        return Transform(position: FixVec(x, y), angle: ang, rotator: rot)
    }
    
}


extension Transform: Equatable {
    
    @inlinable
    public static func == (lhs: Transform, rhs: Transform) -> Bool {
        lhs.angle == rhs.angle && lhs.position == rhs.position
    }
}
