import SwiftUI

@MainActor
extension UIDevice {
    static var isSimulator: Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
}

@MainActor
var isPad: Bool {
    UIDevice.current.userInterfaceIdiom == .pad
}
