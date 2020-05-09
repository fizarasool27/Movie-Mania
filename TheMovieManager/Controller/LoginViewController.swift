//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Fiza Rasool on 05/7/20.
//  Copyright © 2020 Fiza Rasool. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        TMDBClient.getRequestToken(completionHandler: handleRequestTokenResponse(success:error:))
        
    }
    
    @IBAction func loginViaWebsiteTapped() {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if(success) {
            print("Token response fiza")
            print(TMDBClient.Auth.requestToken)
            DispatchQueue.main.async {
                TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completionHandler: self.handleLoginResponse(success:error:))
                
            }
        }
    }
    func handleLoginResponse(success: Bool, error: Error?) {
        print(TMDBClient.Auth.requestToken)
        
        if success {
            TMDBClient.createSessionId(completionHandler: handleSessionResponse(success:error:))
        }
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
               self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
            
        }
    }
    
}
