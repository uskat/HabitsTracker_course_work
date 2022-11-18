
import UIKit

class HabitDetailsTableViewCell: UITableViewCell {

    var indexPath: IndexPath?
    //weak var delegate: HabitsStoreDelegate?
    
    //MARK: - ITEMs
    //ячейка с датой
    private var habitDateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return $0
    }(UILabel())
    
    //поле для отметки, в том случае, если привычка была выполнена
    private var habitDateIsChecked: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .center
        $0.tintColor = HabitColor.purple
        $0.image = UIImage(systemName: "checkmark")
        return $0
    }(UIImageView())

    
    //MARK: - INITs
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        showItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - METHODs
    private func showItems() {
        [habitDateLabel, habitDateIsChecked].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            habitDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            habitDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            habitDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            habitDateIsChecked.topAnchor.constraint(equalTo: habitDateLabel.topAnchor),
            habitDateIsChecked.leadingAnchor.constraint(equalTo: habitDateLabel.trailingAnchor),
            habitDateIsChecked.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            habitDateIsChecked.bottomAnchor.constraint(equalTo: habitDateLabel.bottomAnchor),
            ])
    }
    
    func setupCell(on date: Date, withMarker isDateChecked: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        //заменяем некоторые даты на их словесные значения
        switch dateFormatter.string(from: date) {
            case dateFormatter.string(from: Date()):                    habitDateLabel.text = "Сегодня"
            case dateFormatter.string(from: Date() - (60*60*24)):       habitDateLabel.text = "Вчера"
            case dateFormatter.string(from: Date() - (60*60*24) * 2):   habitDateLabel.text = "Позавчера"
            default:                                                    habitDateLabel.text = dateFormatter.string(from: date)
        }
        //отображение символа "checkmark" для выполненных привычек
        if isDateChecked {
            habitDateIsChecked.isHidden = false
        } else {
            habitDateIsChecked.isHidden = true
        }
    }
}
