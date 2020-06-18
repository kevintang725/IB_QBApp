//
//  LoginControllerViewController.swift
//  IB_QuestionBank_V0
//
//  Created by Kevin Tang on 2/6/2020.
//  Copyright © 2020 Kevin Tang. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextLabel: UILabel!
    
    @IBOutlet weak var EmailContainerView: UITextField!
    
    @IBOutlet weak var PasswordContainerView: UITextField!
    
    @IBOutlet weak var SignInButtonLabel: UIButton!
    
    @IBOutlet weak var SignUpButtonLabel: UIButton!
    
    @IBOutlet weak var ForgotPasswordButtonLabel: UIButton!
    
    @IBOutlet weak var ErrorMessageBoxLabel: UILabel!
    
    @IBAction func SignInButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: EmailContainerView.text!, password: PasswordContainerView.text!){ (authData, error) in
            if error != nil {
                let errortext = error?.localizedDescription
                self.ErrorMessageBoxLabel.isHidden = false
                self.ErrorMessageBoxLabel.text = errortext
            }
            else {
                if (Auth.auth().currentUser?.isEmailVerified == true){
                    self.performSegue(withIdentifier: "LogInSegue", sender: self)
                } else {
                    self.ErrorMessageBoxLabel.isHidden = false
                    self.ErrorMessageBoxLabel.text = "Please verify your email before signing in"
                }
            }
        }
    }
    
    @IBAction func SignUpButton(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    @IBAction func ForgotPasswordButton(_ sender: Any) {
    }
    
    func setupUI() {
        // Welcome Label
        let Title = "Welcome to IB Bank"
        let subTitle = "\n\nSign in to test yourself"

        let attributedText = NSMutableAttributedString(string: Title, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor: UIColor.brown])
        let attributedSubText = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Didot", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.45)])
        
        attributedText.append(attributedSubText)
        
        titleTextLabel.attributedText = attributedText
        
        // Sign In Button UI
        SignInButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
        SignInButtonLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        SignInButtonLabel.layer.cornerRadius = 5
        SignInButtonLabel.clipsToBounds = true
        // Sign Up Button UI
        SignUpButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
        SignUpButtonLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        SignUpButtonLabel.layer.cornerRadius = 5
        SignUpButtonLabel.clipsToBounds = true
        
        //Email Text Field UI
        EmailContainerView.placeholder = "Email Address"
        
        //Password Text Field UI
        PasswordContainerView.placeholder = "Password"
        
        //Forgot Password Button UI
        ForgotPasswordButtonLabel.setTitleColor(.black, for: UIControl.State.normal)
        
        //Error Message Box Label
        let ErrorMessageText = ""

        let attributedErrorText = NSMutableAttributedString(string: Title, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Didot", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.red])
        ErrorMessageBoxLabel.attributedText = attributedErrorText
        ErrorMessageBoxLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogInSegue" {
           let vc = segue.destination as! QuestionController
        } else if segue.identifier == "SignUpSegue" {
            let vc = segue.destination as! SignUpController
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        setupUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
