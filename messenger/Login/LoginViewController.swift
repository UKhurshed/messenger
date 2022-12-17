//
//  LoginViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 14.12.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var loginUIView: LoginUIView {
        self.view as! LoginUIView
    }
    
    override func loadView() {
        view = LoginUIView()
    }
    
    var presenterInput: LoginViewInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(tappedRegister))
        loginUIView.delegate = self
        setup()
    }
    
    @objc private func tappedRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }

    private func setup() {
        let viewController = self
        let presenter = LoginPresenter()
        viewController.presenterInput = presenter
        presenter.viewContoller = viewController
    }
}

extension LoginViewController: LogInBtnPressedDelegate {
    func logInAction(emailText: String?, passwordText: String?) {
        guard let email = emailText, let password = passwordText else {
            showWarningAlert()
            return
        }
        presenterInput.loginByEmailAndPassword(request: LoginRequest(email: email, password: password))
    }
    
    private func showWarningAlert() {
        let alert = UIAlertController(title: "Woops", message: "Please enter information to Log In.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension LoginViewController: LoginDisplayLogic {
    func success(viewModel: LoginViewModel) {
        print("viewModel: \(viewModel)")
        let mainVC = ViewController()
        mainVC.modalPresentationStyle = .fullScreen
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func showError(errorDescription: String) {
        DispatchQueue.main.async {
            self.loginUIView.showError()
            let alert  = UIAlertController(title: R.string.localizable.errorLabel(), message: errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.alertDismiss(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.loginUIView.startAnimatingIndicator()
        }
    }
    
    func finishLoading() {
        DispatchQueue.main.async {
            self.loginUIView.stopAnimatingIndicator()
        }
    }
}
