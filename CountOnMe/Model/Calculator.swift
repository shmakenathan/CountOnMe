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
    
    var delegate: CalculatorDelegate

    
    func addOperator(mathOperator: MathOperator) {
        textToCompute.append(" \(mathOperator.rawValue) ")
    }
    
    func addNumber(number : String) {
        if self.expressionHaveResult {
            self.textToCompute = ""
        }
        self.textToCompute.append(number)
    }
    
    
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
    }
    
    var textToCompute : String = "" {
        didSet {
            delegate.operationChanged(text: textToCompute)
        }
    }
    var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return isLastElementOperator
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var isLastElementOperator: Bool {
        for elements in elements{
            print(elements)
        }
        guard let lastElement = elements.last else {
            
            return false }
        
        for mathOperator in MathOperator.allCases where mathOperator.rawValue == lastElement {
            return false
        }
        
        return true
    }
    
    var canAddOperator: Bool {
        return isLastElementOperator
    }
    
    var expressionHaveResult: Bool {
        return textToCompute.firstIndex(of: "=") != nil
    }
    
    func reset() {
        for i in elements {
            print(i)
        }
        textToCompute = ""
    }
    func convertStringToDouble(mystring : String) -> Double {
        let mydouble = Double(mystring)!
        return mydouble
    }
    
    func convertDoubleToString(mydouble : Double) -> String {
        let mystring = String(mydouble)
        return mystring
    }
    
    func Equal(){
        var result : Double
        var elements = self.elements
        while elements.count > 1 {
            let left = convertStringToDouble(mystring: elements[0])
            let operand = elements[1]
            let right = convertStringToDouble(mystring: elements[2])
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "÷": result = left / right
            case "×": result = left * right
            default: fatalError("Unknown operator !")
            }
            elements = Array(elements.dropFirst(3))
            elements.insert("\(convertDoubleToString(mydouble: result))", at: 0)
        }
        self.textToCompute = elements[0]
        
    }
    
}
