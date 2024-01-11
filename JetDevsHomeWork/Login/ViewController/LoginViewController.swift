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
    @IBOutlet weak var loginButton: UIButton! { didSet {
        loginButton.backgroundColor = loginButton.isEnabled ? UIColor(rgb: 0x28518D) : UIColor(rgb: 0xBDBDBD)
    }}
    
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
    
    // MARK: - configureUI
    fileprivate func configureUI() {
        
        viewModel.initFields(field: emailTextField)
        viewModel.initFields(field: passwordTextField)
        
    }
    
    // MARK: - bindViewModel
    private func bindViewModel() {
        // Bind text fields to ViewModel
        emailTextField.rx.text.bind(to: viewModel.emailSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.bind(to: viewModel.passwordSubject).disposed(by: disposeBag)
        
        viewModel.isValidForm.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isValidForm
            .subscribe(onNext: { isValid in
                if(isValid) {
                    self.loginButton.backgroundColor = UIColor(rgb: 0x28518D)
                } else {
                    self.loginButton.backgroundColor = UIColor(rgb: 0xBDBDBD)
                }
            })
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.loginApiCall() })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Submit Clicked
    
    fileprivate func loginApiCall() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            self.showAlert(message: "Email and Password can't be empty")
            return
        }
        
    }
    
    fileprivate func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Login",
            message: message,
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
