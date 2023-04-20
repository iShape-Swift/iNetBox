//
//  BodyAndBody.swift
//  
//
//  Created by Nail Sharipov on 06.04.2023.
//

import iSpace

extension World {

    mutating func collide(index: Int, _ a: Body, _ b: Land) {
        let contact = collide(shapeA: a.shape, shapeB: b.shape)
        guard contact.type != .outside else { return }

        let vA = a.velocity.linear
        let normal = contact.normalA
        
        let dN = vA.dotProduct(normal)
        
        guard dN < 0 else {
            return
        }

        let ortho = FixVec(normal.y, -normal.x)

        let dO = vA.dotProduct(ortho)
        
        let vN = normal * dN
        let vO = ortho * dO

//        let kb = max(a.material.bounce, b.material.bounce)
        
        let new_v = vO - vN
        var new_a = a
        new_a.velocity = Velocity(linear: new_v, angular: a.velocity.angular)

        switch a.type {
        case .player:
            playerList.items[index] = new_a
        case .bullet:
            bulletList.items[index] = new_a
        }
    }

}
