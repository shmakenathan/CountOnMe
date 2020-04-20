//
//  CalculatorError.swift
//  CountOnMe
//
//  Created by Nathan on 07/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum CalculatorError: Error {
case cannotDivideByZero
case expressionIsIncorrect
case expressionHaveNotEnoughElement
case invalidCharactersInExpression

var title: String {
    switch self {
    case .cannotDivideByZero,
         .expressionHaveNotEnoughElement,
         .expressionIsIncorrect: return "Error"
    default: return "Unknown error"
    }
}

var message: String {
    switch self {
    case .cannotDivideByZero: return "Can not divide by zero"
    case .expressionHaveNotEnoughElement: return "Expression have not enough element"
    case .expressionIsIncorrect: return "Expression is incorrect"
    default: return "Unknown error"
    }
}
 var localizedDescription: String {
        title + " " + message
    }
}
