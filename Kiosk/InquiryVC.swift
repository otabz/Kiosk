//
//  InquiryVC.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/6/17.check_response_bg
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit

class InquiryVC: UIViewController, UITextFieldDelegate {

    var code: Int!

    let successColor = UIColor(red: 27.0/255.0, green: 205.0/255.0, blue: 5.0/255.0, alpha: 1.0)
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewPrint: UIView!
    @IBOutlet weak var footer: UIImageView!
    @IBOutlet weak var txtReference: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReference: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.txtReference.delegate = self
        activityIndicator.scale(factor: 1.5)
        txtReference.addTarget(self, action: #selector(InquiryVC.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if code == 102 {
            self.footer.image = #imageLiteral(resourceName: "footer_tawuniya")
        } else if code == 300 {
            self.footer.image = #imageLiteral(resourceName: "footer_medgulf")
        } else if code == 201 {
            self.footer.image = #imageLiteral(resourceName: "footer_malath")
        } else if code == 204 {
            self.footer.image = #imageLiteral(resourceName: "footer_axa")

        } else if code == 205 {
            self.footer.image = #imageLiteral(resourceName: "footer_saico")
        } else if code == 207 {
            self.footer.image = #imageLiteral(resourceName: "footer_rajhi")
 
        } else if code == 209 {
            self.footer.image = #imageLiteral(resourceName: "footer_wala")

        } else if code == 302 {
            self.footer.image = #imageLiteral(resourceName: "footer_allianz")
 
        } else if code == 306 {
            self.footer.image = #imageLiteral(resourceName: "footer_enaya")
    
        } else if code == 208 {
            self.footer.image = #imageLiteral(resourceName: "footer_sagr")

        }
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
    
    @IBAction func inquire(_ sender: UIButton) {
        inquire()
    }
    
    func clear() {
        self.lblStatus.text = ""
        self.lblMessage.text = ""
        self.lblReference.text = ""
        self.lblDate.text = ""
        self.lblMessage.isHidden = true
        self.viewStatus.isHidden = true
        self.viewPrint.isHidden = true
    }
    
    func inquire() {
        clear()
        let msg = validate()
        
        if !msg.isEmpty {
            let alert = UIAlertController(title: msg, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        Inquiry.doDetail(referenceNo: txtReference.text!, providerCode: "601", payerCode: code, completion: {(result, error) -> Void in
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            if error != nil
            {
                let alert = UIAlertController(title: "Problem inquiring approval", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                //self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
            }
            else {
                self.lblMessage.isHidden = false
                self.viewStatus.isHidden = false
                self.viewPrint.isHidden = false
                
                if result?.outcome == "failure" {
                    self.show(outcome: result?.outcome, message: result?.message)
                } else {
                    self.show(status: result?.status, desc: result?.desc, date: result?.date)
                }
            }
        })

        }
    
    func show(outcome: String?, message: String?) {
        self.lblMessage.text = "Error: \(message!)"
        self.lblStatus.text = outcome!.uppercased()
        self.lblDate.text = Date().toString()
        self.lblStatus.textColor = UIColor.red
        
    }
    
    func show(status: String?, desc: String?, date: String?) {
        self.lblStatus.text = status!.uppercased()
        self.lblMessage.text = "Note: \(desc!)"
        self.lblReference.text = self.txtReference.text!
        self.lblDate.text = date!
        
        if self.lblStatus.text == "REJECTED" {
        self.lblStatus.textColor = UIColor.red
        } else {
            self.lblStatus.textColor = successColor
        }
    }
    
    func validate() -> String {
        var msg = ""
        
        if (txtReference.text?.isEmpty)! {
            msg = "Approval Reference required! \n"
        }
        return msg
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        clear()
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        inquire()
        return true
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
