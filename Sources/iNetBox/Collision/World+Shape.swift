//
//  World+Shape.swift
//  
//
//  Created by Nail Sharipov on 10.04.2023.
//

import iSpace

extension World {
    
    func collide(shapeA a: Shape, shapeB b: Shape) -> Contact {
        guard a.boundry.isCollide(box: b.boundry) else {
            return .outside
        }
        
        switch a.collider.form {
        case .circle:
            switch b.collider.form {
            case .circle:
                return collide(circle: a, circle: b)
            case .convex:
                return collide(convex: b, circle: a).swapNormal()
            case .complex:
                return collide(complex: b, circle: a).swapNormal()
            case .empty:
                return .outside
            }
        case .convex:
            switch b.collider.form {
            case .circle:
                return collide(convex: a, circle: b)
            case .convex:
                return .outside
            case .complex:
                return .outside
            case .empty:
                return .outside
            }
        case .complex:
            switch b.collider.form {
            case .circle:
                return collide(complex: a, circle: b)
            case .convex:
                return .outside
            case .complex:
                return .outside
            case .empty:
                return .outside
            }
        case .empty:
            return .outside
        }
    }
    

    private func collide(circle a: Shape, circle b: Shape) -> Contact {
        let circleA = CircleCollider(center: a.transform.position, radius: a.collider.data)
        let circleB = CircleCollider(center: b.transform.position, radius: b.collider.data)
        
        return circleA.collide(circle: circleB)
    }

    private func collide(convex a: Shape, circle b: Shape) -> Contact {
        guard let convexA = self.convexColliders[a.collider.data] else {
            return .outside
        }
        
        // convert to local coordinate
        let pos = a.transform.toLocal(point: b.transform.position)
        let circleB = CircleCollider(center: pos, radius: b.collider.data)
        
        let contact = convexA.collide(circle: circleB)

        return a.transform.toWorld(contact: contact)
    }
    
    private func collide(complex a: Shape, circle b: Shape) -> Contact {
        return .outside
    }
    
}
