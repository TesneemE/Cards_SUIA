//
//  StickerModal.swift
//  Cards
//
//  Created by Tes Essa on 10/29/24.
//

import SwiftUI

struct StickerModal: View {
    @State private var stickerNames: [String] = []
    let columns = [
      GridItem(.adaptive(minimum: 120), spacing: 10)
    ]
    @Binding var stickerImage: UIImage?
    @Environment(\.dismiss) var dismiss
    var body: some View {
       ScrollView {
         LazyVGrid(columns: columns) {
           ForEach(stickerNames, id: \.self) { sticker in
             Image(uiImage: image(from: sticker))
               .resizable()
               .aspectRatio(contentMode: .fit)
               .onTapGesture {
                 stickerImage = image(from: sticker)
                 dismiss()
               }
           }
         }
       }
       .onAppear {
         stickerNames = Self.loadStickers()
       }
     }
    static func loadStickers() -> [String]{
        var themes: [URL] = []
        var stickerNames: [String] = []
        // 1
        let fileManager = FileManager.default
        if let resourcePath = Bundle.main.resourcePath,
        // 2
          let enumerator = fileManager.enumerator(
            at: URL(fileURLWithPath: resourcePath + "/Stickers"),
            includingPropertiesForKeys: nil,
            options: [
              .skipsSubdirectoryDescendants,
              .skipsHiddenFiles
            ]) {
        // 3
              for case let url as URL in enumerator
              where url.hasDirectoryPath {
                themes.append(url)
              }
        }
        for theme in themes {
          if let files = try?
          fileManager.contentsOfDirectory(atPath: theme.path) {
            for file in files {
              stickerNames.append(theme.path + "/" + file)
            }
        } }
        return stickerNames
    }
    func image(from path: String) -> UIImage {
      print("loading:", path)
      return UIImage(named: path)
        ?? UIImage(named: "error-image")
        ?? UIImage()
    }
}
//Going through the code:
//1. Get the full resource path of the app bundle.
//2. Load the UIImage using the full name and path of the sticker and use the uiImage parameter for creating the Image view.

struct StickerModal_Previews: PreviewProvider {
    static var previews: some View {
        StickerModal(stickerImage: .constant(UIImage()))
    }
}
