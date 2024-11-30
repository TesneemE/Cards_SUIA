//
//  Transform.swift
//  Cards
//
//  Created by Tes Essa on 10/21/24.
//

import SwiftUI
struct Transform {
    var size = CGSize(
      width: Settings.defaultElementSize.width,
      height: Settings.defaultElementSize.height) //use settings
  var rotation: Angle = .zero
  var offset: CGSize = .zero
}
extension Transform: Codable {}
