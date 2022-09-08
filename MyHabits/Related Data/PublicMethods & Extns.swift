import Foundation
import UIKit
import AVFoundation

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

//Анимированное появление текста в поле UITextField
extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: "kCATransitionFade")
}   }
extension UITextField {
    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.placeholder = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.placeholder?.append(character)
                    self.fadeTransition(characterDelay) // это анимация проявления
}   }   }   }   }

// НЕ ИСПОЛЬЗУЕТСЯ. Планируется добавить функцию при создании новой привычки
//Трясем текст в выбранном UITextField
public func shakeMeBaby(_ shakedItem: UITextField) {
    let shake = CABasicAnimation(keyPath: "position")
    let xDelta = CGFloat(3)
    shake.duration = 0.07
    shake.repeatCount = 4
    shake.autoreverses = true

    let from_point = CGPoint(x: shakedItem.center.x - xDelta, y: shakedItem.center.y)
    let from_value = NSValue(cgPoint: from_point)

    let to_point = CGPoint(x: shakedItem.center.x + xDelta, y: shakedItem.center.y)
    let to_value = NSValue(cgPoint: to_point)

    shake.fromValue = from_value
    shake.toValue = to_value
    shake.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    shakedItem.layer.add(shake, forKey: "position")
}

public func currentTime() -> String {
    let time = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm"
    print("текущee время \(dateFormatter.string(from: time))")
    return dateFormatter.string(from: time)
}
