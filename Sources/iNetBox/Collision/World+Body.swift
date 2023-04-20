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

        let cTrm = ContactTransform(normal: contact.normalA, pos: contact.point)
        let v0 = cTrm.toLocal(vector: a.velocity.linear)
        guard v0.y < 0 else {
            return
        }

        let kb = max(a.material.bounce, b.material.bounce)
        let w = a.velocity.angular.mul(contact.radiusA)

        let vx = v0.x - w
        let vy = -v0.y.mul(kb)

        let v1 = FixVec(vx, vy)

        let vm = cTrm.toWorld(vector: v1)

        let m = a.velocity.linear.mirror(contact.normalB)
        
        print("nol \(contact.normalA)")
        print("vel \(a.velocity.linear)")
        
        print("old \(vm)")
        print("new \(m)")
        print("nol vec \(contact.normalA.float)")
        print("vel vec \(a.velocity.linear.float)")
        print("mir vec \(a.velocity.linear.float.mirror(contact.normalA.float))")
        
        var new_a = a
        new_a.velocity = Velocity(linear: vm, angular: a.velocity.angular)

        switch a.type {
        case .player:
            playerList.items[index] = new_a
        case .bullet:
            bulletList.items[index] = new_a
        }
    }

}
