//
//  ValidationHelper.swift
//  JetDevsHomeWork
//
//  Created by Avruti on 11/01/24.
//

import Foundation

final class EmailValidator {
    
    func validate(_ input: String) -> Bool {
        guard
            let regex = try? NSRegularExpression(
                pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                options: [.caseInsensitive]
            )
        else {
            assertionFailure("Regex not valid")
            return false
        }
        
        let regexFirstMatch = regex
            .firstMatch(
                in: input,
                options: [],
                range: NSRange(location: 0, length: input.count)
            )
        
        return regexFirstMatch != nil
    }
}

final class PasswordValidator {
    
    func validate(_ input: String) -> Bool {
        guard
            let regex = try? NSRegularExpression(
                pattern: "^[a-zA-Z0-9]{8,}$",
                options: []
            )
        else {
            assertionFailure("Regex not valid")
            return false
        }
        
        let regexFirstMatch = regex.firstMatch(
            in: input,
            options: [],
            range: NSRange(location: 0, length: input.count)
        )
        
        return regexFirstMatch != nil
    }
}
