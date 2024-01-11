//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Avruti on 10/01/24.
//

import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
import SwiftyJSON
import Foundation

class LoginViewModel {
    
    // MARK: - Properties
    
    var viewController: UIViewController?
    
    private let disposeBag = DisposeBag()
    
    // Input observables
    let emailText = BehaviorSubject<String>(value: "")
    let passwordText = BehaviorSubject<String>(value: "")
    
    // Output observables for validation
    var isEmailValid: Observable<Bool> = Observable.just(false)
    var isPasswordValid: Observable<Bool> = Observable.just(false)
    var isLoginEnabled: Observable<Bool> = Observable.just(false)
    
    // Output observable for login result
    let loginResult: PublishSubject<Result<User, Error>> = PublishSubject()
    
    init() {
        
        emailText.onNext("")
        passwordText.onNext("")
        
        // Create validators
        let emailValidator = createEmailValidator()
        let passwordValidator = createPasswordValidator()
        
        // Validate email and password inputs
        isEmailValid = emailText.map { email in
            return emailValidator.isValid(email)
        }
        
        isPasswordValid = passwordText.map { password in
            return passwordValidator.isValid(password)
        }
        
        // CombineLatest to check both email and password are valid
        isLoginEnabled = Observable.combineLatest(isEmailValid, isPasswordValid)
            .map { isEmailValid, isPasswordValid in
                return isEmailValid && isPasswordValid
            }
    }
    
    // Function to handle login
    func login() {
        guard let email = try? emailText.value(),
              let password = try? passwordText.value() else {
            return
        }
        
        requestLogin(withEmail: email, withPassword: password)
                    .subscribe(onNext: { [weak self] user in
                        self?.loginResult.onNext(.success(user))
                    }, onError: { [weak self] error in
                        self?.loginResult.onNext(.failure(error))
                    })
                    .disposed(by: disposeBag)
    }
    
    func initFields(field: UITextField) {
        field.layer.cornerRadius = 5
        field.layer.borderColor = AppColors.greyColor.cgColor
        field.layer.borderWidth = 0.5
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 13.0, height: 45.0))
        field.leftView = leftView
        field.leftViewMode = .always
    }

    func requestLogin(withEmail email: String, withPassword password: String) -> Observable<User> {
        
        let loginUrl = "https://jetdevs.wiremockapi.cloud/login"
        
        let params = [
            "email": email,
            "password": password
        ]
        
        return Observable.create { observer in
            self.viewController?.showHUD()
            
            let request = NetworkManager.shared.fetchData(url: loginUrl, method: .post, parameters: params, encoding: JSONEncoding.default)
                .map { (result: UserDataResponse) -> User in
                    return result.data.user
                }
                .subscribe(onNext: { user in
                    self.viewController?.hideHUD()
                    observer.onNext(user)
                    observer.onCompleted()
                }, onError: { error in
                    self.viewController?.hideHUD()
                    observer.onError(error)
                })
            
            return Disposables.create {
                request.dispose()
            }
        }
    }
    
}

extension LoginViewModel {
    
    private func createEmailValidator() -> Validator {
        return Validator { input in
            // Simple email validation for demonstration purposes
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailTest.evaluate(with: input)
        }
    }
    
    private func createPasswordValidator() -> Validator {
        return Validator { input in
            // Use the regular expression for password validation
            let passwordRegex = "^[a-zA-Z0-9]{8,}$"
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
            return passwordTest.evaluate(with: input)
        }
    }
    
}

// Validator class to encapsulate validation logic
class Validator {
    
    private let validation: (String) -> Bool

    init(validation: @escaping (String) -> Bool) {
        self.validation = validation
    }

    func isValid(_ input: String) -> Bool {
        return validation(input)
    }
}
