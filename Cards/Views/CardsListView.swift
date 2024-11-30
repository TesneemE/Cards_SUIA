//
//  CardsListView.swift
//  Cards
//
//  Created by Tes Essa on 10/17/24.
//

import SwiftUI

struct CardsListView: View {
//    @State private var isPresented = false //don't need card is from data store
    @State private var listState = ListState.list //PICKER
    @EnvironmentObject var store: CardStore
    @Environment(\.scenePhase) private var scenePhase //to save when close
    @State private var selectedCard: Card?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass //for thumnbnail size
    var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: thumbnailSize.width))
        ] //returns an array of GridItem — in this case, with one element — you can use this to tell the LazyVGrid the size and position of each row
    }
    var thumbnailSize: CGSize {
      var scale: CGFloat = 1
      if verticalSizeClass == .regular,
        horizontalSizeClass == .regular {
    scale = 1.5 }
      return Settings.thumbnailSize * scale
    }
    
    var createButton: some View {
    // 1
        Button {
          selectedCard = store.addCard()
        } label: {
          Label("Create New", systemImage: "plus")
            .frame(maxWidth: .infinity)
        }
      .font(.system(size: 16, weight: .bold))
    // 2
      .frame(maxWidth: .infinity)
      .padding([.top, .bottom], 10)
    // 3
      .background(Color("barColor"))
      .accentColor(.white)
    }
    
    var initialView: some View { //to add card when empty
      VStack {
        Spacer()
          let card = Card(
            backgroundColor: Color(uiColor: .systemBackground))
        ZStack {
          CardThumbnail(card: card)
          Image(systemName: "plus.circle.fill")
            .font(.largeTitle)
        }
        .frame(
          width: thumbnailSize.width * 1.2,
          height: thumbnailSize.height * 1.2)
        .onTapGesture {
          selectedCard = store.addCard()
        }
    Spacer() }
    }
    var body: some View {
        VStack {
            ListSelection(listState: $listState)
            Group {
              if store.cards.isEmpty {
                initialView
              } else {
//            list
                  Group {
                    switch listState {
                    case .list:
                      list
                    case .carousel:
                      Carousel(selectedCard: $selectedCard)
                    }
                  } //FOR PICKER
                  
              }
            }
                .fullScreenCover(item: $selectedCard) { card in
                    if let index = store.index(for: card) {
                      SingleCardView(card: $store.cards[index])
                            .onChange(of: scenePhase){ newScenePhase in
                                if newScenePhase == .inactive{
                                    store.cards[index].save()
                                }
                            }
                    } else {
                      fatalError("Unable to locate selected card")
                    }
            }
//            Button("Add") {
//              selectedCard = store.addCard()
//            } //to add card
            createButton
        }
        .background(
          Color("background")
            .ignoresSafeArea()) //y using default parameters for ignoresSafeArea(_:edges:), you ensure the background covers all the screen.
    }

    var list: some View{ //this is how you make a property
        //gets rid of scrollbar
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 30) { //vertical spacing 30 points flex grid //makes whole background red
            ForEach(store.cards) { card in
              CardThumbnail(card: card)
                    .frame(
                      width: thumbnailSize.width,
                      height: thumbnailSize.height)
                .contextMenu {
                  Button(role: .destructive) {
                    store.remove(card)
                  } label: {
                    Label("Delete", systemImage: "trash")
                  }
                }
                .onTapGesture {
                  selectedCard = card
                }
            }
          }
        }
        .padding(.top, 20)
      }
    }
//creates 10 rectangular boxes you can scroll, want to style down by refactoring view to cardThumbnail by extracting it

struct CardsListView_Previews: PreviewProvider {
    static var previews: some View {
        CardsListView()
            .environmentObject(CardStore(defaultData: true)) //preview instantiates it
    }
}


