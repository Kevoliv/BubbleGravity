//
//  ContentView.swift
//  BubbleGravity
//
//  Created by Kevin Oliveira Paiva on 17.03.23.
//

import SwiftUI

struct ButtonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: rect.center, radius: rect.width / 2, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
        return path
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
//struct PlusButton: View {
//    var action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Image(systemName: "plus")
//                .font(.system(size: 30, weight: .bold))
//                .foregroundColor(.white)
//                .frame(width: 60.0, height: 60)
//                .background(Color.blue)
//                .cornerRadius(30)
//        }
//    }
//}

struct PlusButton: View {
    var action: () -> Void
    var diameter: CGFloat

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: diameter / 2, weight: .bold))
                .foregroundColor(.white)
                .frame(width: diameter, height: diameter)
                .background(Color.blue)
                .cornerRadius(diameter / 2)
        }
    }
}



struct ContentView: View {
    @StateObject private var viewModel = BubbleViewModel()
    @State private var center: CGPoint?

    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
//IT WORKS
//        var body: some View {
//            GeometryReader { geometry in
//                ZStack {
//                    ForEach(viewModel.bubbles.indices, id: \.self) { index in
//                        BubbleView(position: viewModel.positionBinding(for: index))
//                    }
//
//                    PlusButton {
//                        let position = geometry.size.center
//                        viewModel.addBubble(at: position)
//                    }
//                    .position(geometry.size.center)
//                }
//                .onAppear {
//                     viewModel.setCenter(geometry.size.center)
//                    let circle = Circle().path(in: CGRect(x: geometry.size.width / 2 - 65, y: geometry.size.height / 2 - 65, width: 130, height: 130))
//                    viewModel.setPath(circle)
//                }
//                .onReceive(timer) { _ in
//                    viewModel.applyGravity(to: geometry.size.center)
//                }
//            }
//        }
    
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    ForEach(viewModel.bubbles.indices, id: \.self) { index in
                        BubbleView(position: viewModel.positionBinding(for: index))
                    }

                    PlusButton(action: {
                        let position = center ?? geometry.size.center
                        viewModel.addBubble(at: position)
                    }, diameter: 70)

                    .position(geometry.size.center)
                }
                .onAppear {
                    viewModel.setCenter(geometry.size.center)
                    let circle = Circle().path(in: CGRect(x: geometry.size.width / 2 - 65, y: geometry.size.height / 2 - 65, width: 130, height: 130))
                    viewModel.setPath(circle)
                    viewModel.buttonDiameter = 80
                }
                .onReceive(timer) { _ in
                    viewModel.applyGravity(to: geometry.size.center)
                }
            }
        }
}

extension CGSize {
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
