//
//  CardToolbar.swift
//  Cards
//
//  Created by Tes Essa on 10/21/24.
//

import SwiftUI
struct CardToolbar: ViewModifier{
    @EnvironmentObject var store: CardStore
    @Environment(\.dismiss) var dismiss //to dismiss view
    @Binding var currentModal: ToolbarSelection? //not state passed from singlecardview
    @Binding var card: Card
    @State private var stickerImage: UIImage? //from cardmodalview
    @State private var frameIndex: Int? //for shapes
    @State private var textElement = TextElement()  //for text
    func body(content: Content) -> some View {
        content
          .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              menu
            }
            ToolbarItem(placement: .navigationBarTrailing) {
              Button("Done") {
                dismiss()
              }
            }
              ToolbarItem(placement: .navigationBarLeading) {
                let uiImage = UIImage.screenshot(
              card: card,
                  size: Settings.cardSize)
                let image = Image(uiImage: uiImage)
                // Add ShareLink here
                  ShareLink(
                    item: image,
                    preview: SharePreview(
                      "Card",
                      image: image)) {
                        Image(systemName: "square.and.arrow.up")
                  }
              }
            ToolbarItem(placement: .bottomBar) {
              BottomToolbar(
                card: $card,
                modal: $currentModal)
            }
          }
          .sheet(item: $currentModal) { item in
            switch item {
            case .frameModal:
              FrameModal(frameIndex: $frameIndex)
                .onDisappear {
                  if let frameIndex {
                    card.update(
                      store.selectedElement,
                      frameIndex: frameIndex)
                  }
                  frameIndex = nil
                }
            case .stickerModal:
              StickerModal(stickerImage: $stickerImage)
                .onDisappear {
                  if let stickerImage = stickerImage {
                    card.addElement(uiImage: stickerImage)
                  }
                  stickerImage = nil
                }
            case .textModal:
              TextModal(textElement: $textElement)
                .onDisappear {
                  if !textElement.text.isEmpty {
                    card.addElement(text: textElement)
                  }
                  textElement = TextElement()
                }
            default:
              Text(String(describing: item))
            }
          }
      }

      var menu: some View {
        Menu {
          Button {
            if UIPasteboard.general.hasImages {
              if let images = UIPasteboard.general.images {
                for image in images {
                  card.addElement(uiImage: image)
                }
              }
            } else if UIPasteboard.general.hasStrings {
              if let strings = UIPasteboard.general.strings {
                for text in strings {
                  card.addElement(text: TextElement(text: text))
                }
              }
            }
        } label: {
          Label("Paste", systemImage: "doc.on.clipboard")
          }
          .disabled(!UIPasteboard.general.hasImages
            && !UIPasteboard.general.hasStrings)
        } label: {
          Label("Add", systemImage: "ellipsis.circle")
        }
      }
    }
