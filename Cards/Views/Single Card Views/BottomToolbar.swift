//
//  BottomToolbar.swift
//  Cards
//
//  Created by Tes Essa on 10/17/24.
//

import SwiftUI
struct ToolbarButton: View{
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let modal: ToolbarSelection
    private let modalButton: [
        ToolbarSelection: (text: String, imageName: String)
    ] = [
    .photoModal: ("Photos", "photo"), .frameModal: ("Frames", "square.on.circle"), .stickerModal: ("Stickers", "heart.circle"), .textModal: ("Text", "textformat")
    ]
    var body: some View{
        if let text = modalButton[modal]?.text,
           let imageName = modalButton[modal]?.imageName {//getting modal
            if verticalSizeClass == .compact{
                compactView(imageName)
            }
            else{
                regularView(imageName, text)
            }
            
        }
        
    }
    func regularView(
      _ imageName: String,
      _ text: String
    ) -> some View {
      VStack(spacing: 2) {
        Image(systemName: imageName)
        Text(text) //shows images and name of modal
      }
      .frame(minWidth: 60)
      .padding(.top, 5)
    }

    func compactView(_ imageName: String) -> some View {
      VStack(spacing: 2) {
        Image(systemName: imageName)  //only shows images
      }
      .frame(minWidth: 60)
      .padding(.top, 5)
    }
  }//each modal uses this view
struct BottomToolbar: View {
    @EnvironmentObject var store: CardStore
    @Binding var card: Card
    @Binding var modal: ToolbarSelection? //for current midal
    var body: some View {
        HStack(alignment: .bottom){ //for alignment
            ForEach(ToolbarSelection.allCases){ selection in //calling it selection
          // dont need  id: \.self b/c already identifiable
                switch selection {
                case .photoModal:
                  Button {
                  } label: {
                    PhotosModal(card: $card)
                  }
                case .frameModal:
                    defaultButton(selection)
                              .disabled(
                                store.selectedElement == nil
                                || !(store.selectedElement is ImageElement))
                
                default:
                    defaultButton(selection)
                }
            } //Because the text label for the button is a custom view, rather than a string, you use the Button(action:label:) initializer
        }
    }
func defaultButton(_ selection: ToolbarSelection) -> some View {
   Button {
     modal = selection
   } label: {
     ToolbarButton(modal: selection)
   }
 }
}
struct BottomToolbar_Previews: PreviewProvider {
    static var previews: some View {
        BottomToolbar(card: .constant(Card()),
            modal: .constant(.stickerModal))
            .padding()
            .environmentObject(CardStore())
    }
}
