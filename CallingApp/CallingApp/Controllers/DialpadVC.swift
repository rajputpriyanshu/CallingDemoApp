//
//  ViewController.swift
//  CallingApp
//
//  Created by ATLOGYS on 03/03/21.
//

import UIKit
import AVFoundation
import FlagPhoneNumber

class DialpadVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var viewCCode: UIView!
    @IBOutlet weak var txtDialPad: FPNTextField!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblCCode: UILabel!
    @IBOutlet var btnShowCountryCode:UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet var btnDialNumber: [UIButton]!
    @IBOutlet weak var btnClearText: UIButton!
    
    //MARK:- VARIABLES
    var numberToCall = ""
    var isNumberValid = false
    
    //MARK:- LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnDialNumber.sort(by: {$0.tag<$1.tag})
        
        for btns in btnDialNumber {
            let maxFrame = max(btns.frame.height,btns.frame.width)
            btns.layer.cornerRadius = maxFrame / 2
        }
        
        btnCall.addTarget(self, action: #selector(performCall), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(clearTextUsingLongPress(_:)))
        btnClearText.addTarget(self, action: #selector(clearTextOnSinglePress(_:)), for: .touchUpInside)
        btnClearText.addGestureRecognizer(longPress)
        txtDialPad.displayMode = .picker
        txtDialPad.delegate = self
        txtDialPad.inputView = UIView()
        txtDialPad.setFlag(key: .IN)
        let longPressForPositive = UILongPressGestureRecognizer(target: self, action: #selector(enterZero(_:)))
        btnDialNumber[9].addGestureRecognizer(longPressForPositive)
        btnClearText.isHidden = true
        
        self.txtDialPad.adjustsFontForContentSizeCategory = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        txtDialPad.becomeFirstResponder()
    }
    
    
    @objc func enterZero(_ sender:UILongPressGestureRecognizer){
        
        if sender.state == .began {
            AudioServicesPlaySystemSound(1200)
            txtDialPad.insertText("+")
            btnClearText.isHidden = false
            
        }
    }
        
    
    //Method to replace alphabets
    private func replaceCharactersWithNumbers(string: String) {
        let pattern = "[^+0-9]"
        
        let result = string.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
        
        txtDialPad.text = result
        btnClearText.isHidden = false
    }
    
    //Handles paste operation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if string.count > 1{
            //User did copy & paste
            
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")
            let characterSet = CharacterSet(charactersIn: string)
            
            if ( allowedCharacters.isSuperset(of: characterSet) ) {
                
                btnClearText.isHidden = false
            } else {
                replaceCharactersWithNumbers(string: string)
            }
            
            return allowedCharacters.isSuperset(of: characterSet)
        }else{
            //User did input by keypad
        }
        return true
    }
    
    @objc func clearTextUsingLongPress(_ sender: UILongPressGestureRecognizer) {
        
        if ( sender.state == .began ) {
            txtDialPad.text = ""
        }
    }
    

    //Clear text on single press
   @objc func clearText() {
    txtDialPad.deleteBackward()
    
 }
    
    //Clears text on single press
    @objc func clearTextOnSinglePress(_ sender: UIButton) {
        
        if ( txtDialPad.text?.count == 0 ) {
            return
        }
        clearText()
        
    }
    
    @IBAction func btnsAppend(_ sender: UIButton) {
        
        var digit1 : String = "\(sender.tag)"
        
        if ( sender.tag == 11 ) {
            digit1 = "*"
            AudioServicesPlaySystemSound(1210)
        } else if ( sender.tag == 10 ) {
            digit1 = "0"
            AudioServicesPlaySystemSound(1200)
        } else if ( sender.tag == 12 ) {
            digit1 = "#"
            AudioServicesPlaySystemSound(1211)
        }
        
        if (sender.tag == 1) {
            AudioServicesPlaySystemSound(1201)
        } else if (sender.tag == 2) {
            AudioServicesPlaySystemSound(1202)
        } else if (sender.tag == 3) {
            AudioServicesPlaySystemSound(1203)
        } else if (sender.tag == 4) {
            AudioServicesPlaySystemSound(1204)
        }else if (sender.tag == 5) {
            AudioServicesPlaySystemSound(1205)
        }else if (sender.tag == 6) {
            AudioServicesPlaySystemSound(1206)
        }else if (sender.tag == 7) {
            AudioServicesPlaySystemSound(1207)
        }else if (sender.tag == 8) {
            AudioServicesPlaySystemSound(1208)
        }else if (sender.tag == 9) {
            AudioServicesPlaySystemSound(1209)
        }
        
        //it will insert text where the cursor is
        txtDialPad.insertText(digit1)
        btnClearText.isHidden = false
    }
    
    
    //MARK:- Call Button Action
    @objc func performCall(){
        
        if isNumberValid {
            let inCallView = self.storyboard?.instantiateViewController(withIdentifier: "InCallVC") as! InCallVC
            inCallView.modalPresentationStyle = .overCurrentContext
            inCallView.outgoingValue = self.numberToCall
            self.present(inCallView, animated: false, completion: nil)
        } else {
            self.showAlert("Invalid Number", "Please enter the valid number")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- FPNTextFieldDelegate Methods
extension DialpadVC: FPNTextFieldDelegate {
    func fpnDisplayCountryList() {}
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        self.isNumberValid = isValid
        numberToCall = textField.getFormattedPhoneNumber(format: .E164) ?? ""
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
    }
}
