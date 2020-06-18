//
//  ViewController.swift
//  IB_QuestionBank_V0
//
//  Created by Kevin Tang on 17/5/2020.
//  Copyright © 2020 Kevin Tang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Firebase

class QuestionController: UIViewController, UITextFieldDelegate {
    
    // Initialize Firebase References
    let ref = Database.database().reference()
    let storage = Storage.storage()
    
    // Initialize Global Variables
    var q_number = 1
    var datapath = ""
    var Q_NO_MEMORY: [Int] = []
    var Q_COUNTER = 0;
    var userID = (Auth.auth().currentUser?.displayName)! as String
    
    
    //Mark: Properties
    @IBOutlet weak var DiagramImage: UIImageView!
    @IBOutlet weak var TableImage: UIImageView!
    @IBOutlet weak var QuestionNumber: UILabel!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var OptionAButtonLabel: UIButton!
    @IBOutlet weak var OptionBButtonLabel: UIButton!
    @IBOutlet weak var OptionCButtonLabel: UIButton!
    @IBOutlet weak var OptionDButtonLabel: UIButton!
    @IBOutlet weak var AnswerStatus: UILabel!
    @IBOutlet weak var ShortAnswerTextField: UITextField!
    @IBOutlet weak var SubmitButtonLabel: UIButton!
    
    //Mark: Actions
    @IBAction func PreviousButton(_ sender: UIButton) {
        if (Q_COUNTER == 0){
            //Do Nothing
        } else {
            Q_COUNTER -= 1
            q_number = Q_NO_MEMORY[Q_COUNTER]
            datapath = "Question/Question_\(q_number)";
            self.FetchQuestion(path: datapath)
            self.AnswerStatus.isHidden = true
            QuestionNumber.text = String(Q_COUNTER)
            ReleasePressedButton(button: OptionAButtonLabel)
            ReleasePressedButton(button: OptionBButtonLabel)
            ReleasePressedButton(button: OptionCButtonLabel)
            ReleasePressedButton(button: OptionDButtonLabel)
        }
    }
    
    @IBAction func NextButton(_ sender: UIButton) {
        q_number = Int.random(in: 1 ... 3)
        datapath = "Question/Question_\(q_number)";
        Q_COUNTER += 1
        Q_NO_MEMORY.append(q_number)
        self.FetchQuestion(path: datapath)
        self.AnswerStatus.isHidden = true
        QuestionNumber.text = String(Q_COUNTER)
        ReleasePressedButton(button: OptionAButtonLabel)
        ReleasePressedButton(button: OptionBButtonLabel)
        ReleasePressedButton(button: OptionCButtonLabel)
        ReleasePressedButton(button: OptionDButtonLabel)

    }
    @IBAction func SubmitButton(_ sender: Any) {
        GetData(path: datapath, completion: { retrievedata in
            // WHEN you get a callback from the completion handler,
            // Check if Question/Answer is Numerical
 
            if (retrievedata[DatabasePath().ShortAnswer] as? NSNumber != nil){
                // Answer is Numerical
                //Set Tolerance Level for Answer
                let value = retrievedata[DatabasePath().ShortAnswer] as? NSNumber
                let tolerance = 0.02 // Set tolerance to 2%
                let upperbound = Double(truncating: value!)*(1+tolerance)
                let lowerbound = Double(truncating: value!)*(1-tolerance)
                let textvalue: Double = Double(self.ShortAnswerTextField.text!)!
                self.ref.child("userid").child(self.userID ).child("Question").updateChildValues(["Question_\(self.q_number)" : textvalue])
                
                if ((textvalue <= upperbound) && (textvalue >= lowerbound)){
                     // Correct/Wrong Label UI
                    let attributedAnswerStatusText = NSMutableAttributedString(string: "Correct!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 255, blue: 0, alpha: 0.65)])
                    self.AnswerStatus.attributedText = attributedAnswerStatusText
                    self.AnswerStatus.isHidden = false
                }
                else {
                    // Correct/Wrong Label UI
                    let attributedAnswerStatusText = NSMutableAttributedString(string: "Incorrect!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 0, blue: 0, alpha: 0.65)])
                    self.AnswerStatus.attributedText = attributedAnswerStatusText
                    self.AnswerStatus.isHidden = false
                }
            } else {
                self.ref.child("userid").child(self.userID ).child("Question").updateChildValues(["Question_\(self.q_number)" : self.ShortAnswerTextField.text as Any])
                
                if ((retrievedata[DatabasePath().ShortAnswer] as? String) == self.ShortAnswerTextField.text){
                     // Correct/Wrong Label UI
                    let attributedAnswerStatusText = NSMutableAttributedString(string: "Correct!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 255, blue: 0, alpha: 0.65)])
                    self.AnswerStatus.attributedText = attributedAnswerStatusText
                    self.AnswerStatus.isHidden = false
                }
                else {
                    // Correct/Wrong Label UI
                    let attributedAnswerStatusText = NSMutableAttributedString(string: "Incorrect!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 0, blue: 0, alpha: 0.65)])
                    self.AnswerStatus.attributedText = attributedAnswerStatusText
                    self.AnswerStatus.isHidden = false
                }
            }
        })
        
    }
    
    @IBAction func OptionAButton(_ sender: UIButton) {
        isPressedButton(button: OptionAButtonLabel)
        // Store selected answer by user to database
        self.ref.child("userid").child(userID ).child("Question").updateChildValues(["Question_\(q_number)" : "A"])
        ReleasePressedButton(button: OptionBButtonLabel)
        ReleasePressedButton(button: OptionCButtonLabel)
        ReleasePressedButton(button: OptionDButtonLabel)
        GetData(path: datapath, completion: { retrievedata in
            // WHEN you get a callback from the completion handler,
            if ((retrievedata[DatabasePath().Answer]) as? String == "A"){
                 // Correct/Wrong Label UI
                let attributedAnswerStatusText = NSMutableAttributedString(string: "Correct!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 255, blue: 0, alpha: 0.65)])
                self.AnswerStatus.attributedText = attributedAnswerStatusText
                self.AnswerStatus.isHidden = false
            }
            else {
                // Correct/Wrong Label UI
                let attributedAnswerStatusText = NSMutableAttributedString(string: "Incorrect!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 0, blue: 0, alpha: 0.65)])
                self.AnswerStatus.attributedText = attributedAnswerStatusText
                self.AnswerStatus.isHidden = false
            }
        })
    }
    
    @IBAction func OptionBButton(_ sender: UIButton) {
        isPressedButton(button: OptionBButtonLabel)
        // Store selected answer by user to database
        self.ref.child("userid").child(userID ).child("Question").updateChildValues(["Question_\(q_number)" : "B"])
        ReleasePressedButton(button: OptionAButtonLabel)
        ReleasePressedButton(button: OptionCButtonLabel)
        ReleasePressedButton(button: OptionDButtonLabel)
        GetData(path: datapath, completion: { retrievedata in
            // WHEN you get a callback from the completion handler,
            if ((retrievedata[DatabasePath().Answer] as? String) == "B"){
                 // Correct/Wrong Label UI
                let attributedAnswerStatusText = NSMutableAttributedString(string: "Correct!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 255, blue: 0, alpha: 0.65)])
                self.AnswerStatus.attributedText = attributedAnswerStatusText
                self.AnswerStatus.isHidden = false
            }
            else {
                // Correct/Wrong Label UI
                let attributedAnswerStatusText = NSMutableAttributedString(string: "Incorrect!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 0, blue: 0, alpha: 0.65)])
                self.AnswerStatus.attributedText = attributedAnswerStatusText
                self.AnswerStatus.isHidden = false
            }
        })
    }
    
    @IBAction func OptionCButton(_ sender: UIButton) {
        isPressedButton(button: OptionCButtonLabel)
        // Store selected answer by user to database
        self.ref.child("userid").child(userID ).child("Question").updateChildValues(["Question_\(q_number)" : "C"])
        ReleasePressedButton(button: OptionAButtonLabel)
        ReleasePressedButton(button: OptionBButtonLabel)
        ReleasePressedButton(button: OptionDButtonLabel)
        GetData(path: datapath, completion: { retrievedata in
            // WHEN you get a callback from the completion handler,
            if ((retrievedata[DatabasePath().Answer] as? String) == "C"){
                 // Correct/Wrong Label UI
                let attributedAnswerStatusText = NSMutableAttributedString(string: "Correct!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 255, blue: 0, alpha: 0.65)])
                self.AnswerStatus.attributedText = attributedAnswerStatusText
                self.AnswerStatus.isHidden = false
            }
            else {
                // Correct/Wrong Label UI
                let attributedAnswerStatusText = NSMutableAttributedString(string: "Incorrect!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 0, blue: 0, alpha: 0.65)])
                self.AnswerStatus.attributedText = attributedAnswerStatusText
                self.AnswerStatus.isHidden = false
            }
        })
    }
    
    @IBAction func OptionDButton(_ sender: UIButton) {
        isPressedButton(button: OptionDButtonLabel)
        // Store selected answer by user to database
        self.ref.child("userid").child(userID ).child("Question").updateChildValues(["Question_\(q_number)" : "D"])
        ReleasePressedButton(button: OptionAButtonLabel)
        ReleasePressedButton(button: OptionBButtonLabel)
        ReleasePressedButton(button: OptionCButtonLabel)
        GetData(path: datapath, completion: { retrievedata in
            // WHEN you get a callback from the completion handler,
            if ((retrievedata[DatabasePath().Answer] as? String) == "D"){
                 // Correct/Wrong Label UI
                let attributedAnswerStatusText = NSMutableAttributedString(string: "Correct!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 255, blue: 0, alpha: 0.65)])
                self.AnswerStatus.attributedText = attributedAnswerStatusText
                self.AnswerStatus.isHidden = false
            }
            else {
                // Correct/Wrong Label UI
                let attributedAnswerStatusText = NSMutableAttributedString(string: "Incorrect!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 0, blue: 0, alpha: 0.65)])
                self.AnswerStatus.attributedText = attributedAnswerStatusText
                self.AnswerStatus.isHidden = false
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Dismiss Keyboard Function
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Initialize First Question
        q_number = Int.random(in: 1 ... 2)
        datapath = "Question/Question_\(q_number)";
        Q_COUNTER += 1
        QuestionNumber.text = String(Q_COUNTER)
        Q_NO_MEMORY.append(q_number)
        self.FetchQuestion(path: datapath)
    }

    
    func setupUIButton(bool: Bool) {
        if (bool == true){
            // Option A Button UI
            OptionAButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
            OptionAButtonLabel.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
            OptionAButtonLabel.layer.cornerRadius = 5
            OptionAButtonLabel.clipsToBounds = true
            // Option B Button UI
            OptionBButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
            OptionBButtonLabel.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
            OptionBButtonLabel.layer.cornerRadius = 5
            OptionBButtonLabel.clipsToBounds = true
            // Option C Button UI
            OptionCButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
            OptionCButtonLabel.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
            OptionCButtonLabel.layer.cornerRadius = 5
            OptionCButtonLabel.clipsToBounds = true
            // Option D Button UI
            OptionDButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
            OptionDButtonLabel.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
            OptionDButtonLabel.layer.cornerRadius = 5
            OptionDButtonLabel.clipsToBounds = true
        } else {
            // Option A Button UI
            OptionAButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
            OptionAButtonLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            OptionAButtonLabel.layer.cornerRadius = 5
            OptionAButtonLabel.clipsToBounds = true
            // Option B Button UI
            OptionBButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
            OptionBButtonLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            OptionBButtonLabel.layer.cornerRadius = 5
            OptionBButtonLabel.clipsToBounds = true
            // Option C Button UI
            OptionCButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
            OptionCButtonLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            OptionCButtonLabel.layer.cornerRadius = 5
            OptionCButtonLabel.clipsToBounds = true
            // Option D Button UI
            OptionDButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
            OptionDButtonLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            OptionDButtonLabel.layer.cornerRadius = 5
            OptionDButtonLabel.clipsToBounds = true
            
            SubmitButtonLabel.setTitleColor(.white, for: UIControl.State.normal)
            SubmitButtonLabel.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
            SubmitButtonLabel.layer.cornerRadius = 5
            SubmitButtonLabel.clipsToBounds = true
        }
    }
    
    func isPressedButton(button: UIButton) {
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }
    
    func ReleasePressedButton(button: UIButton) {
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }
    
    func FetchQuestion(path: String) {
        GetData(path: datapath, completion: { retrievedata in
            // WHEN you get a callback from the completion handler,
            self.SetFieldParameters(retrievedata: retrievedata)
        })
    }
    
    func SetFieldParameters(retrievedata: [String:Any]){
        //Set Question Label
        self.QuestionLabel.text = retrievedata[DatabasePath().Question_Label] as? String
        
        //Check if Question is MC or Short Answer
        if ((retrievedata[DatabasePath().ShortAnswer] as? String == nil) && (retrievedata[DatabasePath().ShortAnswer] as? Int == nil)) {
            // Question is MC, set ShortAnswerLabel and ShortAnswerTextField hidden
            self.ShortAnswerTextField.isHidden = true
            self.SubmitButtonLabel.isHidden = true
            self.OptionAButtonLabel.isHidden = false
            self.OptionBButtonLabel.isHidden = false
            self.OptionCButtonLabel.isHidden = false
            self.OptionDButtonLabel.isHidden = false
            
            setupUIButton(bool: true)
            
            //Set Option A
            if ((retrievedata[DatabasePath().Option_A] as? String) == nil){
                self.OptionAButtonLabel.setTitle(((retrievedata[DatabasePath().Option_A] as? NSNumber)?.stringValue), for: .normal)
            }
            else {
                self.OptionAButtonLabel.setTitle(retrievedata[DatabasePath().Option_A] as? String, for: .normal)
            }
            //Set Option B
            if ((retrievedata[DatabasePath().Option_B] as? String) == nil){
                self.OptionBButtonLabel.setTitle(((retrievedata[DatabasePath().Option_B] as? NSNumber)?.stringValue), for: .normal)
            }
            else {
                self.OptionBButtonLabel.setTitle(retrievedata[DatabasePath().Option_B] as? String, for: .normal)
            }
            //Set Option C
            if ((retrievedata[DatabasePath().Option_C] as? String) == nil){
                self.OptionCButtonLabel.setTitle(((retrievedata[DatabasePath().Option_C] as? NSNumber)?.stringValue), for: .normal)
            }
            else {
                self.OptionCButtonLabel.setTitle(retrievedata[DatabasePath().Option_C] as? String, for: .normal)
            }
            //Set Option D
            if ((retrievedata[DatabasePath().Option_D] as? String) == nil){
                self.OptionDButtonLabel.setTitle(((retrievedata[DatabasePath().Option_D] as? NSNumber)?.stringValue), for: .normal)
            }
            else {
                self.OptionDButtonLabel.setTitle(retrievedata[DatabasePath().Option_D] as? String, for: .normal)
            }
        } else {
            // Question is Short Answer, Set OptionA-D Button Label hidden
            self.OptionAButtonLabel.isHidden = true
            self.OptionBButtonLabel.isHidden = true
            self.OptionCButtonLabel.isHidden = true
            self.OptionDButtonLabel.isHidden = true
            self.ShortAnswerTextField.isHidden = false
            self.SubmitButtonLabel.isHidden = false
            
            setupUIButton(bool: false)
        }
        
        //Set Images
        if (retrievedata[DatabasePath().DiagramImage] == nil ){
            self.DiagramImage.isHidden = true
        } else {
            self.DiagramImage.isHidden = false
            GetImageforDiagram(path: "Diagram/" + ((retrievedata[DatabasePath().DiagramImage] as? String)!))
        }
        
        if (retrievedata[DatabasePath().TableImage] == nil){
            self.TableImage.isHidden = true
        } else {
            self.TableImage.isHidden = false
         GetImageforTable(path: "Table/" + ((retrievedata[DatabasePath().TableImage] as? String)!))
        }
    }
    
    func GetData(path: String, completion: @escaping (_ retrievedata: [String:Any]) -> Void) {
        DispatchQueue.main.async {
            self.ref.child(path).observeSingleEvent(of: .value, with: {(snapshot) in
                 //you are inside a completion handler. this code executes WHEN you've received a snapshot object
                 // and its done here
              let data = snapshot.value as? [String:Any]
              completion(data!)
             })
        }
    }
    
    func GetImageforTable(path: String) {
        let StorageRef = storage.reference()
        let imageref = StorageRef.child(path)
        
        imageref.getData(maxSize: 10*1024*1024) { data, error in
            if let error = error {
                self.TableImage.isHidden = true
                print(error)
            } else {
                self.TableImage.image = UIImage(data: data!)
            }
        }
    }
    
    func GetImageforDiagram(path: String) {
        let StorageRef = storage.reference()
        let imageref = StorageRef.child(path)
        
        imageref.getData(maxSize: 10*1024*1024) { data, error in
            if let error = error {
                self.DiagramImage.isHidden = true
                print(error)
            } else {
                self.DiagramImage.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func DiagramImgTap(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage(sender:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func TableImgTap(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage(sender:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    @objc func dismissFullScreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, don't do anything
            return
        }
        
        // move the rootview up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move the rootview back to origin zero
        self.view.frame.origin.y = 0
    }
    
}

