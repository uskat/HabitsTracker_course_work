
import Foundation
import UIKit

public var screenWidth: CGFloat = UIScreen.main.bounds.width
public var screenHeight: CGFloat = UIScreen.main.bounds.height

public let spaceOnTheSidesOfHabitsVC: CGFloat = 16
public let spaceOnTheSidesOfProgressViewCell: CGFloat = 12
public let progressLength: CGFloat = screenWidth - 2 * (spaceOnTheSidesOfHabitsVC + spaceOnTheSidesOfProgressViewCell)

public var statusText = "Введите название привычки"

//Типовые цвета, согласно макета
public let habitLightGrayColor = UIColor(red: 242, green: 242, blue: 247, a: 1.0)
public let habitPurpleColor = UIColor(red: 161, green: 22, blue: 204, a: 1.0)
public let habitBlueColor = UIColor(red: 41, green: 109, blue: 255, a: 1.0)
public let habitGreenColor = UIColor(red: 29, green: 179, blue: 34, a: 1.0)
public let habitVioletColor = UIColor(red: 98, green: 54, blue: 255, a: 1.0)
public let habitOrangeColor = UIColor(red: 255, green: 159, blue: 79, a: 1.0)

//Цвета ключевых элементов интерфейса, согласно макета
public let colorOfTabBar = UIColor(red: 247, green: 247, blue: 247, a: 0.8)
public let colorOfNavBar = UIColor(red: 249, green: 249, blue: 249, a: 0.94)
public let backgroundColorOfHabitsVC = UIColor(rgb: 0xF2F2F7)
public let colorOfSeparator = UIColor(red: 60, green: 60, blue: 67, a: 0.29)
public let colorOfActivityLabel = UIColor(rgb: 0x3C3C43, a: 0.6)

public var selectedTime: String = ""
public var selectedTimeReal: Date = Date()

let initialHabitColor: UIColor = habitOrangeColor     //Цвет по умолчанию, который отображается при создании новой привычки
let initialHabitTime: Date = Date()


//Текстовая часть InfoViewController
public let infoPost: [String] = [
"Привычка за 21 день",
"Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:",
"1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.",
"2. Выдержать 2 дня в прежнем состоянии самоконтроля.",
"3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.",
"4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.",
"5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой."
]
