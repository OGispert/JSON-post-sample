//
//  ViewController.swift
//  jsonCodeSample
//
//  Created by Othmar Gispert on 2/1/17.
//  Copyright © 2017 Othmar Gispert. All rights reserved.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dataInput = Input()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        zipCodeField.delegate = self
        dobField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if textField == zipCodeField {
            
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        
        } else {
        
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            let inverseSet = NSCharacterSet(charactersIn:"0123456789/").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            
            return (string == filtered && newString.length <= maxLength)
        }
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height+10
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func submit() {
        
        guard let name = nameField.text else {
            print("No name to submit")
            return
        }
        
        guard let last = lastNameField.text else {
            print("No last name to submit")
            return
        }
        
        guard let dob = dobField.text else {
            print("No DOB to submit")
            return
        }
        
        guard let zip = zipCodeField.text else {
            print("No zip code to submit")
            return
        }
        
        if let dateFromString = dob.dateFromISO8601 {
            
            self.dataInput.jsonPost(name.capitalized, last.capitalized, dateFromString.iso8601, zip)
            
        } else {
            
            let alert = UIAlertController(title: "Error!", message: "Your DOB doesn't seem to be in the correct format.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedToNetwork() -> Bool { // Check for conectivity
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    @IBAction func sendButtonPressen(_ sender: UIButton) {
        
        if connectedToNetwork() { //If there is connection and everything is ok: Success!!
        
            self.submit()
            
            let alert = UIAlertController(title: "Success!", message: "Your information has been sent.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else { // if there is a problem with connection: Fail!!
            
            let alert = UIAlertController(title: "Upss!", message: "You don't have internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

