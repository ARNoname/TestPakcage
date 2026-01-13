import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct LaunchSpecialOfferView: View {
    @State private var scaleEffect: Double = 1.0
    @State private var opacityEffect: Double = 1.0
    @State private var config = AppConfig.shared

    var body: some View {
            ZStack {
                Color.white.ignoresSafeArea()
                
                HStack {
                    if let firstText = config.splashModel.firstText {
                        Text(firstText)
                    }
                    if let dayText = config.splashModel.dayText {
                        Text(dayText).foregroundStyle(Color.orange)
                    }
                    if let secondText = config.splashModel.secondText {
                        Text(secondText)
                    }
                }
                .scaleEffect(CGSize(width: scaleEffect, height: scaleEffect))
            }
            .zIndex(1)
            .foregroundStyle(Color.black)
            .fontApp(.bold, 35)
            .opacity(opacityEffect)
            .task {
                try? await Task.sleep(for: .seconds(0.5))
                withAnimation(.easeInOut(duration: 2)) {
                    scaleEffect = 0.0
                    opacityEffect = 0.0
                }
            }
    }
}

#Preview{
    LaunchSpecialOfferView()
}

#endif
