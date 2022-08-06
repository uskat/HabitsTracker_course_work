
import UIKit

class HabitsViewController: UIViewController {

    
    let listOfHabits = HabitsStore.shared.habits
 
    private lazy var navigationBarButton: UIBarButtonItem = {
        return $0
    }(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddHabbit)))

    private var todayLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        $0.backgroundColor = colorOfNavBar
        $0.text = "Сегодня"
        return $0
    }(UILabel())
    
    private var mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .yellow //UIColor(rgb: 0xF2F2F7)
        $0.layer.borderColor = colorOfSeparator.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIView())
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .red
        collection.dataSource = self
        collection.delegate = self
        collection.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        collection.register(HabitsCollectionViewCell.self, forCellWithReuseIdentifier: HabitsCollectionViewCell.identifier)
        return collection
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColorOfHabitsVC
        addNavigationBarButton()
        showItems()
    }


    private func addNavigationBarButton() {
        navigationItem.rightBarButtonItem = navigationBarButton
    }
    
    @objc private func tapAddHabbit() {
        let habitVC = HabitViewController()
        let navBarController = UINavigationController(rootViewController: habitVC)
        navBarController.modalPresentationStyle = .fullScreen
        habitVC.title = "Создать"
        habitVC.isNewHabit = true
        habitVC.removeHabitButton.isHidden = true
        present(navBarController, animated: true)
    }
    
    private func showItems() {
        [todayLabel, mainView].forEach { view.addSubview($0) }
        mainView.addSubview(collectionView)

        let spaceOnTheSides: CGFloat = 14
        
        NSLayoutConstraint.activate([
            todayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spaceOnTheSides),
            todayLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            todayLabel.heightAnchor.constraint(equalToConstant: 52),
            
            mainView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
            ])
    }
    
}

//MARK: - UICollectionViewDataSource
extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10//photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            //let progress = HabitsStore.shared.todayProgress
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
            //cell.setupCell(progress)
            return cell
        } else {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitsCollectionViewCell.identifier, for: indexPath) as! HabitsCollectionViewCell
            //listOfHabits[indexPath]
            //cell.setupCell(listOfHabits[indexPath])
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    private var inSpace: CGFloat { return 12 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (300 - 2 * inSpace)
        return CGSize(width: width, height: 50)
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
        //let image = photos[indexPath.row].imageName
        //showViewWithPhotoOnTap(image)
    }
}
