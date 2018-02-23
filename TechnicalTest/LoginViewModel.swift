//
//  LoginViewModel.swift
//  TechnicalTest
//
//  Created by AT on 21/02/18.
//  Copyright © 2018 UbiqueSystems. All rights reserved.
//

import Foundation


struct LoginModel {
    
    var emailID = ""
    var password = ""
}

class LoginViewModel: NSObject {
    
    private let minimumPasswordLength = 8
    
    private lazy var sqliteDatabase = DatabaseHelper()
    
    public var emailID = Bindable("")
    public var password = Bindable("")
    public var alertMessage = Bindable("")
    
    
    var loginModel = LoginModel() {
        didSet {
            self.emailID.value = loginModel.emailID
            self.password.value = loginModel.password
        }
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
        
        sqliteDatabase.createDatabase()
        let _ = sqliteDatabase.createTable()
    }
    
    
    // MARK: - Validation
    
    private func validateEmailID() -> Bool {
        
        var validation = false
        
        let regularExpression = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let nsRegularExpression = try NSRegularExpression(pattern: regularExpression)
            let result = nsRegularExpression.matches(in: emailID.value, options: [], range: NSRange(location: 0, length: (emailID.value as NSString).length))
            if !result.isEmpty {
                validation = true
            }
        } catch let error as NSError {
            print("Invalid Regex: \(error.localizedDescription)")
            validation = false
        }
        return validation
    }
    
    private func validatePassword() -> String {
        
        var missingCriteriaStr = ""
        
        if (!RegularExpression.checkUpperCase(str: password.value)) {
            missingCriteriaStr += "1 UpperCase Letter, "
        }
        if (!RegularExpression.checkLowerCase(str: password.value)) {
            missingCriteriaStr += "1 LowerCase Letter, "
        }
        if (!RegularExpression.checkNumericDigits(str: password.value)) {
            missingCriteriaStr += "1 Digit, "
        }
        if missingCriteriaStr.hasSuffix(", ") {
            let tempStr = missingCriteriaStr.prefix(missingCriteriaStr.count - 2)
            return String(tempStr)
        }
        return missingCriteriaStr
    }
    
    public func validateUser() -> Bool {
        
        var validationErrorText = ""
        
        if (emailID.value.isEmpty && password.value.isEmpty) {
            validationErrorText = "Email & Password cannot be blank."
        } else if (emailID.value.isEmpty) {
            validationErrorText = "Email cannot be blank."
        } else if (!validateEmailID()) {
            validationErrorText = "Invalid email id."
        } else if (password.value.isEmpty) {
            validationErrorText = "Password cannot be blank."
        } else if (password.value.count < minimumPasswordLength) {
            validationErrorText = "Password must be \(minimumPasswordLength) characters long."
        } else {
            let missingCriteriaStr = validatePassword()
            if !missingCriteriaStr.isEmpty {
                validationErrorText = "Password must contain " + missingCriteriaStr
            }
        }
        if !validationErrorText.isEmpty {
            alertMessage.value = validationErrorText
            return false
        }
        return true
    }
    
    public func createUserAccount() {
        
        let registeredUserOrError = sqliteDatabase.retreiveAccount(emailAddress: emailID.value)
        if registeredUserOrError is User {
            alertMessage.value = "Account with email address \(emailID.value) already exists."
        } else {
            if sqliteDatabase.addAccount(user: User(emailID: emailID.value, password: password.value)) {
                alertMessage.value = "Account created successfully."
            }
        }
    }
    
    public func authenticateUser() -> Bool {
        
        let registeredUserOrError = sqliteDatabase.retreiveAccount(emailAddress: emailID.value)
        if registeredUserOrError is User {
            if ((registeredUserOrError as! User).password == password.value) {
                return true
            } else {
                alertMessage.value = "Incorrect Password!"
            }
        } else {
            alertMessage.value = registeredUserOrError as! String
        }
        return false
    }
}


extension LoginViewModel {
    
    public func updateBindalbleObject(tag: Int, withText: String, inRange: NSRange) {
        if tag == 0 {
            loginModel.emailID = withText
        } else if tag == 1 {
            loginModel.password = withText
        }
    }
}
