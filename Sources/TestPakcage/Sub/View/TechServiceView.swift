import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct TechServiceView: View {
    @State var showAlert: Bool = false
    @State var isLottieAnimation: Bool = true
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
            LottieView(animationName: "", play: isLottieAnimation)
                    .frame(width: 350,height: 200)
                
                VStack(spacing:16) {
                    Text("We're performing technical updates to make our service even better.")
                        .fontApp(.medium, 22)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("Maintenance work will continue \nuntil \(AppConfig.shared.techService.timeService)")
                        .fontApp(.medium, 16)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("Thank you for staying with us !")
                        .fontApp(.semibold, 24)
                        .foregroundStyle(Color.green)
                }
                .scaleEffect(showAlert ? 1 : 0)
                .padding(.horizontal, 20)
                .animation(.easeInOut(duration: 0.7), value: showAlert)
            }
        }
        .onAppear{
            showAlert = true
        }
        .onDisappear{
            showAlert = false
            isLottieAnimation = false
        }
    }
}

#Preview {
    TechServiceView()
}
#endif
