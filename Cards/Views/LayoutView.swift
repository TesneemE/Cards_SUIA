//
//  LayoutView.swift
//  Cards
//
//  Created by Tes Essa on 11/5/24.
//

import SwiftUI

struct LayoutView: View {
    var body: some View {
        GeometryReader { proxy in
            HStack { //lazyHstack fills whole takes parent vertical, Vstack and Vgrid take horixzotnal
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .background(Color.red)
                Text("Hello World!")
                    .padding()
                    .background(Color.red) //red takes up padding as well
            }
    //        .frame(maxWidth: .infinity)  //extends gray horizontally
//            .background(Color.gray)
            .frame(width: proxy.size.width * 0.8)
            .background(Color.gray)
            .padding(
              .leading, (proxy.size.width - proxy.size.width * 0.8) / 2)
        } //takes up space of both
        .background(Color.yellow)
    }
}

struct LayoutView_Previews: PreviewProvider {
    static var previews: some View {
        LayoutView()
            .previewLayout(.fixed(width: 500, height: 300))
    }
}
