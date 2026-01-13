

import SwiftUI
#if canImport(Lottie)
import Lottie

public struct LottieView: UIViewRepresentable {
    public var animationName: String?
    public var animation: LottieAnimation?
    public var loopMode: LottieLoopMode
    public var contentMode: UIView.ContentMode
    public var play: Bool
    public var playDelay: TimeInterval

    public init(animationName: String,
          loopMode: LottieLoopMode = .loop,
          contentMode: UIView.ContentMode = .scaleAspectFit,
          play: Bool = true,
          playDelay: TimeInterval = 0.8) {
         self.animationName = animationName
         self.animation = nil
         self.loopMode = loopMode
         self.contentMode = contentMode
         self.play = play
         self.playDelay = playDelay
     }

    public init(animation: LottieAnimation,
          loopMode: LottieLoopMode = .loop,
          contentMode: UIView.ContentMode = .scaleAspectFit,
          play: Bool = true,
          playDelay: TimeInterval = 0.8) {
         self.animation = animation
         self.animationName = nil
         self.loopMode = loopMode
         self.contentMode = contentMode
         self.play = play
         self.playDelay = playDelay
     }

   public  func makeUIView(context: Context) -> UIView {
         let view = UIView(frame: .zero)
         let animationView = LottieAnimationView()
         
         animationView.translatesAutoresizingMaskIntoConstraints = false
         animationView.contentMode = contentMode
         animationView.loopMode = loopMode
         animationView.backgroundBehavior = .pauseAndRestore
         
         animationView.shouldRasterizeWhenIdle = true
         animationView.respectAnimationFrameRate = true
         
         animationView.backgroundColor = UIColor.clear
         view.backgroundColor = UIColor.clear

         if let name = animationName {
             animationView.animation = LottieAnimation.named(name)
         } else if let animation = animation {
             animationView.animation = animation
         }

         view.addSubview(animationView)

         NSLayoutConstraint.activate([
             animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             animationView.topAnchor.constraint(equalTo: view.topAnchor),
             animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
         
         if play {
             DispatchQueue.main.asyncAfter(deadline: .now() + playDelay) {
                 animationView.play()
             }
         }

         return view
     }

    public  func updateUIView(_ uiView: UIView, context: Context) {
         guard let animationView = uiView.subviews.first as? LottieAnimationView else { return }
         
         if play {
             if !animationView.isAnimationPlaying {
                 DispatchQueue.main.asyncAfter(deadline: .now() + playDelay) {
                     animationView.play()
                 }
             }
         } else {
             animationView.stop()
         }
     }
}

#endif
