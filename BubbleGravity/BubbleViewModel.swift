import SwiftUI

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
}

class BubbleViewModel: ObservableObject {
    @Published var bubbles: [Bubble] = []
        
        var buttonDiameter: CGFloat = 60 // Default value, can be updated later

    var center: CGPoint = .zero

    func setCenter(_ center: CGPoint) {
        self.center = center
    }
    
    var path: Path = Path()

        func setPath(_ path: Path) {
            self.path = path
        }

    func addBubble(at position: CGPoint) {
        let bubble = Bubble(position: position)
        bubbles.append(bubble)
        
        let angle = Double.random(in: 0..<2 * .pi)
        let distance: CGFloat = 100
        let xOffset = cos(angle) * Double(distance)
        let yOffset = sin(angle) * Double(distance)
        let newPosition = CGPoint(x: position.x + CGFloat(xOffset), y: position.y + CGFloat(yOffset))
        
        withAnimation(.easeOut(duration: 0.3)) {
            bubbles[bubbles.count - 1].position = newPosition
        }
        
        animateBubbles(to: center)
    }
//    it works!!
//    func applyGravity(to center: CGPoint) {
//            let movementSpeed: CGFloat = 0.2 // Adjust this value to change the strength of the gravitational pull
//
//            for (index, _) in bubbles.enumerated() {
//                let currentPosition = bubbles[index].position
//                let direction = CGVector(dx: center.x - currentPosition.x, dy: center.y - currentPosition.y)
//                let distance = sqrt(pow(direction.dx, 2) + pow(direction.dy, 2))
//                let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)
//
//                let newPosition = CGPoint(x: currentPosition.x + normalizedDirection.dx * movementSpeed, y: currentPosition.y + normalizedDirection.dy * movementSpeed)
//
//                if !path.contains(newPosition) {
//                    bubbles[index].position = newPosition
//                }
//            }
//            resolveCollisions()
//        }
    
    
//    IT WORKS v2
//    func applyGravity(to center: CGPoint) {
//            let movementSpeed: CGFloat = 0.3 // Adjust this value to change the strength of the gravitational pull
//            let buttonPushForce: CGFloat = 0.4 // Adjust this value to change the strength of the push force between bubbles and the + button
//
//            for (index, _) in bubbles.enumerated() {
//                let currentPosition = bubbles[index].position
//                let direction = CGVector(dx: center.x - currentPosition.x, dy: center.y - currentPosition.y)
//                let distance = sqrt(pow(direction.dx, 2) + pow(direction.dy, 2))
//                let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)
//
//                let newPosition = CGPoint(x: currentPosition.x + normalizedDirection.dx * movementSpeed, y: currentPosition.y + normalizedDirection.dy * movementSpeed)
//
//                if !path.contains(newPosition) {
//                    bubbles[index].position = newPosition
//                } else {
//                    // Push bubbles away from the + button
//                    bubbles[index].position.x -= normalizedDirection.dx * buttonPushForce
//                    bubbles[index].position.y -= normalizedDirection.dy * buttonPushForce
//                }
//            }
//            resolveCollisions()
//        }
//
//        func resolveCollisions() {
//            let bubbleRadius: CGFloat = 20
//            let pushForce: CGFloat = 0.5 // Adjust this value to change the strength of the push force between bubbles
//
//            for i in 0..<bubbles.count {
//                for j in (i + 1)..<bubbles.count {
//                    let distance = bubbles[i].position.distance(to: bubbles[j].position)
//
//                    if distance < 2 * bubbleRadius {
//                        let direction = CGVector(dx: bubbles[j].position.x - bubbles[i].position.x, dy: bubbles[j].position.y - bubbles[i].position.y)
//                        let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)
//
//                        bubbles[i].position.x -= normalizedDirection.dx * pushForce
//                        bubbles[i].position.y -= normalizedDirection.dy * pushForce
//                        bubbles[j].position.x += normalizedDirection.dx * pushForce
//                        bubbles[j].position.y += normalizedDirection.dy * pushForce
//                    }
//                }
//            }
//        }

//    IT WORKS V3
//    func applyGravity(to center: CGPoint) {
//            let movementSpeed: CGFloat = 0.2
//            let buttonPushForce: CGFloat = 1.7
//            let bubbleRadius: CGFloat = 20
//
//
//            for (index, _) in bubbles.enumerated() {
//                let currentPosition = bubbles[index].position
//                let direction = CGVector(dx: center.x - currentPosition.x, dy: center.y - currentPosition.y)
//                let distance = sqrt(pow(direction.dx, 2) + pow(direction.dy, 2))
//                let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)
//
//                let newPosition = CGPoint(x: currentPosition.x + normalizedDirection.dx * movementSpeed, y: currentPosition.y + normalizedDirection.dy * movementSpeed)
//
//                if !path.contains(newPosition) {
//                    bubbles[index].position = newPosition
//                } else {
//                    let pushDistance = max(0, 2 * bubbleRadius - distance) * buttonPushForce
//                    bubbles[index].position.x -= normalizedDirection.dx * pushDistance
//                    bubbles[index].position.y -= normalizedDirection.dy * pushDistance
//                }
//            }
//            resolveCollisions()
//        }
    
//    IT Works v4
//    func applyGravity(to center: CGPoint) {
//        let bubbleRadius: CGFloat = 20
//        let movementSpeed: CGFloat = 0.1
//        let buttonPushForce: CGFloat = 1.0
//
//        for (index, _) in bubbles.enumerated() {
//            let currentPosition = bubbles[index].position
//            let direction = CGVector(dx: center.x - currentPosition.x, dy: center.y - currentPosition.y)
//            let distance = sqrt(pow(direction.dx, 2) + pow(direction.dy, 2))
//            let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)
//
//            let newPosition = CGPoint(x: currentPosition.x + normalizedDirection.dx * movementSpeed, y: currentPosition.y + normalizedDirection.dy * movementSpeed)
//
//            bubbles[index].position = newPosition
//
//            if path.contains(newPosition) {
//                let pushDistance = max(0, 2 * bubbleRadius - distance) * buttonPushForce
//                bubbles[index].position.x -= normalizedDirection.dx * pushDistance
//                bubbles[index].position.y -= normalizedDirection.dy * pushDistance
//            }
//        }
//        resolveCollisions()
//    }

    func applyGravity(to center: CGPoint) {
        let bubbleRadius: CGFloat = 20
        let movementSpeed: CGFloat = 0.5
        let buttonPushForce: CGFloat = 1.0
        let buttonRadius: CGFloat = buttonDiameter / 2

        for (index, _) in bubbles.enumerated() {
            let currentPosition = bubbles[index].position
            let direction = CGVector(dx: center.x - currentPosition.x, dy: center.y - currentPosition.y)
            let distance = sqrt(pow(direction.dx, 2) + pow(direction.dy, 2))
            let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)

            let newPosition = CGPoint(x: currentPosition.x + normalizedDirection.dx * movementSpeed, y: currentPosition.y + normalizedDirection.dy * movementSpeed)

            bubbles[index].position = newPosition

            if distance < buttonRadius + bubbleRadius {
                let pushDistance = max(0, buttonRadius + bubbleRadius - distance) * buttonPushForce
                bubbles[index].position.x -= normalizedDirection.dx * pushDistance
                bubbles[index].position.y -= normalizedDirection.dy * pushDistance
            }
        }
        resolveCollisions()
    }


        func resolveCollisions() {
            let bubbleRadius: CGFloat = 20
            let pushForce: CGFloat = 0.7

            for i in 0..<bubbles.count {
                for j in (i + 1)..<bubbles.count {
                    let distance = bubbles[i].position.distance(to: bubbles[j].position)

                    if distance < 2 * bubbleRadius {
                        let direction = CGVector(dx: bubbles[j].position.x - bubbles[i].position.x, dy: bubbles[j].position.y - bubbles[i].position.y)
                        let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)

                        let pushDistance = max(0, 2 * bubbleRadius - distance) * pushForce

                        bubbles[i].position.x -= normalizedDirection.dx * pushDistance
                        bubbles[i].position.y -= normalizedDirection.dy * pushDistance
                        bubbles[j].position.x += normalizedDirection.dx * pushDistance
                        bubbles[j].position.y += normalizedDirection.dy * pushDistance
                    }
                }
            }
        }
    func animateBubbles(to center: CGPoint, duration: TimeInterval = 1.0, speed: Double = 1.0) {
        withAnimation(.linear(duration: duration).speed(speed)) {
            for index in bubbles.indices {
                    let currentBubblePosition = bubbles[index].position
                    let newPosition = CGPoint(x: center.x + (currentBubblePosition.x - center.x) * 0.1,
                                              y: center.y + (currentBubblePosition.y - center.y) * 0.1)

                    if !path.contains(newPosition) {
                        bubbles[index].position = newPosition
                    }
                }
        }
    }

    private func distance(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let xDistance = point1.x - point2.x
        let yDistance = point1.y - point2.y
        return hypot(xDistance, yDistance)
    }
    


    func positionBinding(for index: Int) -> Binding<CGPoint> {
        Binding(
            get: { self.bubbles[index].position },
            set: { self.bubbles[index].position = $0 }
        )
    }
}
