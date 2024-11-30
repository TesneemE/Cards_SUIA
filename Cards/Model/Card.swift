//
//  Card.swift
//  Cards
//
//  Created by Tes Essa on 10/23/24.
//

import SwiftUI
struct Card: Identifiable{
//    let id=UUID()
    var id = UUID()
    var backgroundColor: Color = .yellow
    var elements: [CardElement] = []
    var uiImage: UIImage? //for thumbnail
//    mutating func addElement(uiImage: UIImage) {
//      let element = ImageElement(uiImage: uiImage)
//      elements.append(element)
//    }
    mutating func addElement(uiImage: UIImage, at offset: CGSize = .zero) { //codable
    // 1
      let imageFilename = uiImage.save()
      // 2
     let transform = Transform(offset: offset)
      let element = ImageElement(
        imageFilename: imageFilename, transform: transform, uiImage: uiImage)
      elements.append(element)
        save()
    }
    mutating func addElement(text: TextElement) {
      elements.append(text)
    } //for text
    mutating func addElements(from transfer: [CustomTransfer], at offset: CGSize) {
      for element in transfer {
        if let text = element.text {
          addElement(text: TextElement(text: text))
        } else if let image = element.image {
            addElement(uiImage: image, at: offset)
        }
    } }
    mutating func remove(_ element: CardElement) {
    if let element = element as? ImageElement {
        UIImage.remove(name: element.imageFilename)
      }
      if let index = element.index(in: elements) {
        elements.remove(at: index)
      }
        save()
    }
    mutating func update(_ element: CardElement?, frameIndex: Int) {
      if let element = element as? ImageElement,
        let index = element.index(in: elements) {
          var newElement = element
          newElement.frameIndex = frameIndex
          elements[index] = newElement
    } }
//    func save(){
//        print("Saving Data")
//    }
    func save() {
      do {
    // 1
        let encoder = JSONEncoder()
        // 2
          encoder.outputFormatting = .prettyPrinted //pretty
        let data = try encoder.encode(self)
        // 3
        let filename = "\(id).rwcard"
        let url = URL.documentsDirectory
          .appendingPathComponent(filename)
    // 4
        try data.write(to: url)
      } catch {
        print(error.localizedDescription)
      }
    }
    
}

extension Card: Codable {
  enum CodingKeys: CodingKey {
    case id, backgroundColor, imageElements, textElements
  }

  init(from decoder: Decoder) throws {
    let container = try decoder
      .container(keyedBy: CodingKeys.self)
    let id = try container.decode(String.self, forKey: .id)
    self.id = UUID(uuidString: id) ?? UUID()
    elements += try container.decode(
      [ImageElement].self, forKey: .imageElements)

    // Challenge 2 - load the text elements
    elements += try container.decode([TextElement].self, forKey: .textElements)

    // Challenge 1 - load the background color
    let components = try container.decode([CGFloat].self, forKey: .backgroundColor)
    backgroundColor = Color.color(components: components)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id.uuidString, forKey: .id)
    let imageElements: [ImageElement] =
      elements.compactMap { $0 as? ImageElement }
    try container.encode(imageElements, forKey: .imageElements)

    // Challenge 2 - save the text elements
    let textElements: [TextElement] =
      elements.compactMap { $0 as? TextElement }
    try container.encode(textElements, forKey: .textElements)

    // Challenge 1 - save the background color
    let components = backgroundColor.colorComponents()
    try container.encode(components, forKey: .backgroundColor)
  }
}
    // codable Image
//Here you take in a new UIImage and add a new ImageElement to the card. In the following chapter, you’ll be able to use this method for adding photos too.
