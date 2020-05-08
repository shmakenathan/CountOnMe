//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit



extension ViewController: CalculatorDelegate {
    
    
    func operationChanged(text: String) {
        textView.text = text
    }
    
   
}



class ViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    
    // MARK: IBAction
    
    ///Displays numbers on screen
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        calculator.addDigit(digit: sender.tag)
    }
    
    ///Reset fonction
    @IBAction func didTapForReset(_ sender: Any) {
          calculator.reset()
    }
    
    ///Displays operand on screen
    @IBAction func tappedMathOperatorButton(_ sender: UIButton) {
       do {
            try calculator.addOperator(mathOperator: MathOperator.allCases[sender.tag - 1])
        } catch {
            handleError(error: error)
        }
    }
    
    ///Show the result on the screen
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        do {
            try calculator.equal()
        } catch {
            handleError(error: error)
        }
    }
  
    // MARK: Methods - Internal
    
    // MARK: Properties - Private
    
    private lazy var calculator = Calculator(delegate: self)

    // MARK: Methods - Private
    
    private func handleError(error: Error) {
        guard let calculatorError = error as? CalculatorError else {
            handlUnknownError(error: error)
            return
        }
        handleCalculatorError(error: calculatorError)
    }
    
    private func handleCalculatorError(error: CalculatorError) {
        presentAlert(title: error.title, message: error.message)
    }
    
    private func handlUnknownError(error: Error) {
        presentAlert(title: "Unknown error", message: "An unknown error occured \(error.localizedDescription)")
    }
    
    
    ///Displays the alert with the desired message
    private func presentAlert(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    

    
}

