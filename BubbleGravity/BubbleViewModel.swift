import SwiftUI

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat // Add size property
}




class BubbleViewModel: ObservableObject {
    @Published var bubbles: [Bubble] = []
    @Published var lastBubbleSize: CGFloat = 0

        var buttonDiameter: CGFloat = 80 // Default value, can be updated later

    let maxBubbleSize: CGFloat = 250 // Add maxBubbleSize constant
    let minBubbleSize: CGFloat = 100 // Add maxBubbleSize constant
    var center: CGPoint = .zero
    var bubbleCreationTimeInterval: TimeInterval = 0.15
    private var lastBubbleCreationTime: TimeInterval = 0


    func setCenter(_ center: CGPoint) {
        self.center = center
    }
    
    var path: Path = Path()

        func setPath(_ path: Path) {
            self.path = path
        }

    func addBubble(size: CGFloat) {
        let position = center
        let bubble = Bubble(position: position, size: size)
        bubbles.append(bubble)
        
        let angle = Double.random(in: 0..<2 * .pi)
        let distance: CGFloat = 10
        let xOffset = cos(angle) * Double(distance)
        let yOffset = sin(angle) * Double(distance)
        let newPosition = CGPoint(x: position.x + CGFloat(xOffset), y: position.y + CGFloat(yOffset))
        
        withAnimation(.easeOut(duration: 0.0)) {
            bubbles[bubbles.count - 1].position = newPosition
            lastBubbleSize = size
        }
        
        animateBubbles(to: center, damping: 0.6, duration: 0.7)
    }

    func animateBubbles(to center: CGPoint, damping: CGFloat, duration: TimeInterval) {
        withAnimation(.spring(response: duration, dampingFraction: damping)) {
            for index in bubbles.indices {
                let currentBubblePosition = bubbles[index].position
                let distance = currentBubblePosition.distance(to: center)
                let maxDistance = buttonDiameter / 2 + bubbles[index].size / 2
                let factor = max(0, 1 - distance / maxDistance)
                let newPosition = CGPoint(x: center.x + (currentBubblePosition.x - center.x) * factor,
                                          y: center.y + (currentBubblePosition.y - center.y) * factor)
                if !path.contains(newPosition) {
                    bubbles[index].position = newPosition
                }
            }
        }
    }







    func applyGravity(to center: CGPoint, pushBackFactor: CGFloat = 0.1) {
        let movementSpeed: CGFloat = 0.5
        let buttonPushForce: CGFloat = 0.3
        let buttonRadius: CGFloat = buttonDiameter / 2
        let screenSize = UIScreen.main.bounds.size

        for (index, bubble) in bubbles.enumerated() {
            let currentPosition = bubble.position
            let bubbleRadius = bubble.size / 2 // Use bubble size here
            let direction = CGVector(dx: center.x - currentPosition.x, dy: center.y - currentPosition.y)
            let distance = sqrt(pow(direction.dx, 2) + pow(direction.dy, 2))
            let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)

            let newPosition = CGPoint(x: currentPosition.x + normalizedDirection.dx * movementSpeed, y: currentPosition.y + normalizedDirection.dy * movementSpeed)

            var pushBackVector = CGVector(dx: 0, dy: 0)
            if newPosition.x < bubbleRadius {
                pushBackVector.dx = (bubbleRadius - newPosition.x) * pushBackFactor
            } else if newPosition.x > screenSize.width - bubbleRadius {
                pushBackVector.dx = -(newPosition.x - (screenSize.width - bubbleRadius)) * pushBackFactor
            }

            if newPosition.y < bubbleRadius {
                pushBackVector.dy = (bubbleRadius - newPosition.y) * pushBackFactor
            } else if newPosition.y > screenSize.height - bubbleRadius {
                pushBackVector.dy = -(newPosition.y - (screenSize.height - bubbleRadius)) * pushBackFactor
            }

            bubbles[index].position = CGPoint(x: newPosition.x + pushBackVector.dx, y: newPosition.y + pushBackVector.dy)


            if distance < buttonRadius + bubbleRadius {
                let pushDistance = max(0, buttonRadius + bubbleRadius - distance) * buttonPushForce
                bubbles[index].position.x -= normalizedDirection.dx * pushDistance
                bubbles[index].position.y -= normalizedDirection.dy * pushDistance
            }
        }
        resolveCollisions()
    }

    func canCreateBubble() -> Bool {
        let currentTime = CACurrentMediaTime()
        if currentTime - lastBubbleCreationTime >= bubbleCreationTimeInterval {
            lastBubbleCreationTime = currentTime
            return true
        }
        return false
    }


    func resolveCollisions() {
        let minPushForce: CGFloat = 0.2
        let maxPushForce: CGFloat = 0.5
        let damping: CGFloat = 0.3

        for i in 0..<bubbles.count {
            for j in (i + 1)..<bubbles.count {
                let distance = bubbles[i].position.distance(to: bubbles[j].position)
                let bubbleRadius1 = bubbles[i].size / 2
                let bubbleRadius2 = bubbles[j].size / 2

                if distance < bubbleRadius1 + bubbleRadius2 {
                    let direction = CGVector(dx: bubbles[j].position.x - bubbles[i].position.x, dy: bubbles[j].position.y - bubbles[i].position.y)
                    let normalizedDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)

                    let pushDistance = max(0, bubbleRadius1 + bubbleRadius2 - distance)
                    
                    // Calculate pushForce based on bubble sizes
                    let sizeFactor = max(bubbles[i].size, bubbles[j].size) / maxBubbleSize
                    let pushForce = (minPushForce + sizeFactor * (maxPushForce - minPushForce)) * damping

                    bubbles[i].position.x -= normalizedDirection.dx * pushDistance * pushForce
                    bubbles[i].position.y -= normalizedDirection.dy * pushDistance * pushForce
                    bubbles[j].position.x += normalizedDirection.dx * pushDistance * pushForce
                    bubbles[j].position.y += normalizedDirection.dy * pushDistance * pushForce
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
