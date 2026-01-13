import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct SelectPlan_Bob<Content: View>: View {
    @EnvironmentObject var manageIAB: ManagerIAP
    @EnvironmentObject var subVM: ScreensVM
    
    var plan: SubPlan
    var isSelected: Bool
    var title: String
    var subtitle: String? = nil
    var price: String? = nil
    var priceText: Content? = nil
    var hasLimitedOffer: Bool = false
    var onTap: () -> Void
     
       init(
           plan: SubPlan,
           isSelected: Bool,
           title: String,
           subtitle: String? = nil,
           price: String? = nil,
           hasLimitedOffer: Bool = false,
           onTap: @escaping () -> Void
       ) where Content == EmptyView {
           self.plan = plan
           self.isSelected = isSelected
           self.title = title
           self.subtitle = subtitle
           self.price = price
           self.priceText = nil
           self.hasLimitedOffer = hasLimitedOffer
           self.onTap = onTap
       }
    
    init(
           plan: SubPlan,
           isSelected: Bool,
           title: String,
           subtitle: String? = nil,
           @ViewBuilder priceText: @escaping () -> Content,
           hasLimitedOffer: Bool = false,
           onTap: @escaping () -> Void,
         
       ) {
           self.plan = plan
           self.isSelected = isSelected
           self.title = title
           self.subtitle = subtitle
           self.price = nil
           self.priceText = priceText()
           self.hasLimitedOffer = hasLimitedOffer
           self.onTap = onTap
       }
    
    var body: some View {
    ButtonApp(action: onTap) {
            ZStack {
                if hasLimitedOffer {
                    Text("Best offer".uppercased())
                        .fontApp(.bold, 10)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green)
                        )
                        .zIndex(1)
                        .offset(x: 120, y: -30)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading,spacing: 2) {
                            Text(title)
                                .fontApp(.semibold, 16)
                            
                            if let subtitle {
                                Text(TextColorApp.colorString(
                                    text: subtitle,
                                    rangeOne: manageIAB.yearlyPrice,
                                    rangeOneColor: .black,
                                    size: 12
                                ))
                                .fontApp(.regular, 12)
                                .foregroundStyle(Color.black)
                            }
                            
                        }
                     
                        Spacer()
                        
                       
                        VStack(alignment: .trailing, spacing: 4) {
                            
                                if plan == .weekly || plan == .weeklyTrial {
                                    Text("3 Days Free")
                                        .foregroundStyle(Color.white)
                                        .fontApp(.medium, 12)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 1)
                                        .background(Color.purple)
                                        .clipShape(.capsule)
                                }
                            
                                if let price {
                                    Text(price)
                                        .fontApp(.medium, 16)
                                        .foregroundStyle(Color.white)
                                }
                            
                                Text(perText)
                                    .fontApp(.regular, 12)
                                    .foregroundStyle(Color.white.opacity(0.5))
                            
                        }
                    }
                }
                .foregroundStyle(isSelected ? Color.purple : Color.white)
                .frame(height: 60)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(isSelected ? Color.purple.opacity(0.2) : Color.black.opacity(0.3))
                        .background(.ultraThinMaterial.opacity(0.01))
                        .frame(height: 56)
                        .clipShape(.rect(cornerRadius: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(strokeColor(),lineWidth: 0.5)))
            }
        }
    }
    
    private func strokeColor() -> Color {
        if isSelected {
            return Color.purple.opacity(0.6)
        } else {
            return Color.white.opacity(0.2)
        }
    }
    
    private var perText: String {
        switch plan {
        case .weekly, .weeklyTrial: "then \(manageIAB.weeklyPrice) per week"
        case .monthly: "per month"
        case .yearly: "per year"
        default: ""
        }
    }
}

#endif



