//
//  File.swift
//  
//
//  Created by Nail Sharipov on 13.04.2023.
//

import simd

typealias Vec2 = simd_float2

extension Vec2 {
    
    static let zero = Vec2(0, 0)

    var sqrLength: Float {
        simd_length_squared(self)
    }
    
    var length: Float {
        simd_length(self)
    }
    
    var normalize: Vec2 {
        simd_normalize(self)
    }
    
    static func +(left: Vec2, right: Vec2) -> Vec2 {
        Vec2(left.x + right.x, left.y + right.y)
    }

    static func -(left: Vec2, right: Vec2) -> Vec2 {
        Vec2(left.x - right.x, left.y - right.y)
    }

    func dotProduct(_ v: Vec2) -> Float {
        simd_dot(self, v)
    }

    func crossProduct(_ v: Vec2) -> Float {
        x * v.y - y * v.x
    }
}

class Solver {

    
    struct Velocity {
        
        let linear: Vec2
        let angular: Float

        init(linear: FixVec, angular: FixFloat = 0) {
            self.linear = linear
            self.angular = angular
        }
    }
    
    struct Body {

        public internal (set) var shape: Shape = .empty
        public internal (set) var mass: Float
        public internal (set) var velocity: Velocity = .zero
        public internal (set) var material: Material = .normal
        
        public init(id: Int64, type: BodyType, mass: FixFloat) {
            self.id = id
            self.type = type
            self.mass = mass
        }
        
    }
    
    
    func collide(a: Body, _ b: Land) {
        let contact = collide(shapeA: a.shape, shapeB: b.shape)
        guard contact.type != .outside else { return }

        let cTrm = ContactTransform(normal: contact.normalA, pos: contact.point)
        let v0 = cTrm.toLocal(vector: a.velocity.linear)
        guard v0.y < 0 else {
            return
        }
        
        var new_a = a

        let v1 = FixVec(v0.x, -v0.y)
        
        let vw = cTrm.toWorld(vector: v1)
        new_a.velocity = Velocity(linear: vw, angular: a.velocity.angular)

        switch a.type {
        case .player:
            playerList.items[index] = new_a
        case .bullet:
            bulletList.items[index] = new_a
        }
    }
    
}
