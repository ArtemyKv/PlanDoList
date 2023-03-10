//
//  DatePickerCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

protocol DatePickerCellDelegate: AnyObject {
    func datePickerValueChanged(in cell: DatePickerCell, date: Date)
}

class DatePickerCell: UITableViewCell {
    weak var delegate: DatePickerCellDelegate?
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = .current
        datePicker.minuteInterval = 1
        return datePicker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc private func datePickerValueChanged() {
        delegate?.datePickerValueChanged(in: self, date: datePicker.date)
    }
}
