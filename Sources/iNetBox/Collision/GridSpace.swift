//
//  GridSpace.swift
//  
//
//  Created by Nail Sharipov on 17.04.2023.
//

import iSpace

typealias BitMask = UInt64

extension BitMask {
    
    init(id: Int) {
        self = 1 << id
    }
    
    mutating func add(id: Int) {
        self = self | (1 << id)
    }
    
    mutating func union(_ m: BitMask) {
        self = self | m
    }
    
    mutating func next() -> Int {
        let id = self.trailingZeroBitCount
        self = self - (1 << id)
        return id
    }
}

private struct IndexBoundary {
    let pMin: Index2d
    let pMax: Index2d
    
    @inlinable
    var isSimple: Bool {
        pMin.x == pMax.x && pMin.y == pMax.y
    }
}

private struct Index2d {
    let x: Int
    let y: Int
}

struct GridSpace {
    
    var cells: [BitMask]
    var base: Boundary
    var scale: FixVec
    let size: Int
    let splitRatio: Int

    @inlinable
    func index(x: Int, y: Int) -> Int {
        x << splitRatio + y
    }
    
    @inlinable
    subscript (x: Int, y: Int) -> BitMask {
        cells[index(x: x, y: y)]
    }
    
    init(splitRatio: Int = 4) {
        self.splitRatio = splitRatio
        self.size = 1 << splitRatio
        self.scale = .zero
        self.base = .zero
        self.cells = [UInt64](repeating: .zero, count: size << splitRatio)
    }
    
    mutating func set(boxes: [Boundary]) {
        self.base = Boundary(boxes: boxes)

        let ds = base.pMax - base.pMin
        let sx = size.fix.div(ds.x)
        let sy = size.fix.div(ds.y)
        
        self.scale = FixVec(sx, sy)
        
        var i = 0
        while i < cells.count {
            cells[i] = 0
            i += 1
        }

        i = 0
        while i < boxes.count {
            let s = BitMask(id: i)
            
            let j = boxes[i].index(base: base, scale: scale, size: size)

            if j.isSimple {
                let a0 = index(x: j.pMin.x, y: j.pMin.y)
                cells[a0].union(s)
            } else {
                var x = j.pMin.x
                while x <= j.pMax.x {
                    var y = j.pMin.y
                    while y <= j.pMax.y {
                        let ai = index(x: x, y: y)
                        cells[ai].union(s)
                        y += 1
                    }
                    x += 1
                }
            }
            
            i += 1
        }
        
    }

    func collide(boundary: Boundary) -> BitMask {
        guard base.isCollide(box: boundary) else {
            return 0
        }
        
        let j = boundary.index(base: base, scale: scale, size: size)
        
        var result: BitMask = 0
        
        if j.isSimple {
            let i = j.pMin.x << splitRatio + j.pMin.y
            result = cells[i]
        } else {
            var x = j.pMin.x
            while x <= j.pMax.x {
                var y = j.pMin.y
                while y <= j.pMax.y {
                    let i = x << splitRatio + y
                    result.union(cells[i])
                    y += 1
                }
                x += 1
            }
        }
        
        return result
    }
    
}

private extension Boundary {
    
    func index(base: Boundary, scale: FixVec, size: Int) -> IndexBoundary {
        let x0 = (self.pMin.x - base.pMin.x).mul(scale.x).int
        let y0 = (self.pMin.y - base.pMin.y).mul(scale.y).int
        let x1 = (self.pMax.x - base.pMin.x).mul(scale.x).int
        let y1 = (self.pMax.y - base.pMin.y).mul(scale.y).int
        
        let xMin = max(0, x0)
        let yMin = max(0, y0)
        let xMax = min(size - 1, x1)
        let yMax = min(size - 1, y1)
        
        return IndexBoundary(pMin: Index2d(x: xMin, y: yMin), pMax: Index2d(x: xMax, y: yMax))
    }

}
