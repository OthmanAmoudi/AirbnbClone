//
//  ViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
class LogInViewController: UIViewController {
    
    @IBOutlet weak var LoginEmailTF: UITextField!
    @IBOutlet weak var LoginPasswordTF: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.goToMainInterface()
            }
        }

        LoginEmailTF.text = "tomy@hil.com"
        LoginPasswordTF.placeholder = "pasword is 123456"
        LoginBtn.isEnabled = false
        handleTextFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUpDidPressed(_ sender: Any) {
        performSegue(withIdentifier: "ShowSignUp", sender: nil)
    }
  
    @IBAction func logInDidPressed(_ sender: Any) {
        if LoginEmailTF.text == "" || LoginPasswordTF.text == "" {
            let errorAlert1 = UIAlertController(title: "Error", message: "Email/Password Can't be Empty", preferredStyle: .alert)
            let errorAlertOkayAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
            errorAlert1.addAction(errorAlertOkayAction)
            self.present(errorAlert1, animated: true, completion: nil)

        }else{
            Auth.auth().signIn(withEmail: LoginEmailTF.text!, password: LoginPasswordTF.text!) { (user, error) in
                if error == nil {
                    print("LLOGGFD")
                    self.goToMainInterface()
                }
                
                if error != nil {
                    let errorMsg = error?.localizedDescription
                    let errorAlert = UIAlertController(title: "Error", message: errorMsg!, preferredStyle: .alert)
                    let errorAlertOkayAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
                    errorAlert.addAction(errorAlertOkayAction)
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func goToMainInterface(){
        performSegue(withIdentifier: "ShowLogIn", sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextFields(){
        LoginPasswordTF?.addTarget(self, action: #selector(SignUpViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
        LoginEmailTF?.addTarget(self, action: #selector(SignUpViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
    }
    
    func handleTextFieldDidChanged(){
        guard let email = LoginEmailTF.text, !email.isEmpty, let password = LoginPasswordTF.text, !password.isEmpty else {
            LoginBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
            LoginBtn.isEnabled=false
            return
        }
        
        LoginBtn.setTitleColor( .black , for: UIControlState.normal)
        LoginBtn.isEnabled=true
    }


}

