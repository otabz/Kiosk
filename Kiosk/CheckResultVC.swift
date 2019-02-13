//
//  CheckResultVC.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/5/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit

class CheckResultVC: UIViewController, PopToRootDelegate, PauseTimerDelegate, Epos2DiscoveryDelegate {

    var filteroption_ : Epos2FilterOption?
    var printerTarget: String?
    var printerType: Int?
    var printerInterface: String?
    var printerAddress: String?
    
    let successColor = UIColor(red: 27.0/255.0, green: 205.0/255.0, blue: 5.0/255.0, alpha: 1.0)
    var ID : String!
    var policy: String!
    var code: Int!
    var name: String?
    var isPrintable = true
    var isTimerPaused = false
    
    var isScan = false
    var scanCloseDelegate: PopToRootDelegate?
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblPolicy: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewPrint: UIView!
    
    @IBOutlet weak var lblStatusEligibility: UILabel!
    @IBOutlet weak var lblShareAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    
    @IBOutlet weak var lblRefApproval: UILabel!
    @IBOutlet weak var lblStatusApproval: UILabel!
    @IBOutlet weak var lblRequestHeader: UILabel!
    
    @IBOutlet weak var lblStatusStatic: UILabel!
    @IBOutlet weak var lblApprovalStatic: UILabel!
    @IBOutlet weak var btnPrint: UIButton!
    var waitTimer = Timer() //make a timer variable, but don't do anything yet

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filteroption_ = Epos2FilterOption()
        filteroption_?.deviceType = EPOS2_TYPE_PRINTER.rawValue
        activityIndicator.scale(factor: 1.5)
        clear()
    }
    
    func timerDidEnd() {
        if !self.isTimerPaused {
        self.performSegue(withIdentifier: "timeUp", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        waitTimer.invalidate()
        var result: Int32 = EPOS2_SUCCESS.rawValue
        while true {
            result = Epos2Discovery.stop()
            if result != EPOS2_ERR_PROCESSING.rawValue {
                break
            }
        }
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
        lblRequestHeader.text = "Your given infomration".localized()
        lblMessage.text = "Requesting . . .".localized()
        btnBack.setTitle("Change".localized(), for: .normal)
        btnCancel.setTitle("Cancel".localized(), for: .normal)
        lblStatusStatic.text = "STATUS".localized()
        lblApprovalStatic.text = "APPROVAL".localized()
        btnPrint.setTitle("Print".localized(), for: .normal)
        
        if isScan {
            self.btnBack.isHidden = true
        }
        // checking . . .
        check()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func check() {
        waitTimer.invalidate()
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        Inquiry.checkin(cardNo: lblID.text!, policyNo: lblPolicy.text!, providerCode: "601", payerCode: code, completion: {(cresult, error) -> Void in
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
           
            self.waitTimer = Timer.scheduledTimer(timeInterval: CloseTimer.waitTimeInterval,
                                             target: self,
                                             selector: #selector(CheckResultVC.timerDidEnd),
                                             userInfo: nil,
                                             repeats: true)

            if error != nil
            {
                self.isTimerPaused = true
                self.lblMessage.text = ""
                let alert = UIAlertController(title: "Problem checking insurance", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 5
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    alert.dismiss(animated: true, completion: nil)
                    self.isTimerPaused = false
                }
                //self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
            }
            else {
                self.lblMessage.isHidden = false
                self.viewStatus.isHidden = false
                self.viewPrint.isHidden = false
                
                if cresult?.response?.outcome == "failure" {
                    self.show(outcome: cresult?.response?.outcome, message: cresult?.response?.message, name: cresult?.response?.name, approval: cresult?.result)
                } else {
                    self.show(status: cresult?.response?.status, desc: cresult?.response?.desc, amount: cresult?.response?.shareAmount, type: cresult?.response?.shareType, ref: cresult?.response?.reference, name: cresult?.response?.name, approval: cresult?.result)
                }
            }
        })
    }
    
    func show(outcome: String?, message: String?, name: String?, approval: Inquiry.Result?) {
        self.lblMessage.text = "\(message!)"
        self.lblStatusEligibility.text = outcome!.uppercased()
        self.lblDate.text = Date().toString()
        self.lblStatusEligibility.textColor = UIColor.red
        self.imgStatus.image = #imageLiteral(resourceName: "check_invalid")
        self.lblShareAmount.text = "-"
        self.name = name
        self.isPrintable = false
        showApproval(approval: approval)
        
    }
    
    func show(status: String?, desc: String?, amount: String?, type: String?, ref: String?, name: String?, approval: Inquiry.Result?) {
        self.lblMessage.text = "\(desc!)"
        self.lblStatusEligibility.text = status!.uppercased()
        self.lblShareAmount.text = "\(amount!) \(type!)"
        self.lblDate.text = Date().toString()
        self.name = name
        //self.lblReference.text = ref!
        
        if self.lblStatusEligibility.text == "INVALID" || self.lblStatusEligibility.text == "INELIGIBLE" {
            self.lblStatusEligibility.textColor = UIColor.red
            self.lblShareAmount.text = " - "
            imgStatus.image = #imageLiteral(resourceName: "check_invalid")
            self.lblRefApproval.text = ""
            self.isPrintable = false
        } else {
            self.lblStatusEligibility.textColor = successColor
            imgStatus.image = #imageLiteral(resourceName: "check_valid")
        }
        showApproval(approval: approval)
    }
    
    func showApproval(approval: Inquiry.Result?) {
        self.lblStatusApproval.text = approval?.status
        self.lblRefApproval.text = approval?.reference
        
        if approval?.outcome == "failure" {
            self.lblStatusApproval.text = "NO APPROVAL"
            self.lblStatusApproval.textColor = UIColor.red
            self.lblRefApproval.text = ""
        } else if self.lblStatusApproval.text == "REJECTED" {
            self.lblStatusApproval.textColor = UIColor.red
        }
    }

    func clear() {
        self.lblMessage.text = "Request in progress . . ."
        self.lblStatusEligibility.text = ""
        self.lblShareAmount.text = ""
        self.lblDate.text = ""
        self.imgStatus.image = nil
        self.lblRefApproval.text = ""
        self.lblStatusApproval.text = ""
        self.viewStatus.isHidden = true
        //self.viewPrint.isHidden = true
    }
    
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func cancel(_ sender: UIButton) {
        if !isScan {
        _ = navigationController?.popToRootViewController(animated: true)
        } else {
            pop()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timeUp" {
            let vc = segue.destination as! TimerVC
            vc.delegate = self
        } else if segue.identifier == "toPrint" {
            let vc = segue.destination as! PrintVC
            vc.delegate = self
            vc.printerTarget = self.printerTarget
            vc.printerType = self.printerType
            vc.printerInterface = self.printerInterface
            vc.printerAddress = self.printerAddress
            // data
            vc._data_date_time = Date().toPrintFormat()
            vc._data_insurance_id = self.ID
            vc._data_insurance_policy = self.policy
            vc._data_insurance_code = self.code.description
            vc._data_insurance_status = self.lblStatusEligibility.text
            vc._data_insurer_name = self.name
            vc._data_approval_status = self.lblStatusApproval.text
            vc._data_approval_ref = self.lblRefApproval.text
        }
    }
    
    func pop() {
        if !isScan {
        _ = self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: {
                self.scanCloseDelegate?.pop()
            })
        }
    }
    
    @IBAction func doPrint(_ sender: Any) {
        //tryDisabling()
        discoverPrinter()
    }
    
    func discoverPrinter() {
        let result: Int32 = Int32(Epos2Discovery.start(filteroption_, delegate: self))
        if EPOS2_SUCCESS.rawValue != result {
            let alert = UIAlertController(title: ShowMsg.showErrorEpos(result, method: "start"), message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    alert.dismiss(animated: false, completion: {
                    })
                }
            })
        }
    }
    
    func tryDisabling() {
        if !self.isPrintable {
            self.isTimerPaused = true
            let alert = UIAlertController(title: "Disabled for error response", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
                self.isTimerPaused = false
            }
        }
    }
    
    func pause() {
        self.isTimerPaused = true
    }
    
    func resume() {
        self.isTimerPaused = false
    }
    
    /* * * printer discovery * */
    func onDiscovery(_ deviceInfo: Epos2DeviceInfo) {
        //printerList_.append(deviceInfo)
        //printerList_.reloadData()
        stopDiscovery()
        
        printerTarget = deviceInfo.target
        printerInterface = Utility.convertEpos2DeficeInfoPrinterInterface(toInterfaceString: deviceInfo)
        printerType = Utility.convertEpos2DeviceInfoPrinterType(toEposEasySelectDeviceType: deviceInfo)
        printerAddress = Utility.getAddressFrom(deviceInfo)
        
        let alert = UIAlertController(title: "Printer connected", message: printerTarget, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            // your code with delay
            alert.dismiss(animated: true, completion: {
                //DispatchQueue.main.asyncAfter(deadline: when) {
                //    self.dismiss(animated: true, completion: {
                        self.isTimerPaused = true
                        self.performSegue(withIdentifier: "toPrint", sender: self)
                //    })
                //}
            })
            
        }
        
    }
    
    func stopDiscovery() {
        var result: Int32 = EPOS2_SUCCESS.rawValue
        while true {
            result = Epos2Discovery.stop()
            if result != EPOS2_ERR_PROCESSING.rawValue {
                if result == EPOS2_SUCCESS.rawValue {
                    break
                }
                else {
                    let alert = UIAlertController(title: ShowMsg.showErrorEpos(result, method: "stop"), message: nil, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: {
                        let when = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            alert.dismiss(animated: false, completion: {
                            })
                        }
                    })
                    return
                }
            }
        }
    }
    /* * * printer discovery * * */

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
