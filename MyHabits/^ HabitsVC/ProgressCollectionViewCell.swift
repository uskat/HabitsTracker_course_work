
import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    let store = HabitsStore.shared
    weak var delegate: HabitsStoreDelegate?
    
    //MARK: - ITEMs
    //UIView ячейки прогресса за день
    private var todayProgressMainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        return $0
    }(UIView())
    
    //Заголовок
    private var todayStatusLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Все получится!"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .systemGray
        return $0
    }(UILabel())
    
    //Отображение процента выполнения привычек за день в числовом виде
    private var todayPercent: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .systemGray
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    //Графическое отображение прогресса выполнения привычек за день
    private var todayProgressBarBackground: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(rgb: 0xD8D8D8)
        return $0
    }(UIView())
    
    //(см.выше)
    private var todayProgressBarForeground: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 5
        $0.backgroundColor = habitPurpleColor
        return $0
    }(UIView())
    
    
    //MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        showItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - METHODs
    func showItems() {
        contentView.addSubview(todayProgressMainView)
        [todayStatusLabel, todayPercent,
        todayProgressBarBackground, todayProgressBarForeground].forEach { todayProgressMainView.addSubview($0) }
        
        let spaceOnTheSides: CGFloat = spaceOnTheSidesOfProgressViewCell
        
        NSLayoutConstraint.activate([
            //Общая UIView ячейки прогресса
            todayProgressMainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            todayProgressMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            todayProgressMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            todayProgressMainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //Отображение поля с числовым значением процента выполнения привычек за день
            todayPercent.topAnchor.constraint(equalTo: todayProgressMainView.topAnchor, constant: 10),
            todayPercent.widthAnchor.constraint(equalToConstant: 50),
            todayPercent.trailingAnchor.constraint(equalTo: todayProgressMainView.trailingAnchor, constant: -spaceOnTheSides),
            todayPercent.heightAnchor.constraint(equalToConstant: 18),
            
            //Отображение заголовка "Все получится!"
            todayStatusLabel.topAnchor.constraint(equalTo: todayProgressMainView.topAnchor, constant: 10),
            todayStatusLabel.leadingAnchor.constraint(equalTo: todayProgressMainView.leadingAnchor, constant: spaceOnTheSides),
            todayStatusLabel.trailingAnchor.constraint(equalTo: todayPercent.leadingAnchor),
            todayStatusLabel.heightAnchor.constraint(equalToConstant: 18),
            
            //графическое отображение прогресса выполнения привычек за день
            todayProgressBarBackground.topAnchor.constraint(equalTo: todayProgressMainView.topAnchor, constant: 38),
            todayProgressBarBackground.leadingAnchor.constraint(equalTo: todayProgressMainView.leadingAnchor, constant: spaceOnTheSides),
            todayProgressBarBackground.trailingAnchor.constraint(equalTo: todayProgressMainView.trailingAnchor, constant: -spaceOnTheSides),
            todayProgressBarBackground.heightAnchor.constraint(equalToConstant: 7),
            
            todayProgressBarForeground.topAnchor.constraint(equalTo: todayProgressMainView.topAnchor, constant: 38),
            todayProgressBarForeground.leadingAnchor.constraint(equalTo: todayProgressMainView.leadingAnchor, constant: spaceOnTheSides),
            todayProgressBarForeground.trailingAnchor.constraint(equalTo: todayProgressMainView.trailingAnchor, constant: -spaceOnTheSides - progressLength * (1.0 - Double(store.todayProgress))),
            todayProgressBarForeground.heightAnchor.constraint(equalToConstant: 7),
            ])
    }
    
    func setupCell(_ progress: Float) {
        todayPercent.text = "\(Int(store.todayProgress * 100))%"
    }
}
