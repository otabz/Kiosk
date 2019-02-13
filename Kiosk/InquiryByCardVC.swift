//
//  InquiryByCardVC.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/6/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit

class InquiryByCardVC: UIViewController {

    let successColor = UIColor(red: 27.0/255.0, green: 205.0/255.0, blue: 5.0/255.0, alpha: 1.0)
    var ID : String!
    var policy: String!
    var code: Int!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblPolicy: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewPrint: UIView!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReference: UILabel!
    
    @IBOutlet weak var lblHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.scale(factor: 1.5)
        clear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblID.text = ID
        lblPolicy.text = policy

        if code == 102 {
            self.logo.image = #imageLiteral(resourceName: "footer1_tawuniya")
        } else if code == 300 {
            self.logo.image = #imageLiteral(resourceName: "footer1_medgulf")
        } else if code == 201 {
            self.logo.image = #imageLiteral(resourceName: "footer1_malath")
        } else if code == 204 {
            self.logo.image = #imageLiteral(resourceName: "footer1_axa")
        } else if code == 205 {
            self.logo.image = #imageLiteral(resourceName: "footer1_saico")
        } else if code == 207 {
            self.logo.image = #imageLiteral(resourceName: "footer1_rajhi")
        } else if code == 209 {
            self.logo.image = #imageLiteral(resourceName: "footer1_wala")
        } else if code == 302 {
            self.logo.image = #imageLiteral(resourceName: "footer1_allianz")
        } else if code == 306 {
            self.logo.image = #imageLiteral(resourceName: "footer1_enaya")
            
        } else if code == 208 {
            self.logo.image = #imageLiteral(resourceName: "footer1_sagr")
        }
        // localization
        lblHeader.text = "Your given infomration".localized()
        
        // inquire
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
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        Inquiry.doSummary(cardNo: lblID.text!, policyNo: lblPolicy.text!, providerCode: "601", payerCode: code, completion: {(result, error) -> Void in
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
                    self.show(status: result?.status, desc: result?.desc, date: result?.date, ref: result?.reference)
                }
            }
        })
    }
    
    func show(outcome: String?, message: String?) {
        self.lblMessage.text = "\(message!)"
        self.lblStatus.text = outcome!.uppercased()
        self.lblDate.text = Date().toString()
        self.lblStatus.textColor = UIColor.red
        
    }
    
    func show(status: String?, desc: String?, date: String?, ref: String?) {
        self.lblStatus.text = status!.uppercased()
        self.lblMessage.text = "\(desc!)"
        self.lblReference.text = ref!
        self.lblDate.text = date!
        
        if self.lblStatus.text == "REJECTED" {
            self.lblStatus.textColor = UIColor.red
        } else {
            self.lblStatus.textColor = successColor
        }
    }

    @IBAction func retry(_ sender: UIButton) {
        clear()
        inquire()
    }

    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
