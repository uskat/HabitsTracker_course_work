
import UIKit

public enum Size {
    static var screenX = UIScreen.main.bounds.width
    static var screenY = UIScreen.main.bounds.height
    
    static var habitsTodayLabelSpace: CGFloat = 14   ///HabitsVC: отступы по бокам заголовка Сегодня
    static var habitsSpaceTop: CGFloat = 22   ///HabitsVC: отступ сверху
    static var habitsSpace: CGFloat = 16   ///HabitsVC: отступы по бокам
    static var habitsItemsSpace: CGFloat = 12   ///HabitsVC: отступы между ячейками (за искл. progressCollectionVC)
    
    static var progressSpace: CGFloat = 12   ///ProgressCollectionVC: отступы по бокам
    static var habitsCellSpace: CGFloat = 20   ///HabitsCollectionVC: внешние отступы
    
    static var habitSpaceTop: CGFloat = 21   ///HabitVC: отступ сверху
    static var habitSpace: CGFloat = 16   ///HabitVC: отступы по бокам
    static var habitItemsSpace: CGFloat = 7   ///HabitVC: отступы между ячейками
    static var habitGroupsSpace: CGFloat = 15   ///HabitVC: отступы между группами ячеек
}

public enum HabitColor {
    //Типовые цвета, согласно макета
    static var lightGray: UIColor  = UIColor(red: 242, green: 242, blue: 247, a: 1.0)
    static var purple: UIColor = UIColor(red: 161, green: 22, blue: 204, a: 1.0)
    static var blue: UIColor = UIColor(red: 41, green: 109, blue: 255, a: 1.0)
    static var green: UIColor = UIColor(red: 29, green: 179, blue: 34, a: 1.0)
    static var violet: UIColor = UIColor(red: 98, green: 54, blue: 255, a: 1.0)
    static var orange: UIColor = UIColor(red: 255, green: 159, blue: 79, a: 1.0)
    
    //Цвета ключевых элементов интерфейса, согласно макета
    static var tabBar: UIColor = .white
    static var navBar: UIColor = .white
    static var background: UIColor = UIColor(rgb: 0xF2F2F7)   ///цвет фона HabitsVС and HabitsDetailsVC
    static var backroundProgressBar = UIColor(rgb: 0xD8D8D8)   ///цвет фона progressBar
    static var separator: UIColor = UIColor(red: 60, green: 60, blue: 67, a: 0.29)
    static var activityLabel: UIColor = UIColor(red: 60, green: 60, blue: 67, a: 0.60)
    
    //Цвет по умолчанию, который отображается при создании новой привычки
    static var initial: UIColor { return orange }
}

public var statusText = "Введите название привычки"
public var selectedTime: String = ""
public var selectedTimeReal: Date = Date()
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
