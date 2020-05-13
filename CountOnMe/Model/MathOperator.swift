//
//  MathOperator.swift
//  CountOnMe
//
//  Created by Nathan on 18/03/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum MathOperator: String, CaseIterable {
    case plus = "+", minus = "-", divide = "÷", multiply = "×"
    
    var isSignOperator: Bool {
        switch self {
        case .divide, .multiply: return false
        case .minus, .plus: return true
        }
    }
}
