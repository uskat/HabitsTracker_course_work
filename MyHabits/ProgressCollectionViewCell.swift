
import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    
    private var todayProgressMainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemPink
        return $0
    }(UIView())
    
    private var todayStatusLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Все получится!"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .systemGray
        return $0
    }(UILabel())
    
    private var todayPercent: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .systemGray
        return $0
    }(UILabel())
    
    private var todayProgressBarBackground: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(rgb: 0xD8D8D8)
        return $0
    }(UIView())
    
    private var todayProgressBarForeground: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 5
        $0.backgroundColor = habitPurpleColor
        return $0
    }(UIView())
    
    
    //MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        showItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - METHODs
    func showItems() {
        addSubview(todayProgressMainView)
        [todayProgressMainView, todayStatusLabel, todayPercent,
        todayProgressBarBackground, todayProgressBarForeground].forEach { todayProgressMainView.addSubview($0) }
       
        NSLayoutConstraint.activate([
            todayProgressMainView.topAnchor.constraint(equalTo: topAnchor),
            todayProgressMainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            todayProgressMainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            todayProgressMainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            todayPercent.topAnchor.constraint(equalTo: todayProgressMainView.topAnchor, constant: 10),
            todayPercent.widthAnchor.constraint(equalToConstant: 95),
            todayPercent.trailingAnchor.constraint(equalTo: todayProgressMainView.trailingAnchor, constant: -12),
            todayPercent.heightAnchor.constraint(equalToConstant: 18),
            
            todayStatusLabel.topAnchor.constraint(equalTo: todayProgressMainView.topAnchor, constant: 10),
            todayStatusLabel.leadingAnchor.constraint(equalTo: todayProgressMainView.leadingAnchor, constant: 12),
            todayStatusLabel.trailingAnchor.constraint(equalTo: todayPercent.leadingAnchor),
            todayStatusLabel.heightAnchor.constraint(equalToConstant: 18),
            
            todayProgressBarBackground.topAnchor.constraint(equalTo: todayProgressMainView.topAnchor, constant: 38),
            todayProgressBarBackground.leadingAnchor.constraint(equalTo: todayProgressMainView.leadingAnchor, constant: 12),
            todayProgressBarBackground.trailingAnchor.constraint(equalTo: todayProgressMainView.trailingAnchor, constant: -12),
            todayProgressBarBackground.heightAnchor.constraint(equalToConstant: 7),
            
            todayProgressBarForeground.topAnchor.constraint(equalTo: todayProgressMainView.topAnchor, constant: 38),
            todayProgressBarForeground.leadingAnchor.constraint(equalTo: todayProgressMainView.leadingAnchor, constant: 12),
            todayProgressBarForeground.trailingAnchor.constraint(equalTo: todayProgressMainView.trailingAnchor, constant: -52),
            todayProgressBarForeground.heightAnchor.constraint(equalToConstant: 7),
            ])
    }
    
    func setupCell(_ progress: Float) {
        todayPercent.text = "\(progress)%"
    }
}
