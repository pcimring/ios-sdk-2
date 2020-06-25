//
//  ItemStore.swift
//  Homepwner
//
//  Created by Peter Cimring on 16/06/2020.
//  Copyright © 2020 com.pcimring. All rights reserved.
//

import UIKit
class ItemStore {
    var allItems = [NewsItem]()
    
    @discardableResult func createItem() -> NewsItem {
        let newItem = NewsItem(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    init() {
        for _ in 0..<10 {
            createItem()
        }
    }
}
