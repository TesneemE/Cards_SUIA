//
//  CardElement.swift
//  Cards
//
//  Created by Tes Essa on 10/23/24.
//

import SwiftUI
protocol CardElement{
    var id: UUID { get }
    var transform: Transform { get set }
}
extension CardElement {
  func index(in array: [CardElement]) -> Int? {
    array.firstIndex { $0.id == id }
  }
} //for let index = card.elements.firstIndex { $0.id == element.id } for index of element
struct ImageElement: CardElement {
  let id = UUID()
  var frameIndex: Int?
  var imageFilename: String?
  var transform = Transform()
    var uiImage: UIImage?
    var image: Image {
      Image(
        uiImage: uiImage ??
          UIImage(named: "error-image") ??
          UIImage())
    }
}
extension ImageElement: Codable {
    enum CodingKeys: CodingKey {
      case transform, imageFilename, frameIndex
    }
    init(from decoder: Decoder) throws {
      let container = try decoder
        .container(keyedBy: CodingKeys.self)
      // 1
      transform = try container
        .decode(Transform.self, forKey: .transform)
      frameIndex = try container
        .decodeIfPresent(Int.self, forKey: .frameIndex)
    // 2
      imageFilename = try container.decodeIfPresent(
        String.self,
        forKey: .imageFilename)
    // 3
      if let imageFilename {
        uiImage = UIImage.load(uuidString: imageFilename)
    } else { // 4
        uiImage = UIImage.errorImage
        }
      }
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(transform, forKey: .transform)
      try container.encode(frameIndex, forKey: .frameIndex)
      try container.encode(imageFilename, forKey: .imageFilename)
    }
}
  

 
struct TextElement: CardElement {
  let id = UUID()
  var transform = Transform()
  var text = ""
  var textColor = Color.black
  var textFont = "Gill Sans"
}
extension TextElement: Codable { //make codable and accessible to cardtoolbarswift
  enum CodingKeys: CodingKey {
    case transform, text, textColor, textFont
  }

  init(from decoder: Decoder) throws {
    let container = try decoder
      .container(keyedBy: CodingKeys.self)
    transform = try container
      .decode(Transform.self, forKey: .transform)
    text = try container
      .decode(String.self, forKey: .text)
    let components = try container.decode([CGFloat].self, forKey: .textColor)
    textColor = Color.color(components: components)
    textFont = try container
      .decode(String.self, forKey: .textFont)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(transform, forKey: .transform)
    try container.encode(text, forKey: .text)
    let components = textColor.colorComponents()
    try container.encode(components, forKey: .textColor)
    try container.encode(textFont, forKey: .textFont)
  }
}
// 1
//diff betwen let and var?

//With protocols, you future-proof the design. If you later want to add a new card element that is just a solid color, you can simply create a new structure ColorElement that conforms to CardElement.
