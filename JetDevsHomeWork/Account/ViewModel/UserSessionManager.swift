//
//  UserSessionManager.swift
//  JetDevsHomeWork
//
//  Created by Avruti on 11/01/24.
//

import Foundation

class UserSessionManager {

    // MARK: - Properties
    
    static let shared = UserSessionManager()
    
    private init() {}

    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    private let userAccToken = "accToken"
    
    // MARK: - Custom Methods
    
    // Save the X-Acc(in API response header) to UserDefaults
    func saveUserAccToken(_ accToken: String) {
        userDefaults.set(accToken, forKey: userAccToken)
    }

    // Save the user to UserDefaults
    func saveUser(_ user: User) {
        do {
            let userData = try JSONEncoder().encode(user)
            userDefaults.set(userData, forKey: userKey)
        } catch {
            print("Error encoding user: \(error)")
        }
    }

    // Retrieve the user from UserDefaults
    func getUser() -> User? {
        if let userData = userDefaults.data(forKey: userKey) {
            do {
                let user = try JSONDecoder().decode(User.self, from: userData)
                return user
            } catch {
                print("Error decoding user: \(error)")
            }
        }
        return nil
    }

    // Clear the stored user from UserDefaults
    func clearUser() {
        userDefaults.removeObject(forKey: userKey)
    }
}
