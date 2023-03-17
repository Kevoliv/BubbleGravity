//
//  BubbleView.swift
//  BubbleGravity
//
//  Created by Kevin Oliveira Paiva on 17.03.23.
//
import SwiftUI

//struct BubbleView: View {
//    @Binding var position: CGPoint
//    var stopPosition: CGPoint
//
//    var body: some View {
//        GeometryReader { geometry in
//            Circle()
//                .fill(Color.random)
//                .frame(width: 40, height: 40)
//                .position(position)
//                .onChange(of: geometry.frame(in: .global).origin) { newValue in
//                    if distance(newValue, stopPosition) <= 60 {
//                        position = newValue
//                    }
//                }
//        }
//    }
//
//    private func distance(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
//        let xDistance = point1.x - point2.x
//        let yDistance = point1.y - point2.y
//        return hypot(xDistance, yDistance)
//    }
//}

struct BubbleView: View {
    @Binding var position: CGPoint

    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 40, height: 40)
            .position(position)
    }
}



extension Color {
    static var random: Color {
        return Color(red: Double.random(in: 0...1),
                     green: Double.random(in: 0...1),
                     blue: Double.random(in: 0...1))
    }
}

