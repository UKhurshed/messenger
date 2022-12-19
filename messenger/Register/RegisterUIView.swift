//
//  RegisterUIView.swift
//  messenger
//
//  Created by Khurshed Umarov on 16.12.2022.
//

import UIKit
import JGProgressHUD

protocol RegisterUIViewDelegate: AnyObject {
    func registerTapped(firstName: String?, lastName: String?, email: String?, password: String?)
    func changeIconImage()
}

class RegisterUIView: UIView {
    
    let logo = UIImageView()
    private let firstNameField = UITextField()
    private let lastNameField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let registerBtn = UIButton()
    private let spinner = JGProgressHUD(style: .dark)
    
    weak var delegate: RegisterUIViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        initLogo()
        initFirstTextField()
        initLastTextField()
        initEmailTextField()
        initPasswordField()
        initRegisterBtn()
    }
    
    private func initLogo() {
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "user")
        logo.contentMode = .scaleAspectFit
        logo.isUserInteractionEnabled = true
        logo.layer.masksToBounds = true
        logo.layer.cornerRadius = 60
        logo.layer.borderWidth = 2
        logo.layer.borderColor = UIColor.lightGray.cgColor
        let tap = UITapGestureRecognizer()
        logo.addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(tappedChangeIcon))
        
        addSubview(logo)
        logo.snp.makeConstraints { makeLogo in
            makeLogo.top.equalToSuperview().offset(90)
            makeLogo.centerX.equalToSuperview()
            makeLogo.height.equalTo(90)
            makeLogo.width.equalTo(90)
        }
    }
    
   @objc private func tappedChangeIcon() {
        delegate?.changeIconImage()
    }
    
    private func initFirstTextField() {
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        firstNameField.placeholder = R.string.localizable.firstName()
        let padding = UIView(frame: CGRectMake(0, 0, 15, self.firstNameField.frame.height))
        firstNameField.leftView = padding
        firstNameField.leftViewMode = .always
        firstNameField.layer.borderWidth = 1.0
        firstNameField.layer.cornerRadius = 12
        firstNameField.becomeFirstResponder()
        firstNameField.delegate = self
        
        addSubview(firstNameField)
        firstNameField.snp.makeConstraints { makeFirst in
            makeFirst.top.equalTo(logo.snp.bottom).offset(25)
            makeFirst.left.equalToSuperview().offset(30)
            makeFirst.right.equalToSuperview().offset(-30)
            makeFirst.height.equalTo(50)
        }
    }
    
    private func initLastTextField() {
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.placeholder = R.string.localizable.lastName()
        let padding = UIView(frame: CGRectMake(0, 0, 15, self.lastNameField.frame.height))
        lastNameField.leftView = padding
        lastNameField.leftViewMode = .always
        lastNameField.layer.borderWidth = 1.0
        lastNameField.layer.cornerRadius = 12
        lastNameField.becomeFirstResponder()
        lastNameField.delegate = self
        
        addSubview(lastNameField)
        lastNameField.snp.makeConstraints { makeLast in
            makeLast.top.equalTo(firstNameField.snp.bottom).offset(15)
            makeLast.left.equalToSuperview().offset(30)
            makeLast.right.equalToSuperview().offset(-30)
            makeLast.height.equalTo(50)
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
            makeEmail.top.equalTo(lastNameField.snp.bottom).offset(15)
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
            makePasswordField.top.equalTo(emailTextField.snp.bottom).offset(15)
            makePasswordField.left.equalToSuperview().offset(30)
            makePasswordField.right.equalToSuperview().offset(-30)
            makePasswordField.height.equalTo(50)
        }
    }
    
    private func initRegisterBtn() {
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        registerBtn.backgroundColor = .blue
        registerBtn.setTitle(R.string.localizable.registerBtn(), for: .normal)
        registerBtn.setTitleColor(.white, for: .normal)
        registerBtn.layer.cornerRadius = 8
        registerBtn.addTarget(self, action: #selector(registerTapper), for: .touchUpInside)
        
        addSubview(registerBtn)
        registerBtn.snp.makeConstraints { makeCreateBtn in
            makeCreateBtn.top.equalTo(passwordTextField.snp.bottom).offset(40)
            makeCreateBtn.left.equalToSuperview().offset(30)
            makeCreateBtn.right.equalToSuperview().offset(-30)
            makeCreateBtn.height.equalTo(50)
        }
    }
    
    @objc private func registerTapper() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    
        delegate?.registerTapped(
            firstName: firstNameField.text,
            lastName: lastNameField.text,
            email: emailTextField.text,
            password: passwordTextField.text)
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
    
    public func setupNewIconImage(image: UIImage) {
        logo.image = image
    }
    
    public func getLastImage() -> UIImage? {
        return logo.image
    }
}

extension RegisterUIView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
