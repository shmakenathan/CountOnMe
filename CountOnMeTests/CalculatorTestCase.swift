//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Nathan on 07/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
// swiftlint:disable force_try
// swiftlint:disable force_cast
import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {
    var calculator: Calculator!
    let viewController = CalculatorViewController.self
    
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
        try! calculator.equal()
        calculator.reset()
        XCTAssertEqual(calculator.textToCompute, "")
    }
    
    // MARK: addDigit
    
    func testGivenTextToComputeWithFullOperationResolved_WhenTapAddDigit_ThenTextToComputePrintThisNumber() {
        calculator.addDigit(digit: 3)
        try! calculator.addOperator(mathOperator: .multiply)
        calculator.addDigit(digit: 5)
        try! calculator.equal()
        calculator.addDigit(digit: 2)
        XCTAssertEqual(calculator.textToCompute, "2")
    }
    
    func testGivenTextToComputeIsEmpty_WhenTapAddDigit_ThenTextToComputePrintThisNumber() {
        calculator.addDigit(digit: 3)
        XCTAssertEqual(calculator.textToCompute, "3")
    }
    
    func testGivenTextToComputeHaveAlreadyANumber_WhenTapAddDigit_ThenTextToComputePrintThisNumbers() {
        calculator.addDigit(digit: 3)
        calculator.addDigit(digit: 3)
        XCTAssertEqual(calculator.textToCompute, "33")
    }
    
    func testGivenTextToComputeHaveAlreadyAZero_WhenAddZero_ThenTextToComputePrintOnlyOneZero() {
        calculator.addDigit(digit: 0)
        calculator.addDigit(digit: 0)
        XCTAssertEqual(calculator.textToCompute, "0")
    }
    
    func testGivenTextToComputeHaveAlreadyAZero_WhenAddNumber_ThenTextToComputePrintOnlyThisNumber() {
        calculator.addDigit(digit: 0)
        calculator.addDigit(digit: 6)
        XCTAssertEqual(calculator.textToCompute, "6")
    }
    
    // MARK: addOperator
    
    func testGivenEmptyOperation_WhenAddOperatorDigitAndMultiply_ThenGetResult() {
        try! calculator.addOperator(mathOperator: .minus)
        calculator.addDigit(digit: 3)
        try! calculator.addOperator(mathOperator: .multiply)
        XCTAssertEqual(calculator.textToCompute, " - 3 × ")
        
    }
    
    func testGivenEmptyOperation_WhenAddSignOperator_ThenAddOperator() {
        try! calculator.addOperator(mathOperator: .plus)
        XCTAssertEqual(calculator.textToCompute, " + ")
        
    }
    
    func testGivenFullOperationWithResult_WhenAddSignOperator_ThenTextToComputeBecomeEmpty() {
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        calculator.addDigit(digit: 5)
        
        try! calculator.equal()
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
    
    func testGivenOneDigitAndOneOperator_WhenAddOperator_ThenOperatorAfterDigitChange() {
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        try! calculator.addOperator(mathOperator: MathOperator.multiply)
        XCTAssertEqual(calculator.textToCompute, "5 × ")
    }
    
    // MARK: equal
    
    func testGivenTextToComputeIsNotEmpty_WhenTapEqual_ThenTextToComputeIsTheResult() {
        
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        calculator.addDigit(digit: 5)
        
        try! calculator.equal()
        XCTAssertEqual(calculator.textToCompute, "5 + 5 = 10")
    }
    
    func testGivenTextToComputeBeginByASignOperatorAndFullOperation_WhenTapEqual_ThenTextToComputeIsTheResult() {
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        calculator.addDigit(digit: 5)
        
        try! calculator.equal()
        XCTAssertEqual(calculator.textToCompute, " + 5 + 5 = 10")
    }
    
    func testGivenDivideByZero_WhenTapEqual_ThenThrowCannotDivideByZero() {
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.divide)
        calculator.addDigit(digit: 0)
        XCTAssertThrowsError(
            try calculator.equal(),
            "") { (error) in
                let calculError = error as! CalculatorError
                XCTAssertEqual(calculError, CalculatorError.cannotDivideByZero)
        }
    }
    
    func testGivenDivideByZeroWithMoreThreeElements_WhenTapEqual_ThenThrowCannotDivideByZero() {
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.divide)
        calculator.addDigit(digit: 0)
        XCTAssertThrowsError(
            try calculator.equal(),
            "") { (error) in
                let calculError = error as! CalculatorError
                XCTAssertEqual(calculError, CalculatorError.cannotDivideByZero)
        }
    }
    
    func testGivenTextToComputeIsEmpty_WhenTapEqual_ThenThrowExpressionIsIncorrect() {
        XCTAssertThrowsError(
            try calculator.equal(),
            "") { (error) in
                let calculError = error as! CalculatorError
                XCTAssertEqual(calculError, CalculatorError.expressionIsIncorrect)
        }
    }
    
    func testGivenTextToComputeContainLessThanThreeElement_WhenTapEqual_ThenThrowNotEnoughtElements() {
        calculator.addDigit(digit: 5)
        XCTAssertThrowsError(
            try calculator.equal(),
            "") { (error) in
                let calculError = error as! CalculatorError
                XCTAssertEqual(calculError, CalculatorError.expressionHaveNotEnoughElement)
        }
    }
    
    func testGivenTextToComputeContainsPriority_WhenTapEqual_ThenTextToComputeIsTheResult() {
        
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.minus)
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.multiply)
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.plus)
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.divide)
        calculator.addDigit(digit: 5)
        try! calculator.addOperator(mathOperator: MathOperator.multiply)
        calculator.addDigit(digit: 5)
        try! calculator.equal()
        XCTAssertEqual(calculator.textToCompute, "5 + 5 - 5 × 5 + 5 ÷ 5 × 5 = -10")
    }
    
}
