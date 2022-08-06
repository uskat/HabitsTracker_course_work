
import UIKit

class HabitDetailsViewController: UIViewController {

    var titleVC: Habit?

    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(HabitDetailsTableViewCell.self, forCellReuseIdentifier: HabitDetailsTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let titleVC = titleVC {
            title = titleVC.name
        }
        showBarItems()
        showHabitTable()
    }


    private func showBarItems() {
        //let leftButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(tapBack))
        let rightButton = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(tapAction))
        //navigationItem.leftBarButtonItem = leftButton
        //navigationItem.leftBarButtonItem?.tintColor = habitPurpleColor
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.tintColor = habitPurpleColor

    }

    /*@objc private func tapBack() {
        print("NavBar tapped")
        _ = navigationController?.popToRootViewController(animated: true)
    }*/
    
    @objc private func tapAction() {
        let forthVC = InfoViewController()
        present(forthVC, animated: true)
    }
    
    private func showHabitTable() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: UITableViewDataSource
extension HabitDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //photos.count
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitDetailsTableViewCell.identifier, for: indexPath) as! HabitDetailsTableViewCell
        //let photo = photos[indexPath.item]
        //cell.unsplashPhoto = photo
        return cell
    }
}

//MARK: высота ячейки в таблице.
extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height / 6
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let image = photos[indexPath.row]
        //showViewWithPhotoOnTap(image)
    }
}
