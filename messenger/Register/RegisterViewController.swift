//
//  RegisterViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 16.12.2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private var registerUIView: RegisterUIView {
        self.view as! RegisterUIView
    }
    
    override func loadView() {
        view = RegisterUIView()
    }
    
    var presenterInput: RegisterViewInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerUIView.delegate = self
        setup()
    }

    private func setup() {
        let viewController = self
        let presenter = RegisterPresenter()
        viewController.presenterInput = presenter
        presenter.viewContoller = viewController
    }
}

extension RegisterViewController: RegisterUIViewDelegate {
    
    func registerTapped(firstName: String?, lastName: String?, email: String?, password: String?) {
        guard let firstName = firstName,
              let lastName = lastName,
              let email = email,
              let password = password,
              !firstName.isEmpty, !lastName.isEmpty,
              !email.isEmpty, !password.isEmpty,
              password.count >= 6 else {
            showWarningAlert()
            return
        }
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            guard !exists else{
                //user already exists
                self?.showWarningAlert(message: "Looks like a account for that email address already exists")
                return
            }
            self?.presenterInput.createAccount(request: RegisterRequest(firstName: firstName, lastName: lastName, email: email, password: password, profileImage: self?.registerUIView.getLastImage()))
        }
    }
    
    private func showWarningAlert(message: String = "Please enter information to Create Account.") {
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func changeIconImage() {
        presentPhotoActionSheet()
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(
            title: "Profile picture",
            message: "How would you like to select a picture?",
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        actionSheet.addAction(UIAlertAction(
            title: "Take a photo",
            style: .default,
            handler: { [weak self] _ in
                self?.presentCamera()
            }))
        
        actionSheet.addAction(UIAlertAction(
            title: "Choose a photo",
            style: .default,
            handler: { [weak self] _ in
                self?.presentPhoto()
            }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhoto() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage]
                as? UIImage else {
            return
        }
        registerUIView.setupNewIconImage(image: selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: RegisterDisplayLogic {
    func success(viewModel: User) {
        print("viewModel: \(viewModel)")
        DispatchQueue.main.async {
            let mainVC = TabBarController()
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true)
        }
    }
    
    func showError(errorDescription: String) {
        DispatchQueue.main.async {
            let alert  = UIAlertController(title: R.string.localizable.errorLabel(), message: errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.alertDismiss(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.registerUIView.startSpinner()
        }
    }
    
    func finishLoading() {
        DispatchQueue.main.async {
            self.registerUIView.stopSpinner()
        }
    }
}
