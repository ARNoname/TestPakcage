import SwiftUI

@MainActor
public struct XmarkPostion {
    public var x: CGFloat
    public var y: CGFloat
    public var alignment: Alignment
    public var color: Color
    
    public init(
        x: CGFloat,
        y: CGFloat,
        alignment: Alignment,
        color: Color = .gray
    ) {
        self.x = x
        self.y = y
        self.alignment = alignment
        self.color = color
    }
}
