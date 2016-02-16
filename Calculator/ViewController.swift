//
//  ViewController.swift
//  Calculator
//
//  Created by Darin on 10/27/15.
//  Copyright © 2015 Darin Lemons. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var operandStackLabel: UILabel!
    
    var operandStack = Array<Double>()
    var userIsInTheMiddleOfTypingNumber: Bool =  false
    var displayValue: Double {
        get {
            //convert to Double
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        operandStack = []
        display.text = "0"
        operandStackLabel.text = ""
        userIsInTheMiddleOfTypingNumber = false
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func appendDecimal(sender: UIButton) {
        let decimal = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            if  (display.text!.rangeOfString(".") != nil) {
                return
            } else {
                display.text = display.text! + decimal
            }
        } else {
            display.text = decimal
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        operandStackLabel.text = operandStackLabel.text! + "\(sender.currentTitle!),"

        switch operation {
        case "×" : performOperation() { $0 * $1 }
        case "÷" : performOperation() { $1 / $0 }
        case "+" : performOperation() { $0 + $1 }
        case "−" : performOperation() { $1 - $0 }
        case "sin()" : performOperation2() { sin($0) }
        case "cos()" : performOperation2() { cos($0) }
        case "√" : performOperation2() { sqrt($0) }
        case "π" : performConstantAction(sender.currentTitle!)
        default: break
        }
    }
    
    func performConstantAction(constant: String) -> Double {
        let constantOperation = constant
        
        switch constantOperation {
        case "π" :
            if userIsInTheMiddleOfTypingNumber == false {
                displayValue = M_PI
                enter()
            } else {
                enter()
                displayValue = M_PI
                enter()
            }
        default : break
        }
        return displayValue
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation2(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        operandStack.append(displayValue)
        operandStackLabel.text = operandStackLabel.text! + "\(displayValue),"
        print("operandStack = \(operandStack)")
    }
    
    
}

