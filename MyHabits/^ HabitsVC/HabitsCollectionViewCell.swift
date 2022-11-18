
import UIKit

class HabitsCollectionViewCell: UICollectionViewCell {
    
    var indexPath: IndexPath?
    var habit: Habit?
    weak var delegate: HabitsStoreDelegate?
    
    //Общее вью элемента коллекции привычек
    private var habitsElementsView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.isUserInteractionEnabled = true
        return $0
    }(UIView())
    
    //Название привычки
    private var habitNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    //Заголовок с указанием времени выполнения привычки
    private var timeOfHabitUseLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .systemGray2
        return $0
    }(UILabel())
    
    //Счетчик, указанием того, сколько раз данная привычка была выполнена с момента ее создания
    private var counterLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .systemGray
        return $0
    }(UILabel())
    
    //Поле для изменения Статуса привычки (Не Выполнено - белый круг с цветн.ободом, Выполнено - цветн.круг с белой галочкой
    private let statusOfHabitButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 19
        $0.setImage(UIImage(systemName: "checkmark"), for: .normal)
        $0.tintColor = .systemRed
        $0.addTarget(self, action: #selector(tapOnHabitView), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    //MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        showItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - METHODs
    //После нажатия на круглое поле в ячейке привычки устанавливаем её статус
    @objc private func tapOnHabitView() {
        print("Нажимаем на Статус")
        if let habit = habit {
            if !habit.isAlreadyTakenToday {
                print("Установили статус привычки Выполнено")
                let store = HabitsStore.shared
                store.track(habit)
                store.save()
                delegate?.reload()
                setupCell(habit)
            } else {
                print("Привычка уже имеет статус Выполнено")
            }
        }
    }
    
    private func showItems() {
        contentView.addSubview(habitsElementsView)
        [statusOfHabitButton, habitNameLabel, timeOfHabitUseLabel, counterLabel].forEach { habitsElementsView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            //Отображение общей вью ячейки привычки для коллекции
            habitsElementsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            habitsElementsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            habitsElementsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            habitsElementsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //Отображение названия привычки
            habitNameLabel.topAnchor.constraint(equalTo: habitsElementsView.topAnchor, constant: Size.habitsCellSpace),
            habitNameLabel.leadingAnchor.constraint(equalTo: habitsElementsView.leadingAnchor, constant: Size.habitsCellSpace),
            habitNameLabel.widthAnchor.constraint(equalToConstant: 220),
            habitNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            //Отображение заголовка с указанием времени привычки
            timeOfHabitUseLabel.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 4),
            timeOfHabitUseLabel.leadingAnchor.constraint(equalTo: habitNameLabel.leadingAnchor),
            timeOfHabitUseLabel.widthAnchor.constraint(equalToConstant: 220),
            timeOfHabitUseLabel.heightAnchor.constraint(equalToConstant: 16),
            
            //Отображение счетчика выполнения привычки
            counterLabel.bottomAnchor.constraint(equalTo: habitsElementsView.bottomAnchor, constant: -Size.habitsCellSpace),
            counterLabel.leadingAnchor.constraint(equalTo: habitNameLabel.leadingAnchor),
            counterLabel.widthAnchor.constraint(equalToConstant: 220),
            counterLabel.heightAnchor.constraint(equalToConstant: 18),
            
            //Отображение ячейки (кнопки) для изменения Статуса выполнения привычки
            statusOfHabitButton.centerYAnchor.constraint(equalTo: habitsElementsView.centerYAnchor),
            statusOfHabitButton.trailingAnchor.constraint(equalTo: habitsElementsView.trailingAnchor, constant: -25),
            statusOfHabitButton.widthAnchor.constraint(equalToConstant: 38),
            statusOfHabitButton.heightAnchor.constraint(equalToConstant: 38)
            ])
    }
    
    func setupCell(_ habit: Habit) {
        habitNameLabel.text = habit.name
        habitNameLabel.textColor = habit.color
        timeOfHabitUseLabel.text = habit.dateString
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        if habit.isAlreadyTakenToday {          ///Стиль ячейки Статуса для привычки, которая уже была выполнена
            statusOfHabitButton.backgroundColor = habit.color
            statusOfHabitButton.tintColor = .white
            statusOfHabitButton.layer.borderWidth = 2
            statusOfHabitButton.layer.borderColor = habit.color.cgColor
        } else {                                ///Стиль ячейки Статуса для привычки, которая ещё НЕ была выполнена
            statusOfHabitButton.backgroundColor = .white
            statusOfHabitButton.tintColor = .clear
            statusOfHabitButton.layer.borderWidth = 2
            statusOfHabitButton.layer.borderColor = habit.color.cgColor
        }
    }
}
