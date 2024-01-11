//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Avruti on 10/01/24.
//

import RxCocoa
import RxSwift
import Foundation

class LoginViewModel {
    
    // MARK: - Properties
   
    let emailSubject = BehaviorRelay<String?>(value: "")
    let passwordSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    var viewController: UIViewController?
    
 
    // MARK: - InitFields
    
    func initFields(field: UITextField) {
        field.layer.cornerRadius = 5
        field.layer.borderColor = UIColor(rgb: 0xbdbdbd).cgColor
        field.layer.borderWidth = 0.5
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 13.0, height: 45.0))
        field.leftView = leftView
        field.leftViewMode = .always
    }
    
   
}
