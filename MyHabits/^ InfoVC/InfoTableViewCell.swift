
import UIKit

class InfoTableViewCell: UITableViewCell {

    //абзац описания привычки
    private var habitsDescription: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.isEditable = false
        $0.isScrollEnabled = false
        return $0
    }(UITextView())
    
    
    //MARK: - INITs
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        showItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - METHODs
    func showItems() {
        contentView.addSubview(habitsDescription)
        
        NSLayoutConstraint.activate([
            habitsDescription.topAnchor.constraint(equalTo: contentView.topAnchor),
            habitsDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitsDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -16),
            habitsDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
    
    func setupCell(_ text: String, _ isFirst: Bool) {
        habitsDescription.text = text
        
        //проверяем, является ли абзац первым. Если да, то меняем шрифт
        if isFirst {
            habitsDescription.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        } else {
            habitsDescription.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
    }
}
