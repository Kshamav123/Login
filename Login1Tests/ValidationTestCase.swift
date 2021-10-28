//
//  ValidationTestCase.swift
//  Login1Tests
//
//  Created by Kshama Vidyananda on 20/10/21.
//

import XCTest
@testable import Login1

class ValidationTestCase: XCTestCase {

    func testPasswordValisationEmptyStrings_IsInvalid(){
        
        let validation = Validation()
        let result = validation.isPasswordValid("")
        XCTAssertFalse(result)
    }
    func testPasswordValidationWhenLessThan8Characters_NoSpecialCharacters_IsInvalid(){
        
        let validation = Validation()
        let result = validation.isPasswordValid("abc123")
        XCTAssertFalse(result)
    }
    func testPasswordValidationWhenNoCharacters_IsInvalid(){
        
        let validation = Validation()
        let result = validation.isPasswordValid("12345678@")
        XCTAssertFalse(result)
    }
    func testPasswordValidationWhenLessthan8Characters_IsInvalid(){
        
        let validation = Validation()
        let result = validation.isPasswordValid("abc@12")
        XCTAssertFalse(result)
    }
    
    func testPasswordValidationWhenMoreThan8Characters_IsValid(){
        
        let validation = Validation()
        let result = validation.isPasswordValid("abc123#huhkss7s")
        XCTAssertTrue(result)
    }
    func testPasswordValidationWhenAtleastOneCharacter_IsValid(){
        
        let validation = Validation()
        let result = validation.isPasswordValid("123a45678@")
        XCTAssertTrue(result)
    }
    
    
    func testPasswordValidationWhenSpecialCharacter_IsValid(){
        
        let validation = Validation()
        let result = validation.isPasswordValid("123a45678@")
        XCTAssertTrue(result)
    }
    

}
