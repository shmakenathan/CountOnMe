//
//  CalculatorDelegateMock.swift
//  CountOnMeTests
//
//  Created by Nathan on 13/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation
@testable import CountOnMe

class CalculatorDelegateMock {
    var textToCompute: String!
}

extension CalculatorDelegateMock: CalculatorDelegate {
    func operationChanged(text: String) {
        textToCompute = text
    }
}
