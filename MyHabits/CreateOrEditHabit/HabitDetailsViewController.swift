
import UIKit

protocol HabitDetailsViewControllerDelegate: AnyObject {
    func removeHabit(usingIndex indexPath: IndexPath)
    func addToHabit(data habit: Habit, isNewHabit: Bool?, usingIndex indexPath: IndexPath?)
}

class HabitDetailsViewController: UIViewController {

    var habit: Habit?
    var indexPath: IndexPath?
    let store = HabitsStore.shared
    weak var delegate: HabitDetailsViewControllerDelegate?
    
    //Общее вью серого цвета с рамкой
    private var mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = HabitColor.background
        $0.layer.borderColor = HabitColor.separator.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIView())

    //Заголовок
    private var activityLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = HabitColor.activityLabel
        $0.text = "АКТИВНОСТЬ"
        return $0
    }(UILabel())

    //Таблица дат
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(HabitDetailsTableViewCell.self, forCellReuseIdentifier: HabitDetailsTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    
    //MARK: - INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = HabitColor.purple
        //назначаем заголовку переданное из другого контроллера имя
        if let habit = habit {
            title = habit.name
        }
        showBarItems()
        showHabitTable()
    }


    //MARK: - METHODs
    //переименовываем и перекрашиваем правую кнопку в NavigationBar
    private func showBarItems() {
        let rightButton = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editHabit))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.tintColor = HabitColor.purple
    }
    
    @objc private func editHabit() {
        let habitVC = HabitViewController()
        habitVC.delegate = self
        habitVC.isNewHabit = false
        habitVC.indexPath = indexPath
        let vc = UINavigationController(rootViewController: habitVC)
        habitVC.title = "Править"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func showHabitTable() {
        view.addSubview(mainView)
        [activityLabel, tableView].forEach { mainView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            //Отображение общей вью с рамкой
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            //Отображение заголовка Активность
            activityLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 22),
            activityLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            activityLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            activityLabel.heightAnchor.constraint(equalToConstant: 18),
            
            //Отображение таблицы дат
            tableView.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 7),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
        ])
    }
}

//MARK: UITableViewDataSource
extension HabitDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("количество строк \(store.dates.count)")
        return store.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitDetailsTableViewCell.identifier, for: indexPath) as! HabitDetailsTableViewCell
        
        if let habit = habit {
            //Была ли затрекана привычка на выбранную дату?
            let isDateChecked = store.habit(habit, isTrackedIn: store.dates[store.dates.count - 1 - indexPath.row])
            //передаем в ячейку таблицы дату и инфо, была ли в этот день затрекана привычка
            cell.setupCell(on: store.dates[store.dates.count - 1 - indexPath.row], withMarker: isDateChecked)
        }
        return cell
    }
}

//MARK: высота ячейки в таблице.
extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44  //высота ячейки таблицы, согласно макета
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension HabitDetailsViewController: HabitViewControllerDelegate {
    func removeHabit(usingIndex indexPath: IndexPath) {
        self.navigationController?.popToRootViewController(animated: true)
        self.delegate?.removeHabit(usingIndex: indexPath)
    }
    
    func addToHabit(data habit: Habit, isNewHabit: Bool?, usingIndex indexPath: IndexPath?) {
        self.navigationController?.popToRootViewController(animated: true)
        self.delegate?.addToHabit(data: habit, isNewHabit: isNewHabit, usingIndex: indexPath)
    }
}
