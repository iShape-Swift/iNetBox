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
        let aNy = contact.normalA
        
        let aPy = vA.dotProduct(aNy)
        
        guard aPy < 0 else {
            return
        }

        let aNx = FixVec(aNy.y, -aNy.x)

        let aPx = vA.dotProduct(aNx)
        
        let vNy = aNy * aPy
        let vNx = aNx * aPx

        let kb = max(a.material.bounce, b.material.bounce)
        
        let newVa = vNx - kb * vNy
        var new_a = a
        new_a.velocity = Velocity(linear: newVa, angular: a.velocity.angular)

        switch a.type {
        case .player:
            playerList.items[index] = new_a
        case .bullet:
            bulletList.items[index] = new_a
        }
    }

}
