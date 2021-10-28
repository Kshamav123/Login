//
//  EmailValidationTestCase.swift
//  Login1Tests
//
//  Created by Kshama Vidyananda on 20/10/21.
//

import XCTest
@testable import Login1
class EmailValidationTestCase: XCTestCase {

   
    func testWhenEmailDoesNotContain_AtTheRate_IsInvalid(){
        
        let validation = Validation()
        let result = validation.isEmailValid("avc23gmail.com")
        XCTAssertFalse(result)
    }
    func testWhenEmailDoesNotContain_Dot_IsInvalid(){
        
        let validation = Validation()
        let result = validation.isEmailValid("avc23gmailcom")
        XCTAssertFalse(result)
    }
    func testWhenEmailDoesNotContain_com_IsInvalid(){
        
        let validation = Validation()
        let result = validation.isEmailValid("avc@23gmail.")
        XCTAssertFalse(result)
    }
    
    func testWhenEmailContainsMoreThanThreeCharactersAtTheLast_IsInvalid(){
        
        let validation = Validation()
        let result = validation.isEmailValid("avc@23gmail.fgdffg")
        XCTAssertFalse(result)
    }
    
    func testWhenEmailContainsSpecialCharacter_IsInvalid(){
        
        let validation = Validation()
        let result = validation.isEmailValid("av#c@23gmail.fgdffg")
        XCTAssertFalse(result)
    }
    
    func testForEmailWhenItIs_Valid(){

        let validation = Validation()
        let result = validation.isEmailValid("avc_3@jdjc.com")
        XCTAssertTrue(result)

    }
}
