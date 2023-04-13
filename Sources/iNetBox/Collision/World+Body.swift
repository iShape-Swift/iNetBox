//
//  BodyAndBody.swift
//  
//
//  Created by Nail Sharipov on 06.04.2023.
//

import iSpace

extension World {
    
    mutating func collide(indexA: Int, _ a: Body, indexB: Int, _ b: Body) {
        
    }

    mutating func collide(index: Int, _ a: Body, _ b: Land) {
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
