//
//  Calculator.swift
//  CountOnMe
//
//  Created by Nathan on 15/01/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
//swiftlint:disable cyclomatic_complexity

import Foundation
protocol CalculatorDelegate: AnyObject {
    func operationChanged(text: String)
}

class Calculator {
    
    // MARK: Properties - Internal
    
    weak var delegate: CalculatorDelegate?
    
    init(delegate: CalculatorDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: Methods - Internal
    
    ///Add operator to compute
    func addOperator(mathOperator: MathOperator) throws {
        if expressionHaveResult {
            textToCompute = ""
        }
        if (elements.isEmpty && !mathOperator.isSignOperator) || (!elements.isEmpty && isOperationElementEqualToMathOperator(operationElement: elements[0]) && !mathOperator.isSignOperator && elements.count > 2) {
            throw CalculatorError.expressionHaveNotEnoughElement
        }
        
        removePreviousOperatorIfNecessary()
        textToCompute.append(" \(mathOperator.rawValue) ")
    }
    
    ///Add number to compute
    func addDigit(digit: Int) {
        if expressionHaveResult {
            textToCompute = ""
        }
        if !elements.isEmpty && elements.last == "0" {
          textToCompute = String(textToCompute.dropLast(1))
        }
        textToCompute.append("\(digit)")
    }
    
    ///Reset display
    func reset() {
        textToCompute = ""
    }
    
    ///Compute and return the result
    func equal() throws {
        var result: Double
        var elementsForOperation: [String]
        
        guard expressionIsCorrect else {
            throw CalculatorError.expressionIsIncorrect
        }
        
        guard expressionHaveEnoughElement else {
            throw CalculatorError.expressionHaveNotEnoughElement
        }
        let myNewElements = beginBySignOperator()
        if myNewElements.count > 3 {
            elementsForOperation = try solvePriorityOperationsFrom(operationsElements: myNewElements)
        } else {
            elementsForOperation = myNewElements
        }
        
        while elementsForOperation.count > 1 {
            guard
                let left = convertStringToDouble(mystring: elementsForOperation[0]),
                let right = convertStringToDouble(mystring: elementsForOperation[2])
                else {
                    throw CalculatorError.invalidCharactersInExpression
            }
            
            let operand = elementsForOperation[1]
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "÷":
                guard
                    right != 0 else {
                        throw CalculatorError.cannotDivideByZero
                }
                result = left / right
            case "×":
                result = left * right
            default: fatalError("Unknown operator !")
            }
            
            elementsForOperation = Array(elementsForOperation.dropFirst(3))
            elementsForOperation.insert("\(convertDoubleToString(mydouble: result))", at: 0)
        }
        
        textToCompute.append(contentsOf: " = ")
        
        let formattedResultString = try getFormattedResultFrom(elementsForOperation: elementsForOperation)
    
        textToCompute.append(formattedResultString)
    }
    
    // MARK: Properties - Private
    
    var textToCompute: String = "" {
        didSet {
            delegate?.operationChanged(text: textToCompute)
        }
    }
    
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumFractionDigits = 4
        return numberFormatter
    }()
    
    private var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
    }
    
    private var isLastElementOperator: Bool {
        guard let lastElement = elements.last else {
            return false }
        for mathOperator in MathOperator.allCases where mathOperator.rawValue == lastElement {
            return false
        }
        return true
    }
    
    private var expressionIsCorrect: Bool {
        return isLastElementOperator
    }
    
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    private var expressionHaveResult: Bool {
        return textToCompute.firstIndex(of: "=") != nil
    }
    
    // MARK: Methods - Private
    
    ///Delete operator if necessary
    private func removePreviousOperatorIfNecessary() {
           guard let operationElement = elements.last else { return }
           if isOperationElementEqualToMathOperator(operationElement: operationElement) {
               textToCompute.removeLast(3)
           }
        
    }

    ///Test if it's a sign operator
    private func isOperationElementEqualToMathOperator(operationElement: String) -> Bool {
           for mathOperator in MathOperator.allCases where mathOperator.rawValue == operationElement {
               return true
           }
           return false
    }
    
    ///Delete elements of Calcul
    private func beginBySignOperator() -> [String] {
        var myElements = elements
        if isOperationElementEqualToMathOperator(operationElement: elements[0]) {
            let myNewElement = myElements[0] + myElements[1]
            myElements.remove(at: 0)
            myElements.remove(at: 0)
            myElements.insert(myNewElement, at: 0)
            return myElements
        }
        return myElements
    }
    
    ///Convert to String
    private func convertStringToDouble(mystring: String) -> Double? {
        let mydouble = Double(mystring)
        return mydouble
    }
    
    ///Convert to Double
    private func convertDoubleToString(mydouble: Double) -> String {
        let mystring = String(mydouble)
        return mystring
    }
    
    ///Remove the 3 elements of an operation
    private func removed(tab: [String], index: Int) -> [String] {
        var tableau = tab
        for _ in 0...2 {
            tableau.remove(at: (index))
        }
        return tableau
    }
    
    ///Returns the formatted result
    private func getFormattedResultFrom(elementsForOperation: [String]) throws -> String {
        guard
            let resultAsString = elementsForOperation.first,
            let resultAsNumber = Double(resultAsString)
            else { throw CalculatorError.resultIsInvalid }
        
        let resultAsNSNumber = NSNumber(value: resultAsNumber)
        
        guard let formattedResultString = numberFormatter.string(from: resultAsNSNumber) else { throw CalculatorError.resultConversionFailed }
        return formattedResultString
    }
    
    ///Test if there are priorities
    private func containsPriority(operation: [String]) -> Bool {
        operation.contains("÷") || operation.contains("×")
    }
    
    ///Allows to calculate in priority the operation multiplication and division
    private func solvePriorityOperationsFrom(operationsElements: [String]) throws -> [String] {
        var mutableOperation = operationsElements
        while containsPriority(operation: mutableOperation) {
            
            let operationUnitResult: Double
            let nextPriorityOperator = getNextPriorityOperator(elements: mutableOperation)
            
            guard
                let nextPriorityOperatorIndex = mutableOperation.firstIndex(of: nextPriorityOperator),
                let left = Double(mutableOperation[nextPriorityOperatorIndex - 1]),
                let right = Double(mutableOperation[nextPriorityOperatorIndex + 1]) else {
                    throw CalculatorError.expressionIsIncorrect
            }
            
            switch mutableOperation[nextPriorityOperatorIndex] {
            case "÷":
                guard
                    right != 0 else {
                        throw CalculatorError.cannotDivideByZero
                }
                
                operationUnitResult = left / right
                
            case "×":
                operationUnitResult = left * right
            default: fatalError("Unknown operator !")
            }
            mutableOperation.insert(String(operationUnitResult), at: nextPriorityOperatorIndex - 1)
            mutableOperation = removed(tab: mutableOperation, index: nextPriorityOperatorIndex)
        }
        return mutableOperation
    }
    
    ///allows to return which of the 2 symbols is first
    private func getNextPriorityOperator(elements: [String]) -> String {
        if elements.contains("÷") && elements.contains("×") {
            return elements[min(elements.firstIndex(of: "÷")!, elements.firstIndex(of: "×")!)]
        } else if elements.contains("÷") {
            return "÷"
        }
        return "×"
    }
    
}
