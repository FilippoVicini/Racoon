//
//  Item.swift
//  Racoon
//
//  Created by Filippo Vicini on 20/09/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
