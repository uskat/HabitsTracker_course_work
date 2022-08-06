
import UIKit

class HabitsCollectionViewCell: UICollectionViewCell {
    
    var index: IndexPath?
    
    private let statusOfHabitView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .orange
        $0.layer.cornerRadius = 20
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        showItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func showItems() {
        [statusOfHabitView, ].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            statusOfHabitView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            statusOfHabitView.widthAnchor.constraint(equalToConstant: 40),
            statusOfHabitView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            statusOfHabitView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            ])
    }
    
    func setupCell(_ color: UIColor) {
        //statusOfHabitView.backgroundColor = HabitsStore.shared.habits
    }
}
