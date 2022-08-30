
import UIKit

protocol HabitsStoreDelegate: AnyObject {
    func reload()
}

class HabitsViewController: UIViewController, HabitsStoreDelegate {

    //MARK: - ITEMs
    let store = HabitsStore.shared
    let progress = HabitsStore.shared.todayProgress
 
    private lazy var navigationBarButton: UIBarButtonItem = {
        return $0
    }(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddHabbit)))

    private var todayLabelView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = colorOfNavBar
        return $0
    }(UIView())
    
    private var todayLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        $0.backgroundColor = colorOfNavBar
        $0.text = "Сегодня"
        return $0
    }(UILabel())
    
    private var mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = backgroundColorOfHabitsVC
        $0.layer.borderColor = colorOfSeparator.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIView())
    
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
        view.backgroundColor = backgroundColorOfHabitsVC
        addNavigationBarButton()
        showItems()
        print("П,оехали!")
    }

//    override func viewWillAppear(_ animated: Bool) {
//        reload()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Сегодня", style: .plain, target: nil, action: nil)
    }

    
    //MARK: - METHODs
    private func addNavigationBarButton() {
        navigationItem.rightBarButtonItem = navigationBarButton
    }
    
    @objc private func tapAddHabbit() {
        let habitVC = HabitViewController()
        let navBarController = UINavigationController(rootViewController: habitVC)
        navBarController.modalPresentationStyle = .fullScreen
        habitVC.delegateHabits = self
        habitVC.title = "Создать"
        habitVC.isNewHabit = true
        habitVC.removeHabitButton.isHidden = true
        present(navBarController, animated: true)
    }
    
    internal func reload() {
        self.collectionView.reloadData()
        self.view.layoutIfNeeded()
        self.collectionView.layoutIfNeeded()
        collectionView.setNeedsLayout()
    }

    private func showItems() {
        [todayLabelView, todayLabel, mainView].forEach { view.addSubview($0) }
        mainView.addSubview(collectionView)

        let spaceOnTheSides: CGFloat = 14
        
        NSLayoutConstraint.activate([
            todayLabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todayLabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            todayLabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            todayLabelView.heightAnchor.constraint(equalToConstant: 52),
        
            todayLabel.leadingAnchor.constraint(equalTo: todayLabelView.leadingAnchor, constant: spaceOnTheSides),
            todayLabel.trailingAnchor.constraint(equalTo: todayLabelView.trailingAnchor, constant: -spaceOnTheSides),
            todayLabel.heightAnchor.constraint(equalToConstant: 40),
            todayLabel.bottomAnchor.constraint(equalTo: todayLabelView.bottomAnchor, constant: -8),
            
            mainView.topAnchor.constraint(equalTo: todayLabelView.bottomAnchor),
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
            header.delegate = self
            return header
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitsCollectionViewCell.identifier, for: indexPath) as! HabitsCollectionViewCell
            cell.setupCell(store.habits[indexPath.row - 1])
            cell.index = indexPath
            cell.habit = store.habits[indexPath.row - 1]
            cell.delegate = self
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    private var inSpace: CGFloat { return 12 } //расстояние между ячейками в коллекции
    private var outSpaceOntheSides: CGFloat { return spaceOnTheSidesOfHabitsVC } //отступ справа/слева между ячейкой и краем экрана
    
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
            return CGSize(width: screenWidth - 2 * outSpaceOntheSides, height: 60)
        } else {
            return CGSize(width: screenWidth - 2 * outSpaceOntheSides, height: 130)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        inSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        inSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: inSpace, left: inSpace, bottom: inSpace, right: inSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("Прогресс. Что в нём смотреть?!")
        } else {
            print("Посмотреть детали привычки?")
            let habitVCell = HabitDetailsTableViewCell()
            let habitDetailVC = HabitDetailsViewController()
            habitVCell.index = indexPath
            habitDetailVC.index = indexPath
            habitDetailVC.habit = store.habits[indexPath.row - 1]
            navigationController?.pushViewController(habitDetailVC, animated: true)

        }
    }
}
