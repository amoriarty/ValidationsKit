//
//  RegistrationCell.swift
//  ValidationKitDemo
//
//  Created by Alex Legent on 13/03/2019.
//

import UIKit

final class RegistrationCell: UITableViewCell {

    let field: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(field)
        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            field.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
