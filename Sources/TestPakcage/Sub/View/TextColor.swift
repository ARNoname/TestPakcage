//import SwiftUI
//
//struct TextColor {
//    func NsColorString(text: String,
//                      rangeOne: String? = nil,
//                      rangeOneColor: UIColor? = nil,
//                       rangeTwo: String? = nil,
//                       rangeTwoColor: UIColor? = nil,
//                      rangeFive: String? = nil,
//                      rangeFiveColor: UIColor? = nil,
//                      fontSize: CGFloat = 32,
//                       fontSizeColor: CGFloat = 32,
//                      lineSpacing: CGFloat = 0,
//                       fontWeight: String = "SemiBold") -> NSAttributedString {
//        
//        let attributedString = NSMutableAttributedString(string: text)
//    
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = lineSpacing
//        paragraphStyle.lineHeightMultiple = 0.85
//        
//        attributedString.addAttributes([
//            .paragraphStyle: paragraphStyle,
//            .font: UIFont(name: "", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize),
//            .foregroundColor: UIColor.black
//        ], range: NSRange(location: 0, length: text.count))
//        
//        if let range = text.range(of: rangeOne ?? "") {
//            let nsRange = NSRange(range, in: text)
//            if let color = rangeOneColor {
//                attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
//            }
//            attributedString.addAttribute(.font, value: UIFont(name: "", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize), range: nsRange)
//        }
//        
//        if let range = text.range(of: rangeTwo ?? "") {
//            let nsRange = NSRange(range, in: text)
//            if let color = rangeTwoColor {
//                attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
//            }
//            attributedString.addAttribute(.font, value: UIFont(name: "Outfit-\(fontWeight)", size: fontSizeColor) ?? UIFont.boldSystemFont(ofSize: fontSizeColor), range: nsRange)
//        }
//        
//        if let range = text.range(of: rangeFive ?? "") {
//            let nsRange = NSRange(range, in: text)
//            if let color = rangeFiveColor {
//                attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
//            }
//            attributedString.addAttribute(.font, value: UIFont(name: "Outfit-SemiBold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize), range: nsRange)
//        }
//        
//        return attributedString
//    }
//    
//    func colorString(text: String,
//                    rangeOne: String,
//                    rangeOneColor: UIColor? = nil,
//                    rangeTwo: String? = nil,
//                    rangeTwoColor: UIColor? = nil,
//                    rangeThree: String? = nil,
//                    rangeThreeColor: UIColor? = nil,
//                    rangeFour: String? = nil,
//                    rangeFourColor: UIColor? = nil,
//                     rangeFive: String? = nil,
//                     rangeFiveColor: UIColor? = nil,
//                     rangeSix: String? = nil,
//                     rangeSixColor: UIColor? = nil,
//                     size: CGFloat = 16) -> AttributedString {
//        
//        var attributedString = AttributedString(text)
//    
//        if let range = attributedString.range(of: rangeOne) {
//            attributedString[range].foregroundColor = rangeOneColor
//            attributedString[range].font = UIFont(name: "Outfit-Bold", size: size)
//        }
//        
//        if let rangeTwo = rangeTwo {
//            if let range = attributedString.range(of: rangeTwo) {
//                attributedString[range].foregroundColor = rangeTwoColor
//                attributedString[range].font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//            }
//        }
//        
//        if let rangeThree = rangeThree {
//            if let range = attributedString.range(of: rangeThree) {
//                attributedString[range].foregroundColor = rangeThreeColor
//                attributedString[range].font = UIFont.systemFont(ofSize: 16, weight: .bold)
//            }
//        }
//        
//        if let rangeFour = rangeFour {
//            if let range = attributedString.range(of: rangeFour) {
//                attributedString[range].foregroundColor = rangeFourColor
//                attributedString[range].font = UIFont.systemFont(ofSize: 12, weight: .bold)
//            }
//        }
//        
//        if let rangeFive = rangeFive {
//            if let range = attributedString.range(of: rangeFive) {
//                attributedString[range].foregroundColor = rangeFiveColor
//            }
//        }
//        
//        if let rangeSix = rangeSix {
//            if let range = attributedString.range(of: rangeSix) {
//                attributedString[range].foregroundColor = rangeSixColor
//                attributedString[range].font = UIFont(name: "Outfit-Bold", size: size)
//            }
//        }
//        
//       return attributedString
//    }
//}
//
//struct TextRedColor {
//
//    func colorString(text: String,
//                    rangeOne: String,
//                    rangeOneColor: UIColor? = nil,
//                    rangeTwo: String? = nil,
//                    rangeTwoColor: UIColor? = nil,
//                    rangeThree: String? = nil,
//                    rangeThreeColor: UIColor? = nil,
//                    rangeFour: String? = nil,
//                    rangeFourColor: UIColor? = nil,
//                     rangeFive: String? = nil,
//                     rangeFiveColor: UIColor? = nil) -> AttributedString {
//        
//        var attributedString = AttributedString(text)
//
//        if let range = attributedString.range(of: rangeOne) {
//            attributedString[range].foregroundColor = rangeOneColor
//            attributedString[range].font = UIFont.systemFont(ofSize: 14, weight: .bold)
//            attributedString[range].underlineStyle = .single
//        }
//        
//        if let rangeTwo = rangeTwo {
//            if let range = attributedString.range(of: rangeTwo) {
//                attributedString[range].foregroundColor = rangeTwoColor
//                attributedString[range].font = UIFont.systemFont(ofSize: 14, weight: .bold)
//                attributedString[range].underlineStyle = .single
//            }
//        }
//        
//        if let rangeThree = rangeThree {
//            if let range = attributedString.range(of: rangeThree) {
//                attributedString[range].foregroundColor = rangeThreeColor
//                attributedString[range].font = UIFont.systemFont(ofSize: 20, weight: .bold)
//            }
//        }
//        
//       return attributedString
//    }
//}
//
