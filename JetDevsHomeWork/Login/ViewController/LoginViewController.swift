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
        setupForm()
        
    }
    
    // MARK: - IBAction
    @IBAction func closeButtonTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Form Validation Setup
    
    fileprivate func setupForm() {
        
        viewModel.initFields(field: emailTextField)
        viewModel.initFields(field: passwordTextField)
        
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
