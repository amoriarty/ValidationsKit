//
//  RegistrationController.swift
//  ValidationKitDemo
//
//  Created by Alex Legent on 13/03/2019.
//

import UIKit

final class RegistrationController: UITableViewController {
    private let fieldCell = "registrationCell"
    private let buttonCell = "buttonCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
        tableView.register(RegistrationCell.self, forCellReuseIdentifier: fieldCell)
        tableView.register(RegistrationButton.self, forCellReuseIdentifier: buttonCell)
        tableView.tableFooterView = UIView()
    }

}

// MARK:- Table View Datasource

extension RegistrationController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegistrationField.allCases.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < RegistrationField.allCases.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: buttonCell, for: indexPath) as! RegistrationButton
            cell.button.removeTarget(self, action: nil, for: .touchUpInside)
            cell.button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: fieldCell, for: indexPath) as! RegistrationCell
        let field = RegistrationField.allCases[indexPath.row]
        cell.field.tag = field.rawValue
        cell.field.placeholder = field.placeholder
        cell.field.textContentType = field.textContentType
        cell.field.keyboardType = field.keyboardType
        cell.field.isSecureTextEntry = field.isSecureEntry
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

// MARK:- Button Handler

extension RegistrationController {

    @objc private func handleRegistration() {
        let fields = RegistrationField.allCases.map { field -> UITextField in
            let cell = tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as! RegistrationCell
            return cell.field
        }

        let website = !fields[RegistrationField.website.rawValue].text!.isEmpty ? fields[RegistrationField.website.rawValue].text : nil
        let user = RegistrationUser(username: fields[RegistrationField.username.rawValue].text ?? "",
                                    password: fields[RegistrationField.password.rawValue].text ?? "",
                                    mail: fields[RegistrationField.mail.rawValue].text ?? "",
                                    website: website)

        do {
            try user.validate()
            let controller = SuccessController()
            navigationController?.pushViewController(controller, animated: true)
        }
        catch {
            let controller = UIAlertController(title: "Validation Error", message: "\(error)", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            controller.addAction(dismiss)
            navigationController?.present(controller, animated: true, completion: nil)
        }
    }

}
