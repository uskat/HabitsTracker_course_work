
import UIKit

protocol HabitViewControllerDelegate: AnyObject {
    func removeHabit(usingIndex indexPath: IndexPath)
    func addToHabit(data habit: Habit, isNewHabit: Bool?, usingIndex indexPath: IndexPath?)
}

class HabitViewController: UIViewController {

    //MARK: - PROPs
    var isNewHabit: Bool?
    var isNameEdited: Bool?
    var isColorChoosen: Bool?
    var isTimeChoosen: Bool?
    var newColor: UIColor?
    //var newTime: Date?
    var indexPath: IndexPath?
    let store = HabitsStore.shared
    weak var delegate: HabitViewControllerDelegate?
    weak var delegateNew: HabitDetailsViewControllerDelegate? //HabitsStoreDelegate?
    
    
    //MARK: - ITEMs
    //Заголовок "Название привычки"
    private let nameOfHabitLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .black
        $0.text = "НАЗВАНИЕ"
        return $0
    }(UILabel())

    //Поле для ввода текста "Название привычки"
    private var nameOfHabitField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = habitBlueColor
        $0.placeholder = "Введите название привычки"
        $0.adjustsFontSizeToFitWidth = true         //уменьшение шрифта, если введенный текст не помещается
        $0.minimumFontSize = 12                     //до какого значения уменьшается шрифт
        $0.tintColor = habitPurpleColor
        $0.addTarget(self, action: #selector(changeNameOfHabit), for: .editingChanged)
        return $0
    }(UITextField())
    
    //Заголовок "Цвет привычки"
    private let colorOfHabitLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .black
        $0.text = "ЦВЕТ"
        return $0
    }(UILabel())
    
    //Кнопка, отображающая цвет привычки и вызывающая UIColorPicker для его изменения
    let colorOfHabitView: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(colorPicker), for: .touchUpInside)
        return $0
    }(UIButton())
    
    //Заголовок "Время привычки"
    private let timeOfHabitLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .black
        $0.text = "ВРЕМЯ"
        return $0
    }(UILabel())
    
    //Текстовое поле (начало)... см.след.элемент
    private var timeOfHabitLeftPart: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = false
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .black
        $0.backgroundColor = .clear
        $0.text = "Каждый день в"
        return $0
    }(UITextView())
    
    //Текстовое поле (продолжение) с указанием времени привычки
    private var timeOfHabitRightPart: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = habitPurpleColor
        $0.backgroundColor = .clear
        $0.text = "11:00 PM"
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 0, 0)
        return $0
    }(UITextView())
    
    //Выбор времени привычки
    private let datePicker: UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.timeZone = NSTimeZone.local
        $0.backgroundColor = .systemGray5
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .wheels
        $0.contentHorizontalAlignment = .center
        $0.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return $0
    }(UIDatePicker())
    
    //Кнопка "Удалить привычку" (Неактивна при создании новой привычки)
    var removeHabitButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.setTitle("Удалить привычку", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        //$0.isHidden = false
        $0.addTarget(self, action: #selector(tapToRemoveHabit), for: .touchUpInside)
        return $0
    }(UIButton())

    
    //MARK: - INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        showHabitItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showBarItems()
        isNameEdited = false
        isColorChoosen = false
        isTimeChoosen = false
        //Отображение данных о привычке
        if let isNewHabit = isNewHabit {
            if isNewHabit {    //Данные по умолчанию при создании новой привычки
                newColor = initialHabitColor
                statusText = "Введите название привычки"
                animateTextOnTextField(statusText)  //анимация текста в UITextField при открытии VC
                colorOfHabitView.backgroundColor = initialHabitColor //цвет привычки по умолчанию (см.файл Constants)
                let dateFormatter: DateFormatter = DateFormatter()   //время привычки по умолчанию (см.файл Constants)
                dateFormatter.dateFormat = "HH:mm a"
                timeOfHabitRightPart.text = dateFormatter.string(from: initialHabitTime)
            } else {            //Сохраненные данные уже существующей выбранной привычки
                if let indexPath = indexPath {
                    //меняем цвет названия привычки
                    nameOfHabitField.attributedPlaceholder = NSAttributedString(
                        string: store.habits[indexPath.row - 1].name,
                        attributes: [NSAttributedString.Key.foregroundColor: store.habits[indexPath.row - 1].color]
                    )
                    colorOfHabitView.backgroundColor = store.habits[indexPath.row - 1].color //ранее выбранный цвет
                    //ранее установленное время
                    let dateFormatter: DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm a"
                    timeOfHabitRightPart.text = dateFormatter.string(from: store.habits[indexPath.row - 1].date)
                    datePicker.date = store.habits[indexPath.row - 1].date
                }
            }
        }
    }

    
    //MARK: - METHODs
    private func showBarItems() {
        let leftButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelAction))
        let rightButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.leftBarButtonItem?.tintColor = habitPurpleColor
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.tintColor = habitPurpleColor
    }
    
    //Обработка нажатия левой кнопки NavigationBar - Отмена изменений и закрытие VC
    @objc private func cancelAction() {
        print("Отменяем создание новой привычки!")
        self.dismiss(animated: true)
    }
    
    //Обработка нажатия правой кнопки NavigationBar - Запись данных привычки и закрытие VC
    @objc private func saveAction() {
        print("СОХРАНЯЕМ ПРИВЫЧКУ!")
        let habit = Habit(name: statusText,
                          date: selectedTimeReal,
                          color: newColor ?? .black)
        
        if let isNewHabit = isNewHabit {
            if isNewHabit {
                if let isNameEdited = isNameEdited {
                    if isNameEdited {
                        print("...это новая привычка")
                        store.habits.append(habit)
                        store.save()
                        indexPath = IndexPath(item: store.habits.count, section: 0)
                        self.dismiss(animated: true) {
                            self.delegateNew?.addToHabit(data: habit,
                                                         isNewHabit: self.isNewHabit,
                                                         usingIndex: self.indexPath)
                        }
                    } else {
                        shakeMeBaby(nameOfHabitField)
                    }
                }
            } else {
                print("...это старая привычка")
                if let indexPath = indexPath {
                    if let isNameEdited = isNameEdited {
                        isNameEdited ? store.habits[indexPath.row - 1].name = statusText : print("Имя не изменилось")
                    }
                    if let isColorChoosen = isColorChoosen {
                        isColorChoosen ? store.habits[indexPath.row - 1].color = habit.color : print("Цвет не поменялся")
                    }
                    if let isTimeChoosen = isTimeChoosen {
                        isTimeChoosen ? store.habits[indexPath.row - 1].date = habit.date : print("Дата не изменилась")
                    }
                    store.save()
                    self.dismiss(animated: true) {
                        self.delegate?.addToHabit(data: habit,
                                                  isNewHabit: self.isNewHabit,
                                                  usingIndex: self.indexPath)
                    }
                }
            }
        }
        
    }
    
    //Сохраняем введенное название привычки в переменную statusText
    @objc private func changeNameOfHabit(_ textField: UITextField) {
        if let myText = textField.text {
            isNameEdited = true
            statusText = myText
        }
    }
    
    //анимация появления текста подсказки в поле UITextField
    private func animateTextOnTextField(_ text: String) {
        nameOfHabitField.animate(newText: text, characterDelay: 0.1)
    }
    
    //MARK: - colorPicker func
    @objc func colorPicker(_ sender: UIButton) {
        let colorPickerVC = UIColorPickerViewController()
        //colorPickerVC.modalPresentationStyle = .popover
        //colorPickerVC.modalTransitionStyle = .crossDissolve
        present(colorPickerVC, animated: true)
        colorPickerVC.selectedColor = initialHabitColor
        
        //let popOverVC = colorPickerVC.popoverPresentationController
        //popOverVC?.sourceView = sender
        colorPickerVC.delegate = self
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        //Устанавливаем формат даты
        dateFormatter.dateFormat = "hh:mm"
        //Присваиваем выбранную дату переменным
        selectedTimeReal = sender.date
        selectedTime = dateFormatter.string(from: sender.date)
        isTimeChoosen = true
    }
    
    //Обработка нажатия кнопки "Удалить привычку" с вызовом алерта
    @objc private func tapToRemoveHabit() {
        guard let indexPath = indexPath else { return }
        let message = "Вы хотите удалить привычку \"" + String(1) + "\"?"
        let alert = UIAlertController(title: "Удалить привычку", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Удалить", style: .default) { _ in
            self.dismiss(animated: true) {
                self.delegate?.removeHabit(usingIndex: indexPath)
            }
            print("Удалить")
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) {
            _ in print("Отмена")
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func showHabitItems() {
        [nameOfHabitLabel, nameOfHabitField,
         colorOfHabitLabel, colorOfHabitView,
         timeOfHabitLabel, timeOfHabitLeftPart, timeOfHabitRightPart,
         datePicker, removeHabitButton].forEach { view.addSubview($0) }
        
        let spaceTop: CGFloat = 21
        let spaceOnTheSides: CGFloat = 16
        let spaceBetweenItems: CGFloat = 7
        let spaceBetweenGroups: CGFloat = 15
        
        NSLayoutConstraint.activate([
            //Отображение заголовка "Название"
            nameOfHabitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spaceTop),
            nameOfHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            nameOfHabitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            nameOfHabitLabel.heightAnchor.constraint(equalToConstant: 18),
            
            //Отображение поля для ввода названия привычки
            nameOfHabitField.topAnchor.constraint(equalTo: nameOfHabitLabel.bottomAnchor, constant: spaceBetweenItems),
            nameOfHabitField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            nameOfHabitField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            nameOfHabitField.heightAnchor.constraint(equalToConstant: 22),
            
            //Отображение заголовка "Цвет"
            colorOfHabitLabel.topAnchor.constraint(equalTo: nameOfHabitField.bottomAnchor, constant: spaceBetweenGroups),
            colorOfHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            colorOfHabitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            colorOfHabitLabel.heightAnchor.constraint(equalToConstant: 18),
            
            //Отображение круга с цветом привычки
            colorOfHabitView.topAnchor.constraint(equalTo: colorOfHabitLabel.bottomAnchor, constant: spaceBetweenItems),
            colorOfHabitView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            colorOfHabitView.widthAnchor.constraint(equalToConstant: 30),
            colorOfHabitView.heightAnchor.constraint(equalToConstant: 30),
            
            //Отображение заголовка "Время"
            timeOfHabitLabel.topAnchor.constraint(equalTo: colorOfHabitView.bottomAnchor, constant: spaceBetweenGroups),
            timeOfHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            timeOfHabitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            timeOfHabitLabel.heightAnchor.constraint(equalToConstant: 18),
            
            //Отображение текста "Каждый день в" перед выбранным временем
            timeOfHabitLeftPart.topAnchor.constraint(equalTo: timeOfHabitLabel.bottomAnchor, constant: spaceBetweenItems),
            timeOfHabitLeftPart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            //timeOfHabitLeftPart.widthAnchor.constraint(equalToConstant: 130),
            timeOfHabitLeftPart.heightAnchor.constraint(equalToConstant: 30),
            
            //Отображение выбранного времени
            timeOfHabitRightPart.topAnchor.constraint(equalTo: timeOfHabitLabel.bottomAnchor, constant: spaceBetweenItems),
            timeOfHabitRightPart.leadingAnchor.constraint(equalTo: timeOfHabitLeftPart.trailingAnchor, constant: 0),
            timeOfHabitRightPart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            timeOfHabitRightPart.heightAnchor.constraint(equalToConstant: 30),
            
            //Отображение UIDatePicker
            datePicker.topAnchor.constraint(equalTo: timeOfHabitLeftPart.bottomAnchor, constant: spaceBetweenGroups),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            datePicker.heightAnchor.constraint(equalToConstant: 216),
            
            //Отображение кнопки "Удалить привычку"
            removeHabitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            removeHabitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            removeHabitButton.heightAnchor.constraint(equalToConstant: 60),
            removeHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            ])
    }
}

//MARK: - UIColorPickerViewControllerDelegate
extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorOfHabitView.backgroundColor = viewController.selectedColor
        newColor = viewController.selectedColor
        isColorChoosen = true
    }
}
