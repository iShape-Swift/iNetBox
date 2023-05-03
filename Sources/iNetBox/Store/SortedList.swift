//
//  SortedList.swift
//  
//
//  Created by Nail Sharipov on 06.04.2023.
//

public protocol IdItem {
    var id: Int64 { get }
}

struct SortedList<T: IdItem> {
    
    private var ids: [Int64] = []
    var items: [T] = []
    
    @inlinable
    func index(id: Int64) -> Int {
        ids.findIndex(value: id)
    }
    
    mutating func add(_ item: T) {
        guard !ids.isEmpty else {
            ids.append(item.id)
            items.append(item)
            return
        }
        
        let index = self.ids.findFreeIndex(value: item.id)
        assert(index != -1)
        ids.insert(item.id, at: index)
        items.insert(item, at: index)
    }
    
    mutating func remove(_ item: T) {
        let index = self.ids.findIndex(value: item.id)
        assert(index != -1)
        ids.remove(at: index)
        items.remove(at: index)
    }
    
    mutating func removeAll() {
        ids.removeAll()
        items.removeAll()
    }
}


extension Array where Element == Int64 {
    
    @inlinable
    /// Find index of element. If element is not found return index where it must be
    /// - Parameter value: target element
    /// - Returns: index of element
    func findFreeIndex(value a: Int64) -> Int {
        var left = 0
        var right = count - 1
        
        var j = -1
        var i = right >> 1
        var x = self[i]
        
        while i != j {
            if x > a {
                right = i - 1
            } else if x < a {
                left = i + 1
            } else {
                return -1
            }
            
            j = i
            i = (left + right) / 2
            
            x = self[i]
        }
        
        if x < a {
            i = i + 1
        }
        
        return i
    }
    
    @inlinable
    /// Find index of element. If element is not found return -1
    /// - Parameter value: target element
    /// - Returns: index of element
    func findIndex(value a: Int64) -> Int {
        var left = 0
        var right = count - 1

        var j = -1
        var i = right >> 1
        var x = self[i]
        
        while i != j {
            if x > a {
                right = i - 1
            } else if x < a {
                left = i + 1
            } else {
                return i
            }
            
            j = i
            i = (left + right) / 2

            x = self[i]
        }

        return -1
    }
}
