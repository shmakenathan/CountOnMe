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
        calculator.addNumber(number: String(sender.tag ))
    }
    
    ///Reset fonction
    @IBAction func didTapForReset(_ sender: Any) {
          calculator.reset()
    }
    
    ///Displays operand on screen
    @IBAction func tappedMathOperatorButton(_ sender: UIButton) {
           guard calculator.canAddOperator else {
               presentAlert(title: "Zéro!",message: "Un operateur est déja mis !")
               return
           }
           calculator.addOperator(mathOperator: MathOperator.allCases[sender.tag-1])
    }
    
    ///Show the result on the screen
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard calculator.expressionIsCorrect else {
            presentAlert(title: "Zéro!",message: "Entrez une expression correcte !")
            return
        }
        guard calculator.expressionHaveEnoughElement else {
            presentAlert(title: "Zéro!",message: "Demmarrez un nouveau calcul !")
            return
        }
        calculator.Equal()
    }
  
    // MARK: Methods - Internal
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Properties - Private
    
    private lazy var calculator = Calculator(delegate: self)

    // MARK: Methods - Private
    
    ///Displays the alert with the desired message
    private func presentAlert(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    

}

