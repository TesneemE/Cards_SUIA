//
//  AppLoadingView.swift
//  Cards
//
//  Created by Tes Essa on 11/10/24.
//

import SwiftUI

struct AppLoadingView: View {
    @State private var showSplash = true
    var body: some View {
      if showSplash {
        SplashScreen()
          .ignoresSafeArea()
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                showSplash = false
              }
          } }
    } else {
        CardsListView()
            .transition(.scale(scale: 0, anchor: .top))
      }
    }
}

struct AppLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        AppLoadingView()
            .environmentObject(CardStore(defaultData: true)) //so app still works in live preview
    }
}
