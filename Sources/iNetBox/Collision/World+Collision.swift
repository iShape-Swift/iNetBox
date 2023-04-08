//
//  CollisionSolver.swift
//  
//
//  Created by Nail Sharipov on 07.04.2023.
//

extension World {
    
    func collide(_ a: Shape, _ b: Shape) -> CollisionResult {
        switch a.collider.form {
        case .circle:
            switch b.collider.form {
            case .circle:
                return collideCircleAndCircle(a, b)
            case .box:
                return collideCircleAndBox(a, b)
            case .convex:
                return collideCircleAndCovex(a, b)
            case .complex:
                return collideCircleAndComplex(a, b)
            case .empty:
                assertionFailure("b.collider is empty")
                return .empty
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
                assertionFailure("b.collider is empty")
                return .empty
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
                assertionFailure("b.collider is empty")
                return .empty
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
                assertionFailure("b.collider is empty")
                return .empty
            }
        case .empty:
            assertionFailure("a.collider is empty")
            return .empty
        }
        
        return .empty
    }
    
    private func collideCircleAndCircle(_ a: Shape, _ b: Shape) -> CollisionResult {
        let rA = a.collider.data
        let rB = b.collider.data
        
        let sqrA = rA * rA
        let sqrB = rB * rB
        let sqrD = a.pos.sqrDistance(b.pos)
        
        guard sqrA + sqrB <= sqrD else {
            return .empty
        }
        
        
        
        return .empty
    }

    private func collideCircleAndBox(_ a: Shape, _ b: Shape) -> CollisionResult {
        assertionFailure("collideCircleAndBox not implemented")
        return .empty
    }

    private func collideCircleAndCovex(_ a: Shape, _ b: Shape) -> CollisionResult {
        assertionFailure("collideCircleAndCovex not implemented")
        return .empty
    }

    private func collideCircleAndComplex(_ a: Shape, _ b: Shape) -> CollisionResult {
        assertionFailure("collideCircleAndComplex not implemented")
        return .empty
    }
    
    private func collideBoxAndBox(_ a: Shape, _ b: Shape) -> CollisionResult {
        assertionFailure("collideBoxAndBox not implemented")
        return .empty
    }
    
    private func collideBoxAndCovex(_ a: Shape, _ b: Shape) -> CollisionResult {
        assertionFailure("collideBoxAndCovex not implemented")
        return .empty
    }
    
    private func collideBoxAndComplex(_ a: Shape, _ b: Shape) -> CollisionResult {
        assertionFailure("collideBoxAndCovex not implemented")
        return .empty
    }
    
    private func collideCovexAndCovex(_ a: Shape, _ b: Shape) -> CollisionResult {
        assertionFailure("collideCovexAndCovex not implemented")
        return .empty
    }
    
    private func collideCovexAndComplex(_ a: Shape, _ b: Shape) -> CollisionResult {
        assertionFailure("collideCovexAndComplex not implemented")
        return .empty
    }
    
    private func collideComplexAndComplex(_ a: Shape, _ b: Shape) -> CollisionResult {
        assertionFailure("collideComplexAndComplex not implemented")
        return .empty
    }
}
