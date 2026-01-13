import SwiftUI

struct PaywallHostingController: UIViewControllerRepresentable {
    let content: AnyView
    @Binding var isHomeIndicatorHidden: Bool
    @Binding var isActionTriggered: Bool

    init<Content: View>(
        content: Content,
        isHomeIndicatorHidden: Binding<Bool> = .constant(false),
        isActionTriggered: Binding<Bool>
    ) {
        self.content = AnyView(content)
        self._isHomeIndicatorHidden = isHomeIndicatorHidden
        self._isActionTriggered = isActionTriggered
    }
    
    func makeUIViewController(context: Context) -> CustomHostingController<AnyView> {
 
        let controller = CustomHostingController(rootView: content)
        controller.isHomeIndicatorHidden = isHomeIndicatorHidden
        controller.coordinator = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CustomHostingController<AnyView>, context: Context) {
 
        uiViewController.rootView = content
        uiViewController.isHomeIndicatorHidden = isHomeIndicatorHidden
        uiViewController.coordinator = context.coordinator
        uiViewController.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isActionTriggered: $isActionTriggered)
    }
    
    class Coordinator {
        var isActionTriggered: Binding<Bool>
        
        init(isActionTriggered: Binding<Bool>) {
            self.isActionTriggered = isActionTriggered
        }
        
        func triggerAction() {
            isActionTriggered.wrappedValue.toggle()
            print("Action triggered: \(isActionTriggered.wrappedValue)")
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    var isHomeIndicatorHidden: Bool = false {
        didSet {
            setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }
    
    var coordinator: PaywallHostingController.Coordinator?
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .all
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return isHomeIndicatorHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
   
        view.gestureRecognizers?.removeAll()
                
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .up
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        let location = gesture.location(in: view)
        let screenHeight = view.bounds.height
        let homeIndicatorArea = screenHeight - 120
        
        if location.y > homeIndicatorArea {
            DispatchQueue.main.async {
                self.coordinator?.triggerAction()
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
    }
}


