import Foundation
import UIKit

//Автоматическое присвоение имени идентфикатора ячейки для таблиц/коллекций
extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
    //How to use this ^^^ code:
    //let color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF, a: 0.5)
    //let color2 = UIColor(rgb: 0xFFFFFF, a: 0.5)
}

//public func currentTime() -> String {
//    let time = Date()
//    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = .none
//    dateFormatter.dateFormat = "hh:mm"
//    print("текущee время \(dateFormatter.string(from: time))")
//    return dateFormatter.string(from: time)
//}
