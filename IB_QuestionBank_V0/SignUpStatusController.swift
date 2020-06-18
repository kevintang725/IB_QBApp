//
//  SignUpStatusController.swift
//  IB_QuestionBank_V0
//
//  Created by Kevin Tang on 2/6/2020.
//  Copyright © 2020 Kevin Tang. All rights reserved.
//

import UIKit

class SignUpStatusController: UIViewController {

    @IBOutlet weak var SignUpStatusLabel: UILabel!
    
    @IBOutlet weak var LoginInNowButtonLabel: UIButton!
    
    @IBAction func LoginInNowButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
              // Welcome Label
              let Title = "Congratulation"
              let subTitle = "\n\n\nYour account has been successfully created! Please verify your email before signing in to use our app!"

              let attributedText = NSMutableAttributedString(string: Title, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor: UIColor.brown])
              let attributedSubText = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Didot", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.45)])
              
              attributedText.append(attributedSubText)
              
              SignUpStatusLabel.attributedText = attributedText
              
        // Login In Now  Button UI
        LoginInNowButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
        LoginInNowButtonLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        LoginInNowButtonLabel.layer.cornerRadius = 5
        LoginInNowButtonLabel.clipsToBounds = true
             
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
