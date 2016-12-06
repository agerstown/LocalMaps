//
//  Extensions.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 3/31/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

extension RangeReplaceableCollection where Iterator.Element : Equatable {
        
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
}

extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        
        var isGreater = false
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        return isGreater
    }
}

