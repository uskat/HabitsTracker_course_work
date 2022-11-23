
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
    var indexPath: IndexPath?
    let store = HabitsStore.shared
    weak var delegate: HabitViewControllerDelegate?
    weak var delegateNew: HabitDetailsViewControllerDelegate?

    
    //MARK: - ITEMs
    private let scrollHabitView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        return $0
    }(UIScrollView())
    
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
        $0.textColor = HabitColor.blue
        $0.placeholder = "Введите название привычки"
        $0.adjustsFontSizeToFitWidth = true         ///уменьшение шрифта, если введенный текст не помещается
        $0.minimumFontSize = 12                     ///до какого значения уменьшается шрифт
        $0.tintColor = HabitColor.purple
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
        $0.textColor = HabitColor.purple
        $0.backgroundColor = .clear
        $0.text = "11:00 PM"
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 0, 0)
        return $0
    }(UITextView())
    
    //Выбор времени привычки
    private lazy var datePicker: UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.timeZone = NSTimeZone.local
        $0.frame = CGRectMake(0, 200, 310, 206)
        //$0.backgroundColor = .systemGray5
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
                newColor = HabitColor.initial
                statusText = "Введите название привычки"
                colorOfHabitView.backgroundColor = HabitColor.initial ///цвет привычки по умолчанию (см.файл Constants)
                let dateFormatter: DateFormatter = DateFormatter()   ///время привычки по умолчанию (см.файл Constants)
                dateFormatter.dateFormat = "HH:mm a"
                timeOfHabitRightPart.text = dateFormatter.string(from: initialHabitTime)
            } else {            ///Сохраненные данные уже существующей выбранной привычки
                if let indexPath = indexPath {
                    //меняем цвет названия привычки
                    nameOfHabitField.attributedPlaceholder = NSAttributedString(
                        string: store.habits[indexPath.row - 1].name,
                        attributes: [NSAttributedString.Key.foregroundColor: store.habits[indexPath.row - 1].color]
                    )
                    colorOfHabitView.backgroundColor = store.habits[indexPath.row - 1].color ///ранее выбранный цвет
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
    //Метод вызывается, когда пользователь кликает на view за пределами TextField (убирает клавиатуру)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    private func showBarItems() {
        let leftButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelAction))
        let rightButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.leftBarButtonItem?.tintColor = HabitColor.purple
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.tintColor = HabitColor.purple
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
                        shakeText(nameOfHabitField)
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
    
    //Трясем текст в выбранном UITextField
    public func shakeText(_ shakedItem: UITextField) {
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
    
    //Сохраняем введенное название привычки в переменную statusText
    @objc private func changeNameOfHabit(_ textField: UITextField) {
        if let myText = textField.text {
            isNameEdited = true
            statusText = myText
        }
    }

    
    //MARK: - colorPicker func
    @objc func colorPicker(_ sender: UIButton) {
        let colorPickerVC = UIColorPickerViewController()
        //colorPickerVC.modalPresentationStyle = .popover
        //colorPickerVC.modalTransitionStyle = .crossDissolve
        present(colorPickerVC, animated: true)
        colorPickerVC.selectedColor = HabitColor.initial
        
        //let popOverVC = colorPickerVC.popoverPresentationController
        //popOverVC?.sourceView = sender
        colorPickerVC.delegate = self
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()   // Create date formatter
        dateFormatter.dateFormat = "hh:mm"   //Устанавливаем формат даты
        //Присваиваем выбранную дату переменным
        selectedTimeReal = sender.date
        selectedTime = dateFormatter.string(from: sender.date)
        isTimeChoosen = true
    }
    
    //Обработка нажатия кнопки "Удалить привычку" с вызовом алерта
    @objc private func tapToRemoveHabit() {
        guard let indexPath = indexPath else { return }
        let message = "Вы хотите удалить привычку \"" + String(store.habits[indexPath.row - 1].name) + "\"?"
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
        
        NSLayoutConstraint.activate([
            //Отображение заголовка "Название"
            nameOfHabitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Size.habitSpaceTop),
            nameOfHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Size.habitSpace),
            nameOfHabitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Size.habitSpace),
            nameOfHabitLabel.heightAnchor.constraint(equalToConstant: 18),
            
            //Отображение поля для ввода названия привычки
            nameOfHabitField.topAnchor.constraint(equalTo: nameOfHabitLabel.bottomAnchor, constant: Size.habitItemsSpace),
            nameOfHabitField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Size.habitSpace),
            nameOfHabitField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Size.habitSpace),
            nameOfHabitField.heightAnchor.constraint(equalToConstant: 22),
            
            //Отображение заголовка "Цвет"
            colorOfHabitLabel.topAnchor.constraint(equalTo: nameOfHabitField.bottomAnchor, constant: Size.habitGroupsSpace),
            colorOfHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Size.habitSpace),
            colorOfHabitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Size.habitSpace),
            colorOfHabitLabel.heightAnchor.constraint(equalToConstant: 18),
            
            //Отображение круга с цветом привычки
            colorOfHabitView.topAnchor.constraint(equalTo: colorOfHabitLabel.bottomAnchor, constant: Size.habitItemsSpace),
            colorOfHabitView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Size.habitSpace),
            colorOfHabitView.widthAnchor.constraint(equalToConstant: 30),
            colorOfHabitView.heightAnchor.constraint(equalToConstant: 30),
            
            //Отображение заголовка "Время"
            timeOfHabitLabel.topAnchor.constraint(equalTo: colorOfHabitView.bottomAnchor, constant: Size.habitGroupsSpace),
            timeOfHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Size.habitSpace),
            timeOfHabitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Size.habitSpace),
            timeOfHabitLabel.heightAnchor.constraint(equalToConstant: 18),
            
            //Отображение текста "Каждый день в" перед выбранным временем
            timeOfHabitLeftPart.topAnchor.constraint(equalTo: timeOfHabitLabel.bottomAnchor, constant: Size.habitItemsSpace),
            timeOfHabitLeftPart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Size.habitSpace),
            //timeOfHabitLeftPart.widthAnchor.constraint(equalToConstant: 130),
            timeOfHabitLeftPart.heightAnchor.constraint(equalToConstant: 30),
            
            //Отображение выбранного времени
            timeOfHabitRightPart.topAnchor.constraint(equalTo: timeOfHabitLabel.bottomAnchor, constant: Size.habitItemsSpace),
            timeOfHabitRightPart.leadingAnchor.constraint(equalTo: timeOfHabitLeftPart.trailingAnchor, constant: 0),
            timeOfHabitRightPart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Size.habitSpace),
            timeOfHabitRightPart.heightAnchor.constraint(equalToConstant: 30),
            
            //Отображение UIDatePicker
            datePicker.topAnchor.constraint(equalTo: timeOfHabitLeftPart.bottomAnchor, constant: Size.habitGroupsSpace),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Size.habitSpace),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Size.habitSpace),
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
