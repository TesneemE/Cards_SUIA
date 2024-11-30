//
//  CardStore.swift
//  Cards
//
//  Created by Tes Essa on 10/23/24.
//

import SwiftUI
class CardStore: ObservableObject{ //OO means needs to be class, change to properties means change to views
    @Published var cards: [Card] = [] //single source of truth is cards
    @Published var selectedElement: CardElement?
    func addCard() -> Card {
      let card = Card(backgroundColor: Color.random())
      cards.append(card)
      card.save()
      return card
    } //add card no default data
    init(defaultData: Bool = false){
//        if defaultData{
//            cards = initialCards //from PreviewData
//        }
        cards = defaultData ? initialCards : load()
    }
    func index(for card: Card) -> Int? {
        cards.firstIndex{$0.id == card.id}  
    }  //This finds the first card in the array that matches the selected card’s id and returns the array index, if there is one.
//    func remove(_ card: Card) { //for card in array cards of Card
//        if let index = index(for: card) {//if index in in index of Card
//        cards.remove(at: index)  //remove Card at index from cards
//      }
//    }

    func remove(_ card: Card) { //also removes from documents folder for saving
      guard let index = index(for: card) else { return }
      // remove the elements
      // remove(_:) removes the element images on disk
      for element in cards[index].elements {
        cards[index].remove(element)
      }
      // remove the card image (if there is one)
      UIImage.remove(name: card.id.uuidString)
      // remove the card details
      let path = URL.documentsDirectory
        .appendingPathComponent("\(card.id.uuidString).rwcard")
      try? FileManager.default.removeItem(at: path)
      cards.remove(at: index)
    }
}

//composition is like friend= has a relationship not inheritance
extension CardStore {
    // 1
    func load() -> [Card] {
        var cards: [Card] = []
        // 2
        let path = URL.documentsDirectory.path
        guard
            let enumerator = FileManager.default
                .enumerator(atPath: path),
            let files = enumerator.allObjects as? [String]
        else { return cards }
        // 3
        let cardFiles = files.filter { $0.contains(".rwcard") }
        for cardFile in cardFiles {
            do { // 4
                let path = path + "/" + cardFile
                let data =
                try Data(contentsOf: URL(fileURLWithPath: path))
                // 5
                let decoder = JSONDecoder()
                let card = try decoder.decode(Card.self, from: data)
                cards.append(card)
            } catch {
                print("Error: ", error.localizedDescription)
            }
        }
        return cards
    }
}
