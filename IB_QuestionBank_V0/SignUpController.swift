//
//  SignUpController.swift
//  IB_QuestionBank_V0
//
//  Created by Kevin Tang on 2/6/2020.
//  Copyright © 2020 Kevin Tang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var SignUpTitle: UILabel!
    
    @IBOutlet weak var NameContainerView: UITextField!
    
    @IBOutlet weak var EmailContainerView: UITextField!
    
    @IBOutlet weak var PasswordContainerView: UITextField!
    
    @IBOutlet weak var CreateAccountButtonLabel: UIButton!
    
    
    @IBOutlet weak var HaveAccountLabel: UIButton!
    
    @IBOutlet weak var ErrorMessage: UILabel!
    
    @IBAction func CreateAccountButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: EmailContainerView.text!, password: PasswordContainerView.text!) { (authDataResult, error) in
            if error != nil {
                self.ErrorMessage.text =  error!.localizedDescription
                self.ErrorMessage.isHidden = false
            }
            if let authData = authDataResult {
                let dict: Dictionary<String, Any> = [
                    "uid": authData.user.uid,
                    "email": authData.user.email!,
                    "name": self.NameContainerView.text!
                ]
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.NameContainerView.text!
                changeRequest?.commitChanges{ error in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                }
                
                Auth.auth().currentUser?.sendEmailVerification {error in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    
                }
                
                Database.database().reference().child("users").child(authData.user.uid).updateChildValues(dict, withCompletionBlock: {
                    (error, ref) in
                    if error == nil {
                        self.performSegue(withIdentifier: "PushSignUpStatusController", sender: self)
                    } else {
                        self.ErrorMessage.isHidden = false
                        self.ErrorMessage.text = "Error: + \(String(describing: error))"
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
           // Welcome Label
           let Title = "Create Your Account"
           let subTitle = "\n\nSign Up now to test your skills!"

           let attributedText = NSMutableAttributedString(string: Title, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor: UIColor.brown])
           let attributedSubText = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Didot", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.45)])
           
           attributedText.append(attributedSubText)
           
           SignUpTitle.attributedText = attributedText
           
           // Create Account Button UI
           CreateAccountButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
           CreateAccountButtonLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
           CreateAccountButtonLabel.layer.cornerRadius = 5
           CreateAccountButtonLabel.clipsToBounds = true
           
           //Name Text Field UI
           NameContainerView.placeholder = "Name"
        
           //Email Text Field UI
           EmailContainerView.placeholder = "Email Address"
           
           //Password Text Field UI
           PasswordContainerView.placeholder = "Password"
        
           //Error Message Label
            let ErrorMessageText = ""
            let attributedErrorText = NSMutableAttributedString(string: Title, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Didot", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.red])
           ErrorMessage.attributedText = attributedErrorText
           ErrorMessage.isHidden = true
        
           // Already Have Account Button UI
           HaveAccountLabel.setTitleColor(.white, for: UIControl.State.normal)
           HaveAccountLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
           HaveAccountLabel.layer.cornerRadius = 5
           HaveAccountLabel.clipsToBounds = true
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! SignUpStatusController
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
