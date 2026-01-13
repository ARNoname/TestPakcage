import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct NetworkError: View  {
    
    @State var isLottieAnimate: Bool = false

    var body: some View {
        ZStack {
            Color(hex:"242424").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
                LottieView(animationName: "No Internet Connection")
                    .frame(width: screenSizeApp().width - 60,height: screenSizeApp().width - 60)
                    .scaleEffect(isLottieAnimate ? 1 : 0)
                
                VStack(spacing:16) {
                    Text("No Internet connection!")
                        .fontApp(.bold, 30)
                    
                    Text("Please check your network and try again.")
                        .fontApp(.semibold, 22)
                }
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            }
        }
        .animation(.linear(duration: 0.9), value: isLottieAnimate)
        .onAppear{
            isLottieAnimate.toggle()
        }
    }
}

#Preview {
    NetworkError()
}
#endif
