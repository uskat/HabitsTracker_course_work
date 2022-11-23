
import UIKit

class InfoViewController: UIViewController {

    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 1
        $0.layer.borderColor = HabitColor.separator.cgColor
        $0.separatorColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .white
        $0.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    
    //MARK: - INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        show()
    }


    //MARK: - METHODs
    func show() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
}

//MARK: - UITableViewDataSource
extension InfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Отображение ячейки таблицы. Первая ячейка другим шрифтом
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
            cell.setupCell(infoPost[indexPath.row], true)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
            cell.setupCell(infoPost[indexPath.row], false)
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

