//
//  BubbleView.swift
//  BubbleGravity
//
//  Created by Kevin Oliveira Paiva on 17.03.23.
//
import SwiftUI



struct BubbleView: View {
    @Binding var position: CGPoint
    var size: CGFloat // Add size property

    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: size, height: size) // Use size property here
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

