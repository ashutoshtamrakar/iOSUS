//
//  LoginViewController.swift
//  TechnicalTest
//
//  Created by AT on 21/02/18.
//  Copyright © 2018 UbiqueSystems. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var tfEmailID: UITextField! {
        didSet {
            tfEmailID.drawUnderline(withColor: UITextField.Attributes.underlineColor, width: UITextField.Attributes.lineWidth)
            tfEmailID.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        }
    }
    
    @IBOutlet weak var tfPassword: UITextField! {
        didSet {
            tfPassword.drawUnderline(withColor: UITextField.Attributes.underlineColor, width: UITextField.Attributes.lineWidth)
            tfPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            tfPassword.drawRightView(rectangle: tfPassword.rightViewFrame(), imageName: "ClosedEye", toggle: (target: self, action: #selector(togglePasswordVisibility(sender:))))
        }
    }
    
    @objc func togglePasswordVisibility(sender: UIButton) {
        
        let txtFld = sender.superview as? UITextField
        if (txtFld?.isSecureTextEntry)! {
            txtFld?.isSecureTextEntry = false
            sender.setImage(UIImage(named: "OpenEye"), for: .normal)
        } else {
            txtFld?.isSecureTextEntry = true
            sender.setImage(UIImage(named: "ClosedEye"), for: .normal)
        }
    }
    
    @IBOutlet weak var btlogin: UIButton!
    
    @IBOutlet weak var btCreateAccount: UIButton!
    
    @IBOutlet var loginViewModel: LoginViewModel!
    
    fileprivate var activeTextField: UITextField!
    
    private var pressedButtonIdentifier: UIButton!
    
    
    // MARK: - IBAction
    
    @IBAction func buttonActionLogin(_ sender: UIButton) {
        
        sender.layer.backgroundColor =  (UIColor.colorWithHEXCode(hexStr: "#107387", alpha: 1.0)).cgColor
        pressedButtonIdentifier = sender
        
        if activeTextField != nil {
            activeTextField.resignFirstResponder()
        }
        if loginViewModel.validateUser() {
            if loginViewModel.authenticateUser() {
                displayAlertView("Succesfully logged in")
            }
        }
    }
    
    @IBAction func buttonActionCreateAccount(_ sender: UIButton) {
        
        sender.layer.backgroundColor =  (UIColor.colorWithHEXCode(hexStr: "#188594", alpha: 1.0)).cgColor
        pressedButtonIdentifier = sender
        
        if activeTextField != nil {
            activeTextField.resignFirstResponder()
        }
        if loginViewModel.validateUser() {
            loginViewModel.createUserAccount()
        }
    }
    
    
    // MARK: - Nib Loading
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bindViewModel()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignActiveTextField(gesture:))))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - ViewModel
    
    private func bindViewModel() {
        
        loginViewModel.alertMessage.bind(listener: { [unowned self] (message) in
            DispatchQueue.main.async { () -> Void in
                self.displayAlertView(message)
            }
        })
    }
    
    private func displayAlertView(_ message: String) {
        
        let alertViewController = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { alertAction in
            if self.pressedButtonIdentifier.tag == 0 {
                self.pressedButtonIdentifier.layer.backgroundColor =  (UIColor.colorWithHEXCode(hexStr: "#008BB3", alpha: 1.0)).cgColor
            } else {
                self.pressedButtonIdentifier.layer.backgroundColor =  (UIColor.colorWithHEXCode(hexStr: "#008BB3", alpha: 1.0)).cgColor
            }
            alertViewController.dismiss(animated: true, completion: nil)
        })
        
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @objc func resignActiveTextField(gesture: UIGestureRecognizer) {
        
        guard self.activeTextField != nil else {
            return
        }
        activeTextField.resignFirstResponder()
        activeTextField = nil
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        if textField == tfEmailID {
            textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.colorWithHEXCode(hexStr: "#CCF2FF", alpha: 0.60)])
            textField.text = loginViewModel.emailID.value
        } else if textField == tfPassword {
            textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.colorWithHEXCode(hexStr: "#CCF2FF", alpha: 0.60)])
            textField.text = loginViewModel.password.value
        }
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        loginViewModel.updateBindalbleObject(tag: textField.tag, withText: textField.text!, inRange: NSRangeFromString(textField.text!))
        
        if textField == tfEmailID {
            textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            
        } else if textField == tfPassword {
            textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        }
        
        activeTextField.resignFirstResponder()
        activeTextField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        loginViewModel.updateBindalbleObject(tag: textField.tag, withText: string, inRange: range)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfEmailID {
            tfPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        activeTextField = textField
        
        return true
    }
}


extension LoginViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        // User Information from Notification
        let info = notification.userInfo! as NSDictionary
        
        // Keyboard Size
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        // Keyboard Y Position
        let keyboardYPosition = self.view.frame.size.height - keyboardSize.height
        
        // Active TextField Y Position
        let rect = self.activeTextField.convert(self.activeTextField.frame, to: self.view)
        
        let editingTextFieldYPosition = rect.origin.y
        
        // Check view's Y Position
        if self.view.frame.origin.y >= 0 {
            if editingTextFieldYPosition > keyboardYPosition - 100 {
                UIView.animate(withDuration: 0.30, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn,
                               animations: {
                                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldYPosition - (keyboardYPosition - 100)),
                                                         width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.30, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
}
