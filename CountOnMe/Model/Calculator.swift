//
//  Calculator.swift
//  CountOnMe
//
//  Created by Nathan on 15/01/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
import Foundation


protocol CalculatorDelegate {
    func operationChanged(text: String)
}

class Calculator {
    
    // MARK: Properties - Internal
    
    var delegate: CalculatorDelegate?
    
    
    init(delegate: CalculatorDelegate? = nil) {
        self.delegate = delegate
    }
    
    
    // MARK: Methods - Internal
    
    func addOperator(mathOperator: MathOperator) throws {
        if elements.isEmpty && !mathOperator.isSignOperator {
            throw CalculatorError.expressionHaveNotEnoughElement
        }
        
        removePreviousOperatorIfNecessary()
        textToCompute.append(" \(mathOperator.rawValue) ")
    }
    
    // texttocompute = 3 +
    
    private func removePreviousOperatorIfNecessary() {
        
        guard let operationElement = elements.last else { return }
        
        if isOperationElementEqualToMathOperator(operationElement: operationElement) {
            textToCompute.removeLast(3)
        }
    }
    
    private func isOperationElementEqualToMathOperator(operationElement: String) -> Bool {
        for mathOperator in MathOperator.allCases where mathOperator.rawValue == operationElement {
            return true
        }
        return false
    }
    
    func addDigit(digit: Int) {
        if expressionHaveResult {
            textToCompute = ""
        }
        textToCompute.append("\(digit)")
    }
    
    func reset() {
        textToCompute = ""
    }
    
    ///Compute and return the result
    func Equal() throws {
        var result: Double
        var elementsForOperation: [String]
        
        guard expressionIsCorrect else {
            throw CalculatorError.expressionIsIncorrect
        }
        
        guard expressionHaveEnoughElement else {
            throw CalculatorError.expressionHaveNotEnoughElement
        }
        
        if elements.count > 3 {
            elementsForOperation = try solvePriorityOperationsFrom(operationsElements: elements)
        } else {
            elementsForOperation = elements
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
        textToCompute.append(elementsForOperation[0])
    }
    
    // MARK: Properties - Private
    
    var textToCompute : String = "" {
        didSet {
            delegate?.operationChanged(text: textToCompute)
        }
    }
    
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
    
    var canAddOperator: Bool {
        return isLastElementOperator
    }
    
    private var expressionHaveResult: Bool {
        return textToCompute.firstIndex(of: "=") != nil
    }
    
    
    // MARK: Methods - Private
    
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
    private func removed(tab : [String] , index : Int) -> [String] {
        var tableau = tab
        for _ in 0...2{
            tableau.remove(at: (index - 1))
        }
        return tableau
    }
    
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
    private func getNextPriorityOperator(elements : [String]) -> String {
        if elements.contains("÷") && elements.contains("×") {
            return elements[min(elements.firstIndex(of: "÷")!, elements.firstIndex(of: "×")!)]
        } else if elements.contains("÷") {
            return "÷"
        }
        return "×"
    }
    
    
}
