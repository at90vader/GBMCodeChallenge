//
//  LoginViewController.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    var presenter: ViewToPresenterLoginProtocol?
    private var biometricType: BiometricType?

    @IBOutlet weak var biometricImageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let biometricType = presenter?.getBiometricType() {
            self.biometricType = biometricType
            switch biometricType {
            case .touch:
                biometricImageView.image = UIImage(systemName: "touchid")
                messageLabel.text = "Use the TouchID to login"
            case .face:
                biometricImageView.image = UIImage(systemName: "faceid")
                messageLabel.text = "Use the FaceID to login"
            case .unavailable:
                biometricImageView.image = UIImage(systemName: "exclamationmark.circle")
                messageLabel.text = "Biometric isn't available"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        if biometricType == .unavailable {
            presentAlert(with: "The user won't be able to be authenticated because this device doesn't have a biometric sensor.", action: nil)
        }
    }
    
    @IBAction func onLoginButtonTap(_ sender: Any) {
        presenter?.login()
    }
}

extension LoginViewController: PresenterToViewLoginProtocol {

    func onLoginFailed(error: AuthError) {
        presentAlert(with: error.localizedDescription, action: nil)
    }
}
