//
//  LoginUIView.swift
//  messenger
//
//  Created by Khurshed Umarov on 14.12.2022.
//

import UIKit
import SnapKit
import JGProgressHUD

protocol LogInBtnPressedDelegate: AnyObject {
    func logInAction(emailText: String?, passwordText: String?)
}

class LoginUIView: UIView {
    
    private let iconImageView = UIImageView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let logInBtn = UIButton()
    private let spinner = JGProgressHUD(style: .dark)
    
    weak var delegate: LogInBtnPressedDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        initIconImageView()
        initEmailTextField()
        initPasswordField()
        initLogInBtn()
    }
    
    private func initIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = R.image.telegram()
        
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { makeIconImage in
            makeIconImage.top.equalToSuperview().offset(100)
            makeIconImage.centerX.equalToSuperview()
            makeIconImage.height.equalTo(100)
            makeIconImage.width.equalTo(100)
        }
    }
    
    private func initEmailTextField() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = R.string.localizable.email()
        let padding = UIView(frame: CGRectMake(0, 0, 15, self.emailTextField.frame.height))
        emailTextField.leftView = padding
        emailTextField.leftViewMode = .always
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 12
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        
        addSubview(emailTextField)
        emailTextField.snp.makeConstraints { makeEmail in
            makeEmail.top.equalTo(iconImageView.snp.bottom).offset(40)
            makeEmail.left.equalToSuperview().offset(30)
            makeEmail.right.equalToSuperview().offset(-30)
            makeEmail.height.equalTo(50)
        }
    }
    
    private func initPasswordField() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = R.string.localizable.password()
        let padding = UIView(frame: CGRectMake(0, 0, 15, self.passwordTextField.frame.height))
        passwordTextField.leftView = padding
        passwordTextField.leftViewMode = .always
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { makePasswordField in
            makePasswordField.top.equalTo(emailTextField.snp.bottom).offset(20)
            makePasswordField.left.equalToSuperview().offset(30)
            makePasswordField.right.equalToSuperview().offset(-30)
            makePasswordField.height.equalTo(50)
        }
    }
    
    private func initLogInBtn() {
        logInBtn.translatesAutoresizingMaskIntoConstraints = false
        logInBtn.backgroundColor = .blue
        logInBtn.setTitle(R.string.localizable.logIn(), for: .normal)
        logInBtn.setTitleColor(.white, for: .normal)
        logInBtn.layer.cornerRadius = 8
        logInBtn.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        
        addSubview(logInBtn)
        logInBtn.snp.makeConstraints { makeLogIn in
            makeLogIn.top.equalTo(passwordTextField.snp.bottom).offset(50)
            makeLogIn.left.equalToSuperview().offset(30)
            makeLogIn.right.equalToSuperview().offset(-30)
            makeLogIn.height.equalTo(50)
        }
    }
    
    @objc private func logInPressed() {
        print("Number: \(String(describing: emailTextField.text))")
        delegate?.logInAction(emailText: emailTextField.text, passwordText: passwordTextField.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startSpinner() {
        spinner.show(in: self)
    }
    
    public func stopSpinner() {
        spinner.dismiss(animated: true)
    }
}

extension LoginUIView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
