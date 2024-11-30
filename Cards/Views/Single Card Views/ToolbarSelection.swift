//
//  ToolbarSelection.swift
//  Cards
//
//  Created by Tes Essa on 10/17/24.
//

import Foundation
//why is this a swift file, cause it has enums
enum ToolbarSelection: CaseIterable, Identifiable{  //identifiable- [rovide id
    var id: Int {
        hashValue
    } //make hashable enums automatically conform,
    case photoModal, frameModal, stickerModal, textModal //for each button
}
//Instead of a stored property, this var is a computed property. Now, when you create a ToolbarSelection object, each object will have a different ID calculated from the enumeration’s hash value.
