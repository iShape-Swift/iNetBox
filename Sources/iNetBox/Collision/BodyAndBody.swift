//
//  BodyAndBody.swift
//  
//
//  Created by Nail Sharipov on 06.04.2023.
//

extension World {
    
    mutating func collide(bodyA a: Body, bodyB b: Body) {
        switch a.collider.form {
        case .circle:
            switch b.collider.form {
            case .circle:
                collideCircleAndCircle(a, b)
            case .box:
                collideCircleAndBox(a, b)
            case .convex:
                collideCircleAndCovex(a, b)
            case .complex:
                collideCircleAndComplex(a, b)
            case .empty:
                assertionFailure("body: \(b.id) collider is empty")
            }
        case .box:
            switch b.collider.form {
            case .circle:
                collideCircleAndBox(b, a)
            case .box:
                collideBoxAndBox(a, b)
            case .convex:
                collideBoxAndCovex(a, b)
            case .complex:
                collideBoxAndComplex(a, b)
            case .empty:
                assertionFailure("body: \(b.id) collider is empty")
            }
        case .convex:
            switch b.collider.form {
            case .circle:
                collideCircleAndCovex(b, a)
            case .box:
                collideBoxAndCovex(b, a)
            case .convex:
                collideCovexAndCovex(a, b)
            case .complex:
                collideCovexAndComplex(a, b)
            case .empty:
                assertionFailure("body: \(b.id) collider is empty")
            }
        case .complex:
            switch b.collider.form {
            case .circle:
                collideCircleAndCovex(b, a)
            case .box:
                collideBoxAndCovex(b, a)
            case .convex:
                collideCovexAndComplex(b, a)
            case .complex:
                collideComplexAndComplex(a, b)
            case .empty:
                assertionFailure("body: \(b.id) collider is empty")
            }
        case .empty:
            assertionFailure("body: \(a.id) collider is empty")
            break
        }
    }

    mutating func collide(_ a: Body, _ b: Land) {

    }
    
    
    private mutating func collideCircleAndCircle(_ a: Body, _ b: Body) {
        
    }

    private mutating func collideCircleAndBox(_ a: Body, _ b: Body) {
        assertionFailure("collideCircleAndBox not implemented")
    }

    private mutating func collideCircleAndCovex(_ a: Body, _ b: Body) {
        assertionFailure("collideCircleAndCovex not implemented")
    }

    private mutating func collideCircleAndComplex(_ a: Body, _ b: Body) {
        assertionFailure("collideCircleAndComplex not implemented")
    }
    
    private mutating func collideBoxAndBox(_ a: Body, _ b: Body) {
        assertionFailure("collideBoxAndBox not implemented")
    }
    
    private mutating func collideBoxAndCovex(_ a: Body, _ b: Body) {
        assertionFailure("collideBoxAndCovex not implemented")
    }
    
    private mutating func collideBoxAndComplex(_ a: Body, _ b: Body) {
        assertionFailure("collideBoxAndCovex not implemented")
    }
    
    private mutating func collideCovexAndCovex(_ a: Body, _ b: Body) {
        assertionFailure("collideCovexAndCovex not implemented")
    }
    
    private mutating func collideCovexAndComplex(_ a: Body, _ b: Body) {
        assertionFailure("collideCovexAndComplex not implemented")
    }
    
    private mutating func collideComplexAndComplex(_ a: Body, _ b: Body) {
        assertionFailure("collideComplexAndComplex not implemented")
    }
}
