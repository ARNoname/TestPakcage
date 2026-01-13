
import SwiftUI
#if canImport(View_Ext)
import View_Ext

public struct OnbView<First: View, Second: View, Third: View, Bob: View>: View {
    
    @EnvironmentObject var managerIAP: ManagerIAP
    @ObservedObject var subVM: ScreensVM
    
    private let firstOnb: () -> First
    private let secondOnb: () -> Second
    private let thirdOnb: () -> Third
    private let bobOnb: () -> Bob
    
    let config = AppConfig.shared
    
    public init(
        subVM: ScreensVM,
        @ViewBuilder first: @escaping () -> First,
        @ViewBuilder second: @escaping () -> Second,
        @ViewBuilder third: @escaping () -> Third,
        @ViewBuilder bob: @escaping () -> Bob)
    {
        self.subVM = subVM
        self.firstOnb = first
        self.secondOnb = second
        self.thirdOnb = third
        self.bobOnb = bob
    }
    
    public var body: some View {
        OnbViews()
            .onChange(of: subVM.currentPage) { _, _ in
                Task {
                    await SendManager.shared.sendViewNumber(pageNumber: subVM.currentNumberPage)
                }
            }
    }
    
    @ViewBuilder
    private func OnbViews() -> some View {
        switch config.onboardKey {
        case PaywallKey.first.onbordKey:    firstOnb()
        case PaywallKey.second.onbordKey:   secondOnb()
        case PaywallKey.third.onbordKey:    thirdOnb()
        case PaywallKey.bob.onbordKey:      bobOnb()
        default:                            EmptyView()
        }
    }
}
#endif
