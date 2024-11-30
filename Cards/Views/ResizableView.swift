//
//  ResizableView.swift
//  Cards
//
//  Created by Tes Essa on 10/19/24.
//

import SwiftUI

struct ResizableView: ViewModifier {
//    private let content = RoundedRectangle(cornerRadius: 30.0)
    @State private var previousOffset: CGSize = .zero
    //holds offset before dragging
//    private let color = Color.red
    @Binding var transform: Transform //make binding so can update view
    @State private var previousRotation: Angle = .zero
    @State private var scale: CGFloat = 1.0
    let viewScale: CGFloat //for sizing in chap 20
    
    var dragGesture: some Gesture {
      DragGesture()
        .onChanged { value in
          transform.offset = value.translation / viewScale + previousOffset
        }
        .onEnded { _ in
          previousOffset = transform.offset
        }  //replace variables
    }

    var rotationGesture: some Gesture {
      RotationGesture()
        .onChanged { rotation in
          transform.rotation += rotation - previousRotation
          previousRotation = rotation
        }
        .onEnded { _ in
          previousRotation = .zero
        }
    }

    var scaleGesture: some Gesture {
      MagnificationGesture()
        .onChanged { scale in
          self.scale = scale
        }
        .onEnded { scale in
          transform.size.width *= scale
          transform.size.height *= scale
          self.scale = 1.0
        }
    }
    func body(content: Content) -> some View {
      content
        .frame(
          width: transform.size.width * viewScale,
          height: transform.size.height * viewScale)
        .rotationEffect(transform.rotation)
        .scaleEffect(scale)
        .offset(transform.offset * viewScale)
        .gesture(dragGesture)
        .gesture(SimultaneousGesture(rotationGesture, scaleGesture))
        .onAppear {
          previousOffset = transform.offset //be on the bottom
        }
    }
  }

//struct ResizableView_Previews: PreviewProvider {
//    static var previews: some View {
//      RoundedRectangle(cornerRadius: 30.0)
//        .foregroundColor(Color.blue)
//        .resizableView(transform: .constant(Transform()))
//  }
//}
struct ResizableView_Previews: PreviewProvider {
  struct ResizableViewPreview: View {
    @State var transform = Transform()
    var body: some View {
      RoundedRectangle(cornerRadius: 30.0)
        .foregroundColor(Color.blue)
        .resizableView(transform: $transform)
    }
  }
  static var previews: some View {
    ResizableViewPreview()
  }
}
extension View {
  func resizableView(
    transform: Binding<Transform>,
    viewScale: CGFloat = 1.0
  ) -> some View {
    modifier(ResizableView(
      transform: transform,
      viewScale: viewScale))
  }
}
