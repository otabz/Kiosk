//
//  CheckVC.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/5/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit

class CheckVC: UIViewController, UITextFieldDelegate, PopToRootDelegate {
    
    var code: Int!
    var isCheck: Bool!
    let alertMsg = "Please, provide : \n"
    var isTimerPaused = false
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblPolicy: UILabel!
    //@IBOutlet weak var lblPage: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtPolicy: UITextField!
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    
    var waitTimer = Timer() //make a timer variable, but don't do anything yet
    //var popupWaitTimer = Timer()
    //let waitTimeInterval:TimeInterval = CloseTimer.waitTimeInterval
    //let popupWaitTimerInterval:TimeInterval = CloseTimer.popupWaitTimeInterval
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.txtID.delegate = self
        self.txtPolicy.delegate = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(CheckVC.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CheckVC.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            }
    
    func timerDidEnd() {
        /*let alert = UIAlertController(title: "Do you need more time?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes, i need more time", style: UIAlertActionStyle.default, handler: { action in
            
            self.popupWaitTimer.invalidate()
            
        }))
        alert.addAction(UIAlertAction(title: "No, i want to quit", style: UIAlertActionStyle.destructive, handler: { action in
            self.popupWaitTimer.invalidate()
            _ = self.navigationController?.popToRootViewController(animated: true)
            
        }))
        // change to desired number of seconds (in this case 5 seconds)
        self.present(alert, animated: true, completion: {
            self.popupWaitTimer = Timer.scheduledTimer(timeInterval: self.popupWaitTimerInterval,
                                                       target: self,
                                                       selector: #selector(CheckVC.dissmiss),
                                                       userInfo: alert,
                                                       repeats: false)
        })*/
        if !self.isTimerPaused {
        self.performSegue(withIdentifier: "timeUp", sender: self)
        }
    }
    
    /*func dissmiss() {
        (popupWaitTimer.userInfo as! UIAlertController).dismiss(animated: true, completion: {
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
    }*/
    
    override func viewWillDisappear(_ animated: Bool) {
        waitTimer.invalidate()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if self.isCheck == true {
            //self.lblPage.text = "CHECK ELIGIBILITY"
            self.btnCheck.setTitle("Check Details", for: .normal)
        } else {
            //self.lblPage.text = "APPROVAL INQUIRY"
            self.btnCheck.setTitle("Inquire Approval", for: .normal)
        }
    
        
        if code == 102 {
            self.card.image = #imageLiteral(resourceName: "card_tawuniya")
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .numberPad
        } else if code == 300 {
            self.card.image = #imageLiteral(resourceName: "card_medgulf")
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .URL
        } else if code == 201 {
            self.card.image = #imageLiteral(resourceName: "card_malath")
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .numberPad
        } else if code == 204 {
            self.card.image = #imageLiteral(resourceName: "card_axa")
            self.lblID.text = "ID No"
            self.lblPolicy.text = "Policy No"
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .URL
        } else if code == 205 {
            self.card.image = #imageLiteral(resourceName: "card_saico")
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .numberPad
        } else if code == 207 {
            self.card.image = #imageLiteral(resourceName: "card_rajhi")
            self.lblID.text = "ID No."
            self.lblPolicy.text = "Policy No."
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .numberPad
        } else if code == 209 {
            self.card.image = #imageLiteral(resourceName: "card_wala")
            self.lblID.text = "ID No"
            self.lblPolicy.text = "Policy No"
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .URL
        } else if code == 302 {
            self.card.image = #imageLiteral(resourceName: "card_allianz")
            self.lblID.text = "ID No"
            self.lblPolicy.text = "Policy No"
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .URL
        } else if code == 306 {
            self.card.image = #imageLiteral(resourceName: "card_enaya")
            self.lblID.text = "ID No"
            self.lblPolicy.text = "Policy No"
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .numberPad
        } else if code == 208 {
            self.card.image = #imageLiteral(resourceName: "card_sagr")
            self.lblID.text = "ID No."
            self.lblPolicy.text = "Policy No."
            txtID.keyboardType = .numberPad
            txtPolicy.keyboardType = .URL
        }
        isTimerPaused = false
        waitTimer = Timer.scheduledTimer(timeInterval: CloseTimer.waitTimeInterval,
                                         target: self,
                                         selector: #selector(CheckVC.timerDidEnd),
                                         userInfo: nil,
                                         repeats: true)
        
        // localization
        txtID.placeholder = "Touch here to type".localized()
        txtPolicy.placeholder = "Touch here to type".localized()
        lblMsg.text = "Provide the information given on your Health Insurance Card".localized()
        btnCancel.setTitle("Cancel".localized(), for: .normal)
        btnCheck.setTitle("Check Details".localized(), for: .normal)
        btnChange.setTitle("Change".localized(), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEligibility" {
            let vc = segue.destination as! CheckResultVC
            vc.ID = self.txtID.text
            vc.policy = self.txtPolicy.text
            vc.code = self.code
        } else if segue.identifier == "toSummaryInquiry" {
            let vc = segue.destination as! InquiryByCardVC
            vc.code = self.code
            vc.ID = self.txtID.text
            vc.policy = self.txtPolicy.text
        } else if segue.identifier == "timeUp" {
            let vc = segue.destination as! TimerVC
            vc.delegate = self
        }
    }

    @IBAction func next(_ sender: UIButton) {
        process()
    }
    
    func process() {
        let msg = validate()
        
        if !msg.isEmpty {
            self.isTimerPaused = true
            let alert = UIAlertController(title: msg, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
                self.isTimerPaused = false
            }
            return
        }
        
        if self.isCheck == true {
            performSegue(withIdentifier: "toEligibility", sender: self)
        } else {
            performSegue(withIdentifier: "toSummaryInquiry", sender: self)
        }
    }
    
    func validate() -> String {
        var msg = ""

        if (txtID.text?.isEmpty)! {
            msg = self.lblID.text! + " required! \n"
        }
        if (txtPolicy.text?.isEmpty)! {
            msg = msg + self.lblPolicy.text! + " required!"
        }
        return msg
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func cancel(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        process()
        return true
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        //let keyboardFrame = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        //if let activeFieldPresent = activeField
        //{
           // if (!aRect.contains(lblMsg!.frame.origin))
           // {
            let position = CGRect(x: txtPolicy.frame.origin.x, y: txtPolicy.frame.origin.y-40, width: txtPolicy.frame.width, height: txtPolicy.frame.height)
                self.scrollView.scrollRectToVisible(position, animated: true)
           // }
        //}
        //scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 50)
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
        
    }
    
    func pop() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
