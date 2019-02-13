//
//  PayerSelectionVC.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/5/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit

class PayerSelectionVC: UIViewController, PopToRootDelegate {

    var selection : Int!
    var isCheck : Bool!
    var haveReference: Bool!
    
    //@IBOutlet weak var lblPage: UILabel!
    var waitTimer = Timer() //make a timer variable, but don't do anything yet
    //var popupWaitTimer = Timer()
    //let waitTimeInterval:TimeInterval = CloseTimer.waitTimeInterval
    //let popupWaitTimerInterval:TimeInterval = CloseTimer.popupWaitTimeInterval
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func timerDidEnd() {
        /*let alert = UIAlertController(title: "Do you need more time?", message: nil, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Yes, i want more time", style: UIAlertActionStyle.default, handler: { action in
            
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
                                                  selector: #selector(PayerSelectionVC.dissmiss),
                                                  userInfo: alert,
                                                  repeats: false)
        })*/
        self.performSegue(withIdentifier: "timeUp", sender: self)
        
    }
    
    /*func dissmiss() {
        (popupWaitTimer.userInfo as! UIAlertController).dismiss(animated: true, completion: {
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
    }*/
    
    override func viewWillDisappear(_ animated: Bool) {
        waitTimer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*if self.isCheck == true {
            //self.lblPage.text = "CHECK ELIGIBILITY"
        } else {
            //self.lblPage.text = "APPROVAL INQUIRY"
        }*/
        lblHeader.text = "Select your Health Insurance\n".localized()
        btnBack.setTitle("Back".localized(), for: .normal)
        waitTimer = Timer.scheduledTimer(timeInterval: CloseTimer.waitTimeInterval,
                                         target: self,
                                         selector: #selector(PayerSelectionVC.timerDidEnd),
                                         userInfo: nil,
                                         repeats: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCheck" {
           let vc =  segue.destination as! CheckVC
           vc.code = self.selection
            vc.isCheck = self.isCheck
        } else if segue.identifier == "toDetailInquiry" {
            let vc = segue.destination as! InquiryVC
            vc.code = self.selection
        } else if segue.identifier == "timeUp" {
            let vc = segue.destination as! TimerVC
            vc.delegate = self
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        self.selection = sender.tag
        if self.isCheck == true {
            self.performSegue(withIdentifier: "toCheck", sender: self)
        } else if self.haveReference == true {
            self.performSegue(withIdentifier: "toDetailInquiry", sender: self)
        } else if self.haveReference == false {
            self.performSegue(withIdentifier: "toCheck", sender: self)
        }
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
