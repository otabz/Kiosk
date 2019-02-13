//
//  PrintVC.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/27/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit

protocol PauseTimerDelegate: class {
    func pause()
    func resume()
}

class PrintVC: UIViewController, Epos2DiscoveryDelegate, Epos2PtrReceiveDelegate {
    
    var delegate : PauseTimerDelegate?
    
    let KEY_RESULT = "Result"
    let KEY_METHOD = "Method"
    
    var filteroption_ : Epos2FilterOption?
    var eposEasySelectDeviceType_ : Int32 = EPOS_EASY_SELECT_DEVTYPE_BLUETOOTH.rawValue
    var printerTarget: String?
    var printerType: Int?
    var printerInterface: String?
    var printerAddress: String?
    
    var printer_: Epos2Printer?
    var printerSeries_: Int32 = 0
    let printerName: String = "TM-m30"
    
    var _data_date_time: String?
    var _data_insurer_name: String?
    var _data_insurance_id: String?
    var _data_insurance_policy: String?
    var _data_insurance_code: String?
    var _data_insurance_status: String?
    var _data_approval_status: String?
    var _data_approval_ref: String?
    
    //let printerList_ = Any[]()
    @IBOutlet weak var _textWarnings: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        filteroption_ = Epos2FilterOption()
        filteroption_?.deviceType = EPOS2_TYPE_PRINTER.rawValue
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //growl(ShowMsg.showErrorEpos(0, method: "start"))
        /*let result: Int32 = Int32(Epos2Discovery.start(filteroption_, delegate: self))
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result, method: "start"))
        }*/
        _ = runPrintQRCodeSequence()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.resume()
        /*var result: Int32 = EPOS2_SUCCESS.rawValue
        while true {
            result = Epos2Discovery.stop()
            if result != EPOS2_ERR_PROCESSING.rawValue {
                break
            }
        }*/
    }
    
    @IBAction func printQR(_ sender: UIButton) {
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
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.dismiss(animated: true, completion: nil)
                }
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
                    growl(ShowMsg.showErrorEpos(result, method: "stop"))
                    return
                }
            }
        }
    }
    /* * * printer discovery * * */
    
    /* * * printing qr code * * */
    func runPrintQRCodeSequence() -> Bool {
        _textWarnings.text = ""
        if !initializeObject() {
            return false
        }
        if !createQrCodeData() {
            finalizeObject()
            return false
        }
        if !printData() {
            finalizeObject()
            return false
        }
        return true
    }
    
    func initializeObject() -> Bool {
        printer_ = Epos2Printer(printerSeries: printerSeries_, lang: EPOS2_MODEL_ANK.rawValue)
        if printer_ == nil {
            growl(ShowMsg.showErrorEpos(EPOS2_ERR_PARAM.rawValue, method: "initiWithPrinterSeries"))
            return false
        }
        printer_?.setReceiveEventDelegate(self)
        return true
    }
    
    func createQrCodeData() -> Bool {
        var result: Int32?
        result = EPOS2_SUCCESS.rawValue
        if printer_ == nil {
            return false
        }
        var printText: String = ""
        // Member Name
        //printText = "Device:\(printerName)"
        printText = "\(_data_insurer_name!)"
        result = printer_?.addText(printText)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addText"))
            return false
        }
        result = printer_?.addFeedLine(1)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addFeedLine"))
            return false
        }
        // Date
        //printText = "Interface:\(printerInterface)"
        printText = "Date:\(_data_date_time!)"
        result = printer_?.addText(printText)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addText"))
            return false
        }
        result = printer_?.addFeedLine(1)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addFeedLine"))
            return false
        }
        // Status
        //printText = "Address:\(printerAddress)"
        printText = "Status:\(_data_insurance_status!)"
        result = printer_?.addText(printText)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addText"))
            return false
        }
        result = printer_?.addFeedLine(2)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addFeedLine"))
            return false
        }
        // Approval
        printText = "Approval:\(_data_approval_status!)"
        result = printer_?.addText(printText)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addText"))
            return false
        }
        result = printer_?.addFeedLine(1)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addFeedLine"))
            return false
        }
        // Referennce
        printText = "Ref:\(_data_approval_ref!)"
        result = printer_?.addText(printText)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addText"))
            return false
        }
        result = printer_?.addFeedLine(2)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addFeedLine"))
            return false
        }
        // createQR
        let easySelect = EposEasySelect()
        let qrCodeText: String? = easySelect.createQR("\(_data_insurance_id!),\(_data_insurance_policy!),\(_data_insurance_code!)", deviceType: eposEasySelectDeviceType_, macAddress: printerAddress)
        if qrCodeText == nil {
            growl("Error createQR")
            return false
        }
        // Add QR CODE
        result = printer_?.addTextAlign(EPOS2_ALIGN_CENTER.rawValue)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addTextAlign"))
            return false
        }
        //Note
        printText = "Scan QR next time"
        result = printer_?.addText(printText)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addText"))
            return false
        }
        result = printer_?.addFeedLine(1)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addFeedLine"))
            return false
        }
        // QR
        result = printer_?.addSymbol(qrCodeText, type: EPOS2_SYMBOL_QRCODE_MODEL_2.rawValue, level: EPOS2_LEVEL_L.rawValue, width: 5, height: 5, size: 0)
        if result != EPOS2_SUCCESS.rawValue {
            growl(ShowMsg.showErrorEpos(result!, method: "addSymbol"))
            return false
        }
        result = printer_?.addFeedLine(1)
        if EPOS2_SUCCESS.rawValue != result {
            growl(ShowMsg.showErrorEpos(result!, method: "addFeedLine"))
            return false
        }
        result = printer_?.addCut(EPOS2_CUT_FEED.rawValue)
        if result != EPOS2_SUCCESS.rawValue {
            growl(ShowMsg.showErrorEpos(result!, method: "addCut"))
            return false
        }
        return true
    }
    
    func finalizeObject() {
        if printer_ == nil {
            return
        }
        printer_?.clearCommandBuffer()
        printer_?.setReceiveEventDelegate(nil)
        printer_ = nil
    }
    
    func printData() -> Bool {
        var result: Int32?
        result = EPOS2_SUCCESS.rawValue
        var status: Epos2PrinterStatusInfo? = nil
        if printer_ == nil {
            return false
        }
        if !connectPrinter() {
            return false
        }
        status = printer_?.getStatus()
        dispPrinterWarnings(status)
        if !isPrintable(status) {
            growl(makeErrorMessage(status!))
            disconnectPrinter()
            return false
        }
        result = printer_?.sendData(Int(EPOS2_PARAM_DEFAULT))
        if result != EPOS2_SUCCESS.rawValue {
            growl(ShowMsg.showErrorEpos(result!, method: "sendData"))
            disconnectPrinter()
            return false
        }
        return true
    }
    
    func connectPrinter() -> Bool {
        var result: Int32?
        result = EPOS2_SUCCESS.rawValue
        if printer_ == nil {
            return false
        }
        result = printer_?.connect(printerTarget, timeout: Int(EPOS2_PARAM_DEFAULT))
        if result != EPOS2_SUCCESS.rawValue {
            growl(ShowMsg.showErrorEpos(result!, method: "connect"))
            return false
        }
        result = printer_?.beginTransaction()
        if result != EPOS2_SUCCESS.rawValue {
            growl(ShowMsg.showErrorEpos(result!, method: "beginTransaction"))
            disconnectPrinter()
            return false
        }
        return true
    }
    
    func disconnectPrinter() {
        var result: Int32?
        result = EPOS2_SUCCESS.rawValue
        var dict = [AnyHashable: Any]()
        if printer_ == nil {
            return
        }
        result = printer_?.endTransaction()
        if result != EPOS2_SUCCESS.rawValue {
            dict[KEY_RESULT] = Int(result!)
            dict[KEY_METHOD] = "endTransaction"
            performSelector(onMainThread: #selector(self.showEposErrorFromThread), with: dict, waitUntilDone: false)
        }
        result = printer_?.disconnect()
        if result != EPOS2_SUCCESS.rawValue {
            dict = [AnyHashable: Any]()
            dict[KEY_RESULT] = Int(result!)
            dict[KEY_METHOD] = "disconnect"
            performSelector(onMainThread: #selector(self.showEposErrorFromThread), with: dict, waitUntilDone: false)
        }
        finalizeObject()
    }
    
    func isPrintable(_ status: Epos2PrinterStatusInfo?) -> Bool {
        if status == nil {
            return false
        }
        if status?.connection == EPOS2_FALSE {
            return false
        }
        else if status?.online == EPOS2_FALSE {
            return false
        }
        else {
            // print available
        }
        
        return true
    }
    
    
    func onPtrReceive(_ printerObj: Epos2Printer, code: Int32, status: Epos2PrinterStatusInfo, printJobId: String) {
        growl(ShowMsg.showResult(code, errMsg: makeErrorMessage(status)))
        dispPrinterWarnings(status)
        //updateButtonState(true)
        performSelector(inBackground: #selector(self.disconnectPrinter), with: nil)
    }
    
    func showEposErrorFromThread(dict: [AnyHashable: Any]) {
        var result: Int32 = EPOS2_SUCCESS.rawValue
        var method: String = ""
        result = CInt((dict[KEY_RESULT] as? String)!)!
        method = (dict[KEY_RESULT] as? String)!
        growl(ShowMsg.showErrorEpos(result, method: method))
    }
    
    func dispPrinterWarnings(_ status: Epos2PrinterStatusInfo?) {
        var warningMsg = String()
        if status == nil {
            return
        }
        _textWarnings.text = ""
        if status?.paper == EPOS2_PAPER_NEAR_END.rawValue {
            warningMsg += NSLocalizedString("warn_receipt_near_end", comment: "")
        }
        if status?.batteryLevel == EPOS2_BATTERY_LEVEL_1 .rawValue{
            warningMsg += NSLocalizedString("warn_battery_near_end", comment: "")
        }
        _textWarnings.text = warningMsg
    }
    
    
    func makeErrorMessage(_ status: Epos2PrinterStatusInfo) -> String {
        var errMsg: String = ""
        if status.online == EPOS2_FALSE {
            errMsg += NSLocalizedString("err_offline", comment: "")
        }
        if status.connection == EPOS2_FALSE {
            errMsg += NSLocalizedString("err_no_response", comment: "")
        }
        if status.coverOpen == EPOS2_TRUE {
            errMsg += NSLocalizedString("err_cover_open", comment: "")
        }
        if status.paper == EPOS2_PAPER_EMPTY.rawValue {
            errMsg += NSLocalizedString("err_receipt_end", comment: "")
        }
        if status.paperFeed == EPOS2_TRUE || status.panelSwitch == EPOS2_SWITCH_ON.rawValue {
            errMsg += NSLocalizedString("err_paper_feed", comment: "")
        }
        if status.errorStatus == EPOS2_MECHANICAL_ERR.rawValue || status.errorStatus == EPOS2_AUTOCUTTER_ERR.rawValue {
            errMsg += NSLocalizedString("err_autocutter", comment: "")
            errMsg += NSLocalizedString("err_need_recover", comment: "")
        }
        if status.errorStatus == EPOS2_UNRECOVER_ERR.rawValue {
            errMsg += NSLocalizedString("err_unrecover", comment: "")
        }
        if status.errorStatus == EPOS2_AUTORECOVER_ERR.rawValue {
            if status.autoRecoverError == EPOS2_HEAD_OVERHEAT.rawValue {
                errMsg += NSLocalizedString("err_overheat", comment: "")
                errMsg += NSLocalizedString("err_head", comment: "")
            }
            if status.autoRecoverError == EPOS2_MOTOR_OVERHEAT.rawValue {
                errMsg += NSLocalizedString("err_overheat", comment: "")
                errMsg += NSLocalizedString("err_motor", comment: "")
            }
            if status.autoRecoverError == EPOS2_BATTERY_OVERHEAT.rawValue {
                errMsg += NSLocalizedString("err_overheat", comment: "")
                errMsg += NSLocalizedString("err_battery", comment: "")
            }
            if status.errorStatus == EPOS2_AUTORECOVER_ERR.rawValue {
                if status.autoRecoverError == EPOS2_WRONG_PAPER.rawValue {
                    errMsg += NSLocalizedString("err_wrong_paper", comment: "")
                }
            }
        }
        if status.batteryLevel == EPOS2_BATTERY_LEVEL_0.rawValue {
            errMsg += NSLocalizedString("err_battery_real_end", comment: "")
        }
        return errMsg
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
