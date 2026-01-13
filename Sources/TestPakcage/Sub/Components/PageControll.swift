import SwiftUI

public struct PageControll: View {
    @EnvironmentObject var subVM: ScreensVM
    
    @State public var animatedProgress: CGFloat = 0
    @State public var animatedDuration: CGFloat = 2.5
    
    public var numberOfPages: Int
    public var currentPage: Int
    public var barHeight: CGFloat
    public var fgColor: Color
    public var bgColor: Color
    public var spacing: CGFloat
    public var type: PageControllType
    
    @Namespace private var circleAnimat
    
    private var progress: CGFloat {
        guard numberOfPages > 0 else { return 0 }
        return CGFloat(currentPage + 1) / CGFloat(numberOfPages)
    }
    
    public init(
        animatedProgress: CGFloat = 0,
        animatedDuration: CGFloat = 2.5,
        numberOfPages: Int,
        currentPage: Int,
        barHeight: CGFloat = 6,
        fgColor: Color = .blue,
        bgColor: Color = .black.opacity(0.2),
        spacing: CGFloat = 10,
        type: PageControllType = .circular(width: 16)
    ) {
        self.animatedProgress = animatedProgress
        self.animatedDuration = animatedDuration
        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
        self.barHeight = barHeight
        self.fgColor = fgColor
        self.bgColor = bgColor
        self.spacing = spacing
        self.type = type
    }
    
    public var body: some View {
        switch type {
        case .animating:                  PageAnimating()
        case .circular(width: let width): PageCircle(width: width)
        case .line(isCrop: let isCrop):   PageLine(isCropLine: isCrop)
        }
    }
    
    @ViewBuilder
   private func PageLine(isCropLine: Bool = false) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if isCropLine {
                    HStack(spacing: spacing) {
                        ForEach(0..<numberOfPages, id: \.self) { page in
                            RoundedRectangle(cornerRadius:10)
                                .foregroundColor(bgColor)
                                .frame(height: barHeight)
                        }
                    }
                } else {
                    RoundedRectangle(cornerRadius:10)
                        .foregroundColor(bgColor)
                        .frame(height: barHeight)
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(fgColor)
                    .frame(width: geometry.size.width * (currentPage == 0 || currentPage == 1 ? progress - 0.012 : progress), height: barHeight)
            }
        }
        .frame(height: barHeight)
        .animation(.linear(duration: 0.3), value: currentPage)
    }
    
    @ViewBuilder
    private func PageCircle(width: CGFloat) -> some View {
        HStack(spacing: spacing) {
            Spacer()
            ForEach(0..<numberOfPages, id: \.self) { page in
                if page == currentPage {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: width, height: barHeight)
                        .foregroundStyle(page == currentPage ? fgColor : bgColor)
                        .matchedGeometryEffect(id: "circleAnimat", in: circleAnimat)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: barHeight, height: barHeight)
                        .foregroundStyle(page == currentPage ? fgColor : bgColor)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func PageAnimating() -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                HStack(spacing: spacing) {
                    ForEach(0..<numberOfPages, id: \.self) { page in
                        RoundedRectangle(cornerRadius:10)
                            .foregroundColor(bgColor)
                            .frame(height: barHeight)
                    }
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(fgColor)
                    .frame(width: geometry.size.width * animatedProgress, height: barHeight)
            }
        }
        .frame(height: barHeight)
        .onAppear {
            if currentPage == 0 {
                startInitialAnimation()
                withAnimation(.linear(duration: animatedDuration)) {
                    animatedProgress = progress
                }
            } else {
                animatedProgress = CGFloat(currentPage) / CGFloat(numberOfPages)
            }
        }
        .onChange(of: currentPage) { _, _ in
            startInitialAnimation()
            withAnimation(.linear(duration: animatedDuration)) {
                animatedProgress = progress
            }
        }
    }
    
   private func startInitialAnimation() {
        subVM.isProgressAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + animatedDuration) {
                subVM.isProgressAnimating = false
            }
        }
}

#Preview {
    VStack(spacing: 20) {
        PageControll(numberOfPages: 4, currentPage: 0, type: .line(isCrop: true))
        PageControll(numberOfPages: 4, currentPage: 1, type: .line(isCrop: true))
        PageControll(numberOfPages: 4, currentPage: 2, type: .line(isCrop: true))
        PageControll(numberOfPages: 4, currentPage: 3, type: .line(isCrop: true))
        
        PageControll(numberOfPages: 4, currentPage: 1, type: .circular(width: 16))
        PageControll(numberOfPages: 4, currentPage: 2, type: .animating)
    }
    .padding()
}

public enum PageControllType {
    case animating
    case circular(width: CGFloat)
    case line(isCrop: Bool)
}
