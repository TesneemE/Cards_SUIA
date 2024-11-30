//
//  CardDetailView.swift
//  Cards
//
//  Created by Tes Essa on 10/23/24.
//

import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject var store: CardStore
    @Binding var card: Card
    var viewScale: CGFloat = 1 //for landscape
    var proxy: GeometryProxy? //from Single Card
    func isSelected(_ element: CardElement) -> Bool {
        store.selectedElement?.id == element.id
    }
    var body: some View {
        ZStack {
          card.backgroundColor
            .onTapGesture {
              store.selectedElement = nil
            }
          ForEach($card.elements, id: \.id) { $element in
            CardElementView(element: element)
              .overlay(
                element: element,
                isSelected: isSelected(element))
              .elementContextMenu(
                card: $card,
                element: $element)
              .resizableView(
                transform: $element.transform,
                viewScale: viewScale)
              .frame(
                width: element.transform.size.width,
                height: element.transform.size.height)
              .onTapGesture {
                store.selectedElement = element
              }
          }
        }
        .onDisappear {
          store.selectedElement = nil
        }
        .dropDestination(for: CustomTransfer.self) { items, location in
          let offset = Settings.calculateDropOffset(
            proxy: proxy,
            location: location)
          Task {
            card.addElements(from: items, at: offset)
          }
          return !items.isEmpty
        }
      }
    }
//When the user taps Done, CardDetailView disappears and performs this closure.
    
    struct CardDetailView_Previews: PreviewProvider {
        struct CardDetailPreview: View {
            @EnvironmentObject var store: CardStore
            var body: some View {
                CardDetailView(card: $store.cards[0])
            }
        } //allows changes made to position to save to data store
        static var previews: some View {
            CardDetailPreview()
                .environmentObject(CardStore(defaultData: true))
        }
    }
    
    //1. Add a reference to the CardStore environment object and a Card binding.
    //2. Use the card’s background color and put it inside a ZStack.
    //3. Pass a constant binding to CardDetailView and an instance of CardStore using environmentObject(_:).
    //determine if selected
    private extension View {
        @ViewBuilder
        func overlay(
            element: CardElement,
            isSelected: Bool
        ) -> some View {
            if isSelected,
               let element = element as? ImageElement,
               let frameIndex = element.frameIndex {
                let shape = Shapes.shapes[frameIndex]
                self.overlay(shape
                    .stroke(lineWidth: Settings.borderWidth)
                    .foregroundColor(Settings.borderColor))
            } else {
                self
                    .border(
                        Settings.borderColor,
                        width: isSelected ? Settings.borderWidth : 0)
            }
        }
    }

