
import UIKit

protocol HabitsStoreDelegate: AnyObject {
    func reload()
    func addToHabit(data habit: Habit, isNewHabit: Bool?, usingIndex indexPath: IndexPath?)
}

class HabitsViewController: UIViewController {

    //MARK: - ITEMs
    let store = HabitsStore.shared
    let progress = HabitsStore.shared.todayProgress
    
    //Кнопка "+" в NavigationBar (для добавления новой привычки)
    private lazy var navigationBarButton: UIBarButtonItem = {
        return $0
    }(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddHabbit)))
    
    //основное view под коллекцию привычек
    private var mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = HabitColor.background
        $0.layer.borderColor = HabitColor.separator.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIView())
    
    //Коллекция (закомментирован код для создания хедера коллекции)
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
           //(ProgressCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProgressCollectionViewCell.identifier)
        collection.register(HabitsCollectionViewCell.self, forCellWithReuseIdentifier: HabitsCollectionViewCell.identifier)
        return collection
    }()
  
    
    //MARK: - INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = HabitColor.background
        addNavigationBarButton()
        showItems()
        print("П,оехали!")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Сегодня", style: .plain, target: nil, action: nil)
    }

    
    //MARK: - METHODs
    private func addNavigationBarButton() {
        navigationItem.rightBarButtonItem = navigationBarButton
    }
    
    @objc private func tapAddHabbit() {
        let habitVC = HabitViewController()
        let habitDetailsVC = HabitDetailsViewController()
        let navBarController = UINavigationController(rootViewController: habitVC)
        navBarController.modalPresentationStyle = .fullScreen   ///принудительное отображение модального окна в полный экран
        habitDetailsVC.delegate = self
        habitVC.delegateNew = self   ///делегат для обработки отображения новой привычки
        habitVC.title = "Создать"
        habitVC.isNewHabit = true
        habitVC.removeHabitButton.isHidden = true
        present(navBarController, animated: true)
    }
    
    //Обновление констрейнтов (используется при обработке нажатия на кнопку изменения Статуса привычки)
    internal func reload() {
        let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ProgressCollectionViewCell
        cell?.updateProgress()
        //cell?.layoutIfNeeded()
    }
    
    private func showItems() {
        view.addSubview(mainView)
        mainView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: mainView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
            ])
    }
}

//MARK: - UICollectionViewDataSource
extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        store.habits.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let header = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
            header.setupCell(progress)
            return header
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitsCollectionViewCell.identifier, for: indexPath) as! HabitsCollectionViewCell
            cell.setupCell(store.habits[indexPath.row - 1])
            cell.indexPath = indexPath
            cell.habit = store.habits[indexPath.row - 1]
            cell.delegate = self
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    //Код для хедера коллекции привычек.
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60) //add your height here
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
            header.frame = CGRect(x: 0 , y: 0, width: collectionView.frame.width, height: 60)
            header.setupCell(progress)
            return header
        default:  fatalError("Unexpected element kind")
        }
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            //задаем ширину ячейки: ширина экрана минус 2 отступа с каждой стороны
            return CGSize(width: Size.screenX - 2 * Size.habitsSpace, height: 60)
        } else {
            return CGSize(width: Size.screenX - 2 * Size.habitsSpace, height: 130)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Size.habitsItemsSpace   ///расстояние между ячейками в коллекции
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Size.habitsSpaceTop, left: 0,
                     bottom: Size.habitsSpaceTop, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("Прогресс. Что в нём смотреть?!")
        } else {
            print("Посмотреть детали привычки?")
            let habitVCell = HabitDetailsTableViewCell()
            let habitDetailVC = HabitDetailsViewController()
            habitDetailVC.delegate = self
            habitVCell.indexPath = indexPath
            habitDetailVC.indexPath = indexPath
            habitDetailVC.habit = store.habits[indexPath.row - 1]
            navigationController?.pushViewController(habitDetailVC, animated: true)
        }
    }
}

extension HabitsViewController: HabitDetailsViewControllerDelegate, HabitsStoreDelegate {
    //удаляем ячейку с выбранной привычкой с экрана
    func removeHabit(usingIndex indexPath: IndexPath) {
        print("index при удалении \(indexPath)")
        self.store.habits.remove(at: indexPath.row - 1)
        self.collectionView.performBatchUpdates {
            self.collectionView.deleteItems(at: [indexPath])
            self.collectionView.reloadData()
            self.reload()
        }
    }
    
    //добавляем ячейку с новой привычкой на экран
    func addToHabit(data habit: Habit, isNewHabit: Bool?, usingIndex indexPath: IndexPath?) {
        if let isNewHabit = isNewHabit {
            if isNewHabit {
                self.collectionView.performBatchUpdates {
                    if let indexPath = indexPath {
                        print("index при добавлении \(indexPath)")
                        self.collectionView.insertItems(at: [indexPath])
                        self.reload()
                    }
                }
            }
        }
    }
}
