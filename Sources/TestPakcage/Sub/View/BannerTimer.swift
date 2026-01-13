import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct BannerTimer: View {
    @State private var timeRemaining: Int = 30 // 3 minutes in seconds
    @State private var timer: Timer?
    @Binding var isShowTimer: Bool
     
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 4){
                BannerTimerDigitView(digit: timeRemaining / 60 / 10)
                BannerTimerDigitView(digit: (timeRemaining / 60) % 10)
            }
            .frame(width: 80, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green)
            )
            
            Image(.doubleDoteIcons)
            
            HStack(spacing: 4) {
                BannerTimerDigitView(digit: (timeRemaining % 60) / 10)
                BannerTimerDigitView(digit: (timeRemaining % 60) % 10)
            }
            .frame(width: 80, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green)
            )
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func startTimer() {
  
          timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
              DispatchQueue.main.async {
                  if timeRemaining > 0 {
                      timeRemaining -= 1
                  } else {
                      stopTimer()
                  }
              }
          }
          
          if let timer = timer {
              RunLoop.current.add(timer, forMode: .common)
          }
      }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isShowTimer = false
    }
}

struct BannerTimerDigitView: View {
    let digit: Int
    
    var body: some View {
        Text("\(digit)")
            .fontApp(.semibold, 50)
            .foregroundStyle(Color.white)
            .contentTransition(.numericText())
            .animation(.easeInOut(duration: 0.3), value: digit)
    }
}

#endif

