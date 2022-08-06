
import UIKit

class InfoViewController: UIViewController {

    private var habitsDescription: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        //$0.font = UIFont
        $0.text = """
        (раненное) Зельеваренье. Подарочное издание за символические 100 руб. кому нужно, при покупке другой игры
        Не хватает нескольких карт (3 карты Практикум, 1 карта Университет, 3 карты Последовательности из Алхимиков), фишек игроков и каких-то плюшек подарочного набора.
        Состояние карт и коробки хорошее.

        Возможно Вас заинтересуют и другие игры, которые я продаю.
        В наличии около 2-х десятков лотов - см.объявления #БНИ_JamesA
        или обращайтесь в личку.

        Все вопросы лучше задавать только в личку. Комментарии читаю редко.
        100% предоплата. Без бартера. Доставка за счет покупателя (только Почта РФ и СДЕК).
        Упаковка очень качественная: с пупыркой и доп.укреплением углов. По запросу сделаю более подробные и качественные фото.
        (раненное) Зельеваренье. Подарочное издание за символические 100 руб. кому нужно, при покупке другой игры
        Не хватает нескольких карт (3 карты Практикум, 1 карта Университет, 3 карты Последовательности из Алхимиков), фишек игроков и каких-то плюшек подарочного набора.
        Состояние карт и коробки хорошее.

        Возможно Вас заинтересуют и другие игры, которые я продаю.
        В наличии около 2-х десятков лотов - см.объявления #БНИ_JamesA
        или обращайтесь в личку.

        Все вопросы лучше задавать только в личку. Комментарии читаю редко.
        100% предоплата. Без бартера. Доставка за счет покупателя (только Почта РФ и СДЕК).
        Упаковка очень качественная: с пупыркой и доп.укреплением углов. По запросу сделаю более подробные и качественные фото.
"""
        $0.isEditable = false
        $0.isScrollEnabled = true
        return $0
    }(UITextView())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        show()
    }


    func show() {
        [habitsDescription].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            habitsDescription.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            habitsDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            habitsDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            habitsDescription.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
    }
    
}
