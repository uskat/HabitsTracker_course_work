
import UIKit

protocol initDataDelegate: AnyObject {
    var initVC: Habit? { get set }
    var isNewHabit: Bool? { get set }
    var initColor: UIColor? { get set }
    var initTime: Date? { get set }
}

class HabitViewController: UIViewController, initDataDelegate {

    //MARK: - ITEMs
    var initVC: Habit?
    var isNewHabit: Bool?
    var initColor: UIColor?
    var initTime: Date?
    
    private let nameOfHabitLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .black
        $0.text = "Название"
        return $0
    }(UILabel())

    private var nameOfHabitField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = habitBlueColor
        $0.placeholder = "Введите название привычки"
        $0.adjustsFontSizeToFitWidth = true         //уменьшение шрифта, если введенный текст не помещается
        $0.minimumFontSize = 12                     //до какого значения уменьшается шрифт
        $0.tintColor = habitPurpleColor                        //цвет курсора
        //$0.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0) //сдвиг курсора на 5пт в textField (для красоты)
        //$0.addTarget(self, action: #selector(beginToEditStatus), for: .allEditingEvents)
        $0.addTarget(self, action: #selector(changeNameOfHabit), for: .editingChanged)
        //$0.addTarget(self, action: #selector(endToEditStatus), for: .editingDidEnd)
        return $0
    }(UITextField())
    
    private let colorOfHabitLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .black
        $0.text = "Цвет"
        return $0
    }(UILabel())
    
    let colorOfHabitView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        return $0
    }(UIView())
    
    private let timeOfHabitLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .black
        $0.text = "Время"
        return $0
    }(UILabel())
    
    private var timeOfHabitLeftPart: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = false
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .black
        $0.backgroundColor = .clear
        $0.text = "Каждый день в"
        return $0
    }(UITextView())
    
    private var timeOfHabitRightPart: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = habitPurpleColor
        $0.backgroundColor = .clear
        $0.text = "11:00 PM"
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 0, 0)
        return $0
    }(UITextView())
    
    private let datePicker: UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        // Set some of UIDatePicker properties
        $0.timeZone = NSTimeZone.local
        $0.backgroundColor = .systemGray5
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .wheels
        $0.contentHorizontalAlignment = .center
        // Add an event to call onDidChangeDate function when value is changed.
        $0.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        // Add DataPicker to the view
        return $0
    }(UIDatePicker())
    
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
        showBarItems()
        showHabitItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameOfHabitField.animate(newText: "Введите название привычки", characterDelay: 0.1)
        if let isNewHabit = isNewHabit {
            if isNewHabit {
                colorOfHabitView.backgroundColor = initialHabitColor
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm a"
                timeOfHabitRightPart.text = dateFormatter.string(from: initialHabitTime)
            } else {
                title = "Все норм"
                colorOfHabitView.backgroundColor = .green
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //pass.animate(newText: placeHolder(pass), characterDelay: 0.2)
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
    
    @objc private func cancelAction() {
        self.dismiss(animated: true)
    }
    
    // ЗАГЛУШКА. УБРАТЬ
    @objc private func saveAction() {
        print("сохранить?")
        let habitVC = HabitViewController()
        let navBarController = UINavigationController(rootViewController: habitVC)
        navBarController.modalPresentationStyle = .fullScreen
        habitVC.isNewHabit = false
        present(navBarController, animated: true)
    }
    
    @objc private func changeNameOfHabit(_ textField: UITextField) {
        if let myText = textField.text {
            statusText = myText
        }
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "hh:mm"
        // Apply date format
        selectedTimeReal = sender.date
        selectedTime = dateFormatter.string(from: sender.date)
    }
    
    @objc private func tapToRemoveHabit() {
        let message = "Вы хотите удалить привычку \"" + String(1) + "\"?"
        let alert = UIAlertController(title: "Удалить привычку", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Удалить", style: .default) {
            _ in self.dismiss(animated: true)
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
            nameOfHabitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spaceTop),
            nameOfHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            nameOfHabitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            nameOfHabitLabel.heightAnchor.constraint(equalToConstant: 18),
            
            nameOfHabitField.topAnchor.constraint(equalTo: nameOfHabitLabel.bottomAnchor, constant: spaceBetweenItems),
            nameOfHabitField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            nameOfHabitField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            nameOfHabitField.heightAnchor.constraint(equalToConstant: 22),
            
            colorOfHabitLabel.topAnchor.constraint(equalTo: nameOfHabitField.bottomAnchor, constant: spaceBetweenGroups),
            colorOfHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            colorOfHabitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            colorOfHabitLabel.heightAnchor.constraint(equalToConstant: 18),
            
            colorOfHabitView.topAnchor.constraint(equalTo: colorOfHabitLabel.bottomAnchor, constant: spaceBetweenItems),
            colorOfHabitView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            colorOfHabitView.widthAnchor.constraint(equalToConstant: 30),
            colorOfHabitView.heightAnchor.constraint(equalToConstant: 30),
            
            timeOfHabitLabel.topAnchor.constraint(equalTo: colorOfHabitView.bottomAnchor, constant: spaceBetweenGroups),
            timeOfHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            timeOfHabitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            timeOfHabitLabel.heightAnchor.constraint(equalToConstant: 18),
            
            timeOfHabitLeftPart.topAnchor.constraint(equalTo: timeOfHabitLabel.bottomAnchor, constant: spaceBetweenItems),
            timeOfHabitLeftPart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            //timeOfHabitLeftPart.widthAnchor.constraint(equalToConstant: 130),
            timeOfHabitLeftPart.heightAnchor.constraint(equalToConstant: 30),
            
            timeOfHabitRightPart.topAnchor.constraint(equalTo: timeOfHabitLabel.bottomAnchor, constant: spaceBetweenItems),
            timeOfHabitRightPart.leadingAnchor.constraint(equalTo: timeOfHabitLeftPart.trailingAnchor, constant: 0),
            timeOfHabitRightPart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            timeOfHabitRightPart.heightAnchor.constraint(equalToConstant: 30),
            
            datePicker.topAnchor.constraint(equalTo: timeOfHabitLeftPart.bottomAnchor, constant: spaceBetweenGroups),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spaceOnTheSides),
            datePicker.heightAnchor.constraint(equalToConstant: 216),
            
            removeHabitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            removeHabitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            removeHabitButton.heightAnchor.constraint(equalToConstant: 60),
            removeHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            ])
    }
}
