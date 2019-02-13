//
//  ShowMsg.swift
//  EpsonPrint
//
//  Created by Waseel ASP Ltd. on 4/26/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import Foundation

class ShowMsg {
    
    class func showErrorEpos(_ resultCode: Int32, method: String) -> String {
        let msg = "\(NSLocalizedString("methoderr_errcode", comment: ""))\n\(self.getEposErrorText(resultCode))\n\n\(NSLocalizedString("methoderr_method", comment: ""))\n\(method)\n"
        //self.show(msg, delegate: delegate)
        return msg
    }
    
    class func showResult(_ code: Int32, errMsg: String) -> String {
        var msg: String = ""
        if (errMsg == "") {
            msg = "\(NSLocalizedString("statusmsg_result", comment: ""))\n\(self.getEposResultText(code))\n"
        }
        else {
            msg = "\(NSLocalizedString("statusmsg_result", comment: ""))\n\(self.getEposResultText(code))\n\n\(NSLocalizedString("statusmsg_description", comment: ""))\n\(errMsg)\n"
        }
        //self.show(msg, delegate: delegate)
        return msg
   
    }
    
    class func show(_ msg: String) {
        let alert = UIAlertView(title: "", message: msg, delegate: nil, cancelButtonTitle: "", otherButtonTitles: "")
        alert.show()
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(withClickedButtonIndex: 0, animated: true)
            //delegate?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    class func showErrorEposBt(_ resultCode: Int32, method: String) -> String {
        let msg = "\(NSLocalizedString("methoderr_errcode", comment: ""))\n\(self.getEposBtErrorText(resultCode))\n\n\(NSLocalizedString("methoderr_method", comment: ""))\n\(method)\n"
        //self.show(msg, delegate: delegate)
        return msg
    }
    
    class func getEposErrorText(_ error: Int32) -> String {
        var errText: String = ""
        switch error {
        case EPOS2_SUCCESS.rawValue:
            errText = "SUCCESS"
        case EPOS2_ERR_PARAM.rawValue:
            errText = "ERR_PARAM"
        case EPOS2_ERR_CONNECT.rawValue:
            errText = "ERR_CONNECT"
        case EPOS2_ERR_TIMEOUT.rawValue:
            errText = "ERR_TIMEOUT"
        case EPOS2_ERR_MEMORY.rawValue:
            errText = "ERR_MEMORY"
        case EPOS2_ERR_ILLEGAL.rawValue:
            errText = "ERR_ILLEGAL"
        case EPOS2_ERR_PROCESSING.rawValue:
            errText = "ERR_PROCESSING"
        case EPOS2_ERR_NOT_FOUND.rawValue:
            errText = "ERR_NOT_FOUND"
        case EPOS2_ERR_IN_USE.rawValue:
            errText = "ERR_IN_USE"
        case EPOS2_ERR_TYPE_INVALID.rawValue:
            errText = "ERR_TYPE_INVALID"
        case EPOS2_ERR_DISCONNECT.rawValue:
            errText = "ERR_DISCONNECT"
        case EPOS2_ERR_ALREADY_OPENED.rawValue:
            errText = "ERR_ALREADY_OPENED"
        case EPOS2_ERR_ALREADY_USED.rawValue:
            errText = "ERR_ALREADY_USED"
        case EPOS2_ERR_BOX_COUNT_OVER.rawValue:
            errText = "ERR_BOX_COUNT_OVER"
        case EPOS2_ERR_BOX_CLIENT_OVER.rawValue:
            errText = "ERR_BOXT_CLIENT_OVER"
        case EPOS2_ERR_UNSUPPORTED.rawValue:
            errText = "ERR_UNSUPPORTED"
        case EPOS2_ERR_FAILURE.rawValue:
            errText = "ERR_FAILURE"
        default:
            errText = "\(error)"
        }
        
        return errText
    }
    
    class func getEposBtErrorText(_ error: Int32) -> String {
        var errText: String = ""
        switch error {
        case EPOS2_BT_SUCCESS.rawValue:
            errText = "SUCCESS"
        case EPOS2_BT_ERR_PARAM.rawValue:
            errText = "ERR_PARAM"
        case EPOS2_BT_ERR_UNSUPPORTED.rawValue:
            errText = "ERR_UNSUPPORTED"
        case EPOS2_BT_ERR_CANCEL.rawValue:
            errText = "ERR_CANCEL"
        case EPOS2_BT_ERR_ALREADY_CONNECT.rawValue:
            errText = "ERR_ALREADY_CONNECT"
        case EPOS2_BT_ERR_ILLEGAL_DEVICE.rawValue:
            errText = "ERR_ILLEGAL_DEVICE"
        case EPOS2_BT_ERR_FAILURE.rawValue:
            errText = "ERR_FAILURE"
        default:
            errText = "\(error)"
        }
        
        return errText
    }
    
    class func getEposResultText(_ resultCode: Int32) -> String {
        var result: String = ""
        switch resultCode {
        case EPOS2_CODE_SUCCESS.rawValue:
            result = "PRINT_SUCCESS"
        case EPOS2_CODE_PRINTING.rawValue:
            result = "PRINTING"
        case EPOS2_CODE_ERR_AUTORECOVER.rawValue:
            result = "ERR_AUTORECOVER"
        case EPOS2_CODE_ERR_COVER_OPEN.rawValue:
            result = "ERR_COVER_OPEN"
        case EPOS2_CODE_ERR_CUTTER.rawValue:
            result = "ERR_CUTTER"
        case EPOS2_CODE_ERR_MECHANICAL.rawValue:
            result = "ERR_MECHANICAL"
        case EPOS2_CODE_ERR_EMPTY.rawValue:
            result = "ERR_EMPTY"
        case EPOS2_CODE_ERR_UNRECOVERABLE.rawValue:
            result = "ERR_UNRECOVERABLE"
        case EPOS2_CODE_ERR_FAILURE.rawValue:
            result = "ERR_FAILURE"
        case EPOS2_CODE_ERR_NOT_FOUND.rawValue:
            result = "ERR_NOT_FOUND"
        case EPOS2_CODE_ERR_SYSTEM.rawValue:
            result = "ERR_SYSTEM"
        case EPOS2_CODE_ERR_PORT.rawValue:
            result = "ERR_PORT"
        case EPOS2_CODE_ERR_TIMEOUT.rawValue:
            result = "ERR_TIMEOUT"
        case EPOS2_CODE_ERR_JOB_NOT_FOUND.rawValue:
            result = "ERR_JOB_NOT_FOUND"
        case EPOS2_CODE_ERR_SPOOLER.rawValue:
            result = "ERR_SPOOLER"
        case EPOS2_CODE_ERR_BATTERY_LOW.rawValue:
            result = "ERR_BATTERY_LOW"
        default:
            result = "\(resultCode)"
        }
        
        return result
    }
            
            
}
