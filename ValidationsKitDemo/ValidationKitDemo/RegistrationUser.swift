//
//  RegistrationUser.swift
//  ValidationKitDemo
//
//  Created by Alex Legent on 13/03/2019.
//

import Foundation
import ValidationsKit

struct RegistrationUser {
    let username: String
    let password: String
    let mail: String
    let website: String?
}

extension RegistrationUser: Validatable {

    static func validations() throws -> Validations<RegistrationUser> {
        var validations = Validations(RegistrationUser.self)
        validations.add(\.username, at: ["username"], !.empty)
        validations.add(\.password, at: ["password"], .count(8...))
        validations.add(\.mail, at: ["mail"], .mail)
        validations.add(\.website, at: ["website"], .nil || .url)
        return validations
    }

}
