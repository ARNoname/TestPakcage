import SwiftUI

struct ShineButton: View {
    
    let trigger: Bool
    let size: CGSize
    let duration: CGFloat
    let rightToLeft: Bool
    let color: Color
    
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        Rectangle()
            .fill(.linearGradient(
                colors: [
                    .clear,
                    .clear,
                    color.opacity(0.1),
                    color.opacity(0.5),
                    color.opacity(1),
                    color.opacity(0.5),
                    color.opacity(0.1),
                    .clear,
                    .clear,
                ],
                startPoint: .leading,
                endPoint: .trailing
            ))
            .scaleEffect(y: 8)
            .offset(x: animationOffset)
            .rotationEffect(.degrees(0))
            .scaleEffect(x: rightToLeft ? -1 : 1)
            .onAppear {
                animationOffset = -size.width
            }
            .onChange(of: trigger) { _ ,newValue in
                if newValue {
                    animationOffset = -size.width
                    
                    withAnimation(.linear(duration: duration)) {
                        animationOffset = size.width * 2
                    }
                }
            }
    }
}

extension View {
    @ViewBuilder public func shine(_ trigger: Bool, duration: CGFloat = 0.8, rightToLeft: Bool = false, color: Color = .white) -> some View {
        self
            .overlay {
                GeometryReader { geometry in
                    let size = geometry.size
                    let modeDuration = max(0.3, duration)
                    
                    ShineButton(
                        trigger: trigger,
                        size: size,
                        duration: modeDuration,
                        rightToLeft: rightToLeft,
                        color: color
                    )
                }
            }
    }
}

