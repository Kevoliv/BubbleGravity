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


struct PlusButton: View {
    var action: () -> Void
    var diameter: CGFloat
    var bubbleSize: CGFloat // Add bubble size property

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: diameter / 2, weight: .bold))
                .foregroundColor(.white)
                .frame(width: diameter, height: diameter)
                .background(Color.blue)
                .cornerRadius(diameter / 2)
        }
        .frame(width: diameter, height: diameter)
        .background(Color.blue)
        .cornerRadius(diameter / 2)
        .contentShape(Circle()) // Move the contentShape here
    }
}







struct ContentView: View {
    @StateObject private var viewModel = BubbleViewModel()
    @State private var center: CGPoint?
    @State private var dragState = CGSize.zero

    func calculatePlusButtonSize(_ value: DragGesture.Value) -> CGFloat {
        let centerPosition = center ?? CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        let distance = sqrt(pow(value.location.x - centerPosition.x, 2) + pow(value.location.y - centerPosition.y, 2))
        
        let dragSizeFactor: CGFloat = 0.3
        let size = max(viewModel.minBubbleSize, viewModel.buttonDiameter + distance * dragSizeFactor)
        return size
    }

    // Add the createBubble function here
    func createBubble(_ value: DragGesture.Value, isEnded: Bool = false) {
        if viewModel.canCreateBubble() {
            let centerPosition = center ?? CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            let position = centerPosition
            let distance = sqrt(pow(value.location.x - centerPosition.x, 2) + pow(value.location.y - centerPosition.y, 2))
                    
            
            let dragSizeFactor: CGFloat = 0.15
            let size = max(viewModel.minBubbleSize, viewModel.buttonDiameter + distance * dragSizeFactor)

            viewModel.addBubble(at: position, size: size)
        }

        if isEnded {
            dragState = .zero
        }
    }
    
    // Add the createDefaultBubble function here
        func createDefaultBubble() {
            if viewModel.canCreateBubble() {
                let centerPosition = center ?? CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                let position = centerPosition
                let size = viewModel.minBubbleSize
                viewModel.addBubble(at: position, size: size)
            }
        }



    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                ForEach(viewModel.bubbles.indices, id: \.self) { index in
                    BubbleView(position: viewModel.positionBinding(for: index), size: viewModel.bubbles[index].size)
                }

                PlusButton(action: {
                                    createDefaultBubble()
                                    print("Create")
                                }, diameter: max(viewModel.minBubbleSize, viewModel.buttonDiameter + dragState.width), bubbleSize: max(viewModel.minBubbleSize, viewModel.buttonDiameter + dragState.width)) // Pass bubble size
                .highPriorityGesture(
                    DragGesture(minimumDistance: 0.5) // Set minimumDistance to 0
                                        .onChanged { value in
                                            dragState = value.translation
                                            
                                        }
                                        .onEnded { value in
                                            createBubble(value, isEnded: true)
                                            
                                            print("DRAG")
                                        }
                                )
                                .position(geometry.size.center)
                                .contentShape(Circle())
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
