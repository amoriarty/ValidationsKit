//
//  Field.swift
//  ValidationKitDemo
//
//  Created by Alex Legent on 13/03/2019.
//

import UIKit

enum RegistrationField: Int, CaseIterable {
    case username, password, mail, website

    var placeholder: String {
        switch self {
        case .username: return "username"
        case .password: return "password"
        case .mail: return "mail"
        case .website: return "website"
        }
    }

    var textContentType: UITextContentType {
        switch self {
        case .username: return .username
        case .password: return .newPassword
        case .mail: return .emailAddress
        case .website: return .URL
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .mail: return .emailAddress
        case .website: return .webSearch
        default: return .default
        }
    }

    var isSecureEntry: Bool {
        return self == .password
    }
}
