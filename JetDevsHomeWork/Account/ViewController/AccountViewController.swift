//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher

class AccountViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nonLoginView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    
    // MARK: - Variables
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    
        setUpView()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.loginSuccessCallback = {
            self.setUpView()
        }
        present(loginVC, animated: true)
    }
    
    @IBAction func logoutButtonTap(_ sender: UIButton) {
        self.showLogoutConfirmationAlert()
    }
    
    
    // MARK: - Custom Methods
    
    fileprivate func setUpView() {

        guard let userDetail = UserSessionManager.shared.getUser() else {
            nonLoginView.isHidden = false
            loginView.isHidden = true
            return
        }
        
        nameLabel.text = userDetail.userName
        if let profileUrl = URL(string: userDetail.userProfileURL) {
            self.headImageView.kf.setImage(with: profileUrl, placeholder: UIImage(named: "Avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.headImageView.image = UIImage(named: "Avatar")
        }
        
        daysLabel.text = "Created \(userDetail.createdAt.dayDifference) days ago"
        nonLoginView.isHidden = true
        loginView.isHidden = false
    }
	
    fileprivate func showLogoutConfirmationAlert() {
         let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)

         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

         let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
             // Perform logout action here
             self.logout()
         }

         alertController.addAction(cancelAction)
         alertController.addAction(logoutAction)

         present(alertController, animated: true, completion: nil)
     }
    
    private func logout() {
        UserSessionManager.shared.clearUser()
        setUpView()
       }
}
