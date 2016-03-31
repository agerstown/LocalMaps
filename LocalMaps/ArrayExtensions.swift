//
//  ArrayExtensions.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 3/31/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
        
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
}

