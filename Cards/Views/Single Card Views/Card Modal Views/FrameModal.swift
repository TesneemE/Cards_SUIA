//
//  FrameModal.swift
//  Cards
//
//  Created by Tes Essa on 11/3/24.
//

import SwiftUI

struct FrameModal: View {
  @Environment(\.dismiss) var dismiss
  // 1
  @Binding var frameIndex: Int?
  private let columns = [
    GridItem(.adaptive(minimum: 120), spacing: 10)
  ]
  private let style = StrokeStyle(
    lineWidth: 5,
    lineJoin: .round)
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
      // 2
        ForEach(0..<Shapes.shapes.count, id: \.self) { index in
          Shapes.shapes[index]
          // 3
            .stroke(Color.primary, style: style)
            // 4
            .background(
              Shapes.shapes[index].fill(Color.secondary))
            .frame(width: 100, height: 120)
            .padding()
            // 5
            .onTapGesture {
              frameIndex = index
dismiss() }
}
      } }
          .padding(5)
        }
      }
struct FrameModal_Previews: PreviewProvider {
    static var previews: some View {
        FrameModal(frameIndex: .constant(nil))
    }
}




