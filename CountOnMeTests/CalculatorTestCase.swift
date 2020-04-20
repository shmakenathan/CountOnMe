//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Nathan on 07/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {
    var calculator: Calculator!
    let viewController = ViewController.self
    
    override func setUp() {
        super.setUp()
        
        calculator = Calculator()
    }
    
    // MARK: Reset
    
    func testGivenTextToComputeEmpty_WhenTapReset_ThenTextToComputeIsStillEmpty() {
        calculator.reset()
        XCTAssertEqual(calculator!.textToCompute, "")
    }
    
    func testGivenTextToComputeWithSingleDigit_WhenTapReset_ThenTextToComputeBecomeEmpty() {
        calculator.addDigit(digit: 3)
        calculator.reset()
        XCTAssertEqual(calculator.textToCompute, "")
    }
    
    func testGivenTextToComputeWithFullOperation_WhenTapReset_ThenTextToComputeBecomeEmpty() {
        calculator.addDigit(digit: 3)
        try! calculator.addOperator(mathOperator: .multiply)
        calculator.addDigit(digit: 5)
        try! calculator.Equal()
        calculator.reset()
        XCTAssertEqual(calculator.textToCompute, "")
    }
    
    
    // MARK: addOperator
    
    
    func testGivenEmptyOperation_WhenAddSignOperator_ThenAddOperator() {
        try! calculator.addOperator(mathOperator: .plus)
        XCTAssertEqual(calculator.textToCompute, " + ")
        
    }
    
    func testGivenEmptyOperation_WhenAddNotSignOperator_ThenThrowNotEnoughtElements() {
        XCTAssertThrowsError(
            try calculator.addOperator(mathOperator: .multiply),
            "") { (error) in
                let calculError = error as! CalculatorError
                XCTAssertEqual(calculError, CalculatorError.expressionHaveNotEnoughElement)
        }
        
        
    }
    func testGivenEmptyOperation_WhenAddTwoConsecutivesOperator_ThenReplaceTheFirstByThSecond() {
        try! calculator.addOperator(mathOperator: .plus)
        try! calculator.addOperator(mathOperator: .minus)
        XCTAssertEqual(calculator.textToCompute, " - ")
        
    }
    
    func testGivenOneDigit_WhenAddOperator_ThenOperatorAddedAfterDigit() {
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        XCTAssertEqual(calculator.textToCompute, "5 + ")
    }
    
    func testGivenTextToComputeIsNotEmpty_WhenTapEqual_ThenTextToComputeIsTheResult() {
        
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        calculator.addDigit(digit: 5)
        
        try! calculator.Equal()
        XCTAssertEqual(calculator.textToCompute, "5 + 5 = 10.0")
    }
}
