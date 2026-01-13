
import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct SelectPlan_PW1<Content: View>: View {
    
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
                    Text("Save 90%")
                        .fontApp(.semibold, 12)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blueColors)
                        )
                        .zIndex(1)
                        .offset(x: -100, y: -30)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading,spacing: 2) {
                            Text(title)
                                .fontApp(.semibold, 20)
                
                            if let subtitle {
                                Text(subtitle)
                                    .fontApp(.medium, 10)
                            }
                        }
                
                        Spacer()
                        
                        if let price {
                            Text(price)
                                .fontApp(.medium, 14)
                        }
                        
                        if let priceText {
                            priceText
                        }
                
                        ImageTrasitionApp(
                            imageOne: .greenCheck,
                            imageTwo: .checkEmptyPay,
                            isSelected: isSelected,
                            action: {onTap()})
                    }
                }
                .foregroundStyle(isSelected ? Color.black : Color.gray)
                .frame(height: 60)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.white : Color.gray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    strokeColor(),
                                    lineWidth: isSelected ? 2 : 1))
                )
            }
        }
    }
    
    private func strokeColor() -> Color {
        if isSelected {
            return Color.green
        } else {
            return Color.gray.opacity(0.4)
        }
    }
}

#endif
