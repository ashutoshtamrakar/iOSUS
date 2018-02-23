//
//  DatabaseHelper.swift
//  TechnicalTest
//
//  Created by AT on 22/02/18.
//  Copyright © 2018 UbiqueSystems. All rights reserved.
//

import Foundation
import SQLite3

class DatabaseHelper {
    
    private var dbPointer: OpaquePointer?
    
    private var fileURL: URL!
    
    public func createDatabase() {
        fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDatabase.sqlite")
        print("\(fileURL)")
    }
    
    public func createTable() -> Bool {
        
        if sqlite3_open(fileURL.path, &dbPointer) == SQLITE_OK {
            if sqlite3_exec(dbPointer, "CREATE TABLE IF NOT EXISTS Users (id INTEGER PRIMARY KEY AUTOINCREMENT, emailAddress TEXT, password TEXT)", nil, nil, nil) != SQLITE_OK {
                let errorMessage = String(cString: sqlite3_errmsg(dbPointer)!)
                print("Error while creating table \(errorMessage)")
                return false
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(dbPointer)!)
            print("Error while opening database \(errorMessage)")
            return false
        }
        return true
    }
    
    public func addAccount(user: User) -> Bool {
        
        var statement: OpaquePointer?
        
        let userEmailAddress = (user.emailID!).cString(using: String.Encoding.utf8)
        let password = (user.password!).cString(using: String.Encoding.utf8)
        
        let insertQuery = "INSERT INTO Users (emailAddress, password) VALUES (?, ?)"
        
        if sqlite3_prepare_v2(dbPointer, insertQuery, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(dbPointer)!)
            print("Error while preparing insert query \(errorMessage)")
            return false
        }
        
        if sqlite3_bind_text(statement, 1, userEmailAddress, -1, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(dbPointer)!)
            print("Error while binding email id \(errorMessage)")
            return false
        }
        
        if sqlite3_bind_text(statement, 2, password, -1, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(dbPointer)!)
            print("Error while binding password \(errorMessage)")
            return false
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errorMessage = String(cString: sqlite3_errmsg(dbPointer)!)
            print("Error while inserting into database \(errorMessage)")
            return false
        }
        sqlite3_finalize(statement)
        
        return true
    }
    
    public func retreiveAccount(emailAddress: String) -> Any {
        
        var statement: OpaquePointer?
        
        let retreiveQuery = "SELECT * FROM Users"
        var user: User? = nil
        
        if sqlite3_prepare_v2(dbPointer, retreiveQuery, -1, &statement, nil) == SQLITE_OK {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                let queryEmailAddress = sqlite3_column_text(statement, 1)
                if emailAddress == String(cString: queryEmailAddress!) {
                    user = User.init(emailID: emailAddress, password: String(cString: sqlite3_column_text(statement, 2)))
                    break
                }
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(dbPointer)!)
            print("Error while retreiving user account \(errorMessage)")
            return (false, "Error while retreiving user account")
        }
        sqlite3_finalize(statement)
        
        return ((user != nil) ? (user as Any) : "The account doesn't exists.")
    }
}
