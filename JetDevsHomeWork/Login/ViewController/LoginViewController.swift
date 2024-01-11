//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Avruti on 10/01/24.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Variable
    fileprivate var viewModel: LoginViewModel!
    fileprivate let disposeBag = DisposeBag()
    var loginSuccessCallback: (() -> Void)?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        viewModel.viewController = self
        configureUI()
        bindViewModel()
        
    }
    
    // MARK: - IBAction
    @IBAction func closeButtonTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Form Validation Setup
    fileprivate func configureUI() {
        
        viewModel.initFields(field: emailTextField)
        viewModel.initFields(field: passwordTextField)
        
    }
    
    // MARK: - bindViewModel
    private func bindViewModel() {
        
        // Bind email and password text fields to ViewModel
        emailTextField.rx.text
                    .orEmpty
                    .bind(to: viewModel.emailText)
                    .disposed(by: disposeBag)
        
        passwordTextField.rx.text
                    .orEmpty
                    .bind(to: viewModel.passwordText)
                    .disposed(by: disposeBag)
        
        // Bind the login button's isEnabled property to the ViewModel's isLoginEnabled
        viewModel.isLoginEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Optionally, you can change the appearance of the login button when it's disabled
        viewModel.isLoginEnabled
            .map { isEnabled in
                return isEnabled ? AppColors.primaryColor : AppColors.greyColor
            }
            .subscribe(onNext: { [weak self] color in
                self?.loginButton.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        // Handle login button tap
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.login()
            })
            .disposed(by: disposeBag)
        
        // Handle login success
        viewModel.loginResult
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let user):
                    self?.handleLoginSuccess(user)
                case .failure(let error):
                    debugPrint("Error: \(error.localizedDescription)")
                    self?.showInvalidLoginAlert()
                }
            })
            .disposed(by: disposeBag)

    }
    
    fileprivate func handleLoginSuccess(_ user: User) {
        UserSessionManager.shared.saveUser(user)
        loginSuccessCallback?()
        dismiss(animated: true)
    }
    
    fileprivate func showInvalidLoginAlert() {
        let alert = UIAlertController(
            title: "Invalid Credentials",
            message: "Please check your email and password and try again.",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
