//
//  ListSelection.swift
//  Cards
//
//  Created by Tes Essa on 11/12/24.
//

import SwiftUI
enum ListState{
    case list, carousel
}
struct ListSelection: View {
    @Binding var listState: ListState //listState holds the current picker selection and you’ll pass this in from CardsListView.
    var body: some View {
      // 1
      Picker(selection: $listState, label: Text("")) {
      // 2
        Image(systemName: "square.grid.2x2.fill")
          .tag(ListState.list)
        Image(systemName: "rectangle.stack.fill")
          .tag(ListState.carousel)
    }
    // 3
      .pickerStyle(.segmented)
      .frame(width: 200)
    }
}

struct ListSelection_Previews: PreviewProvider {
    static var previews: some View {
        ListSelection(listState: .constant(.list)) //default is list
    }
}
