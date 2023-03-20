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

extension CGPoint {
    func angle(to point: CGPoint) -> CGFloat {
        let deltaX = point.x - x
        let deltaY = point.y - y
        return atan2(deltaY, deltaX)
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
    @State private var plusButtonSize: CGFloat = 0
    @State private var previewBubbleSize: CGFloat = 0
    let centerPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)

    func calculatePreviewBubbleSize(geometry: GeometryProxy, _ value: DragGesture.Value) -> CGFloat {
//        let centerPosition = geometry.size.center
//        let distance = centerPosition.distance(to: value.location)
        let origin = CGPoint(x:0, y:0)
        let distance = origin.distance(to: value.location)*2
        let size = min(max(viewModel.minBubbleSize, distance), viewModel.maxBubbleSize) // Limit the size to maxBubbleSize
            return size
    }



    func createBubble(_ value: DragGesture.Value, isEnded: Bool = false) {
        if viewModel.canCreateBubble() {
//            let position = centerPosition // Use centerPosition as the position for the bubble
            let origin = CGPoint(x:0, y:0)
            let distance = origin.distance(to: value.location)*2
            let size = min(max(viewModel.minBubbleSize, distance), viewModel.maxBubbleSize) // Limit the size to maxBubbleSize
            viewModel.addBubble(size: size) // Add this line to create the bubble
               
        }

        if isEnded {
            dragState = .zero
        } else {
            dragState = CGSize(width: value.translation.width, height: value.translation.height)
        }
    }




    
    // Add the createDefaultBubble function here
    func createDefaultBubble() {
        if viewModel.canCreateBubble() {
//            let position = centerPosition // Use centerPosition instead of self.center
            let size = viewModel.minBubbleSize
            viewModel.addBubble( size: size)
        }
    }




    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Circle()
                    .fill(Color.red.opacity(1)) // Give it a semi-transparent color
                    .frame(width: previewBubbleSize, height: previewBubbleSize)
                    .position(geometry.size.center)

                    .zIndex(1) // Place it on top of the PlusButton

                ForEach(viewModel.bubbles.indices, id: \.self) { index in
                    BubbleView(position: viewModel.positionBinding(for: index), size: viewModel.bubbles[index].size)
                }

                PlusButton(action: {
                    createDefaultBubble()
                    print("Create")
                }, diameter: max(viewModel.buttonDiameter, plusButtonSize), bubbleSize: max(viewModel.minBubbleSize, plusButtonSize)) // Pass plusButtonSize
// Pass dragState.width
                .highPriorityGesture(
                    DragGesture(minimumDistance: 0.1)
                        .onChanged { value in
                            let newSize = calculatePreviewBubbleSize(geometry: geometry, value)
                            previewBubbleSize = newSize
                        }

                        .onEnded { value in
                            createBubble(value, isEnded: true)
                            
                                previewBubbleSize = 0 // Reset the preview bubble size
                                //                            print(value)
                            
                            
                        }


                                )
                                .position(geometry.size.center)
//                                .contentShape(Circle())
                            }
            .onAppear {
                viewModel.setCenter(geometry.size.center)
                let circle = Circle().path(in: CGRect(x: geometry.size.width / 2 - 65, y: geometry.size.height / 2 - 65, width: 80, height: 80))
                viewModel.setPath(circle)
                viewModel.buttonDiameter = 80
                plusButtonSize = viewModel.buttonDiameter
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
