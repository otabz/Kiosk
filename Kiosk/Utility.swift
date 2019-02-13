//
//  Utility.swift
//  EpsonPrint
//
//  Created by Waseel ASP Ltd. on 4/26/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import Foundation

class Utility {

class func convertEpos2DeficeInfoPrinterInterface(toInterfaceString deviceInfo: Epos2DeviceInfo) -> String {
    let deviceType: Int = self.convertEpos2DeviceInfo(toEposEasySelectDeviceType: deviceInfo)
    return self.convertEposConnectionType(toInterfaceString: Int32(deviceType))
}
    
    class func convertEpos2DeviceInfo(toEposEasySelectDeviceType deviceInfo: Epos2DeviceInfo) -> Int {
        var deviceType: Int = Int(EPOS_EASY_SELECT_DEVTYPE_TCP.rawValue)
        if self.isDeviceNetwork(deviceInfo) {
            deviceType = Int(EPOS_EASY_SELECT_DEVTYPE_TCP.rawValue)
        }
        else if self.isDeviceBluetooth(deviceInfo) {
            deviceType = Int(EPOS_EASY_SELECT_DEVTYPE_BLUETOOTH.rawValue)
        }
        
        return deviceType
    }
    
    class func isDeviceNetwork(_ deviceInfo: Epos2DeviceInfo) -> Bool {
        let macAddress: String = deviceInfo.macAddress
        if macAddress == "" {
            return false
        }
        if (macAddress == "") {
            return false
        }
        return true
    }
    
    class func isDeviceBluetooth(_ deviceInfo: Epos2DeviceInfo) -> Bool {
        let bdAddress: String = deviceInfo.bdAddress
        if bdAddress == "" {
            return false
        }
        if (bdAddress == "") {
            return false
        }
        return true
    }
    
    class func convertEposConnectionType(toInterfaceString connectionType: Int32) -> String {
        switch connectionType {
        case EPOS_EASY_SELECT_DEVTYPE_BLUETOOTH.rawValue:
            return "Bluetooth"
        case EPOS_EASY_SELECT_DEVTYPE_TCP.rawValue:
            return "Network"
        default:
            return ""
        }
        
    }
    
    class func convertEpos2DeviceInfoPrinterType(toEposEasySelectDeviceType deviceInfo: Epos2DeviceInfo) -> Int {
        var deviceType: Int32 = EPOS_EASY_SELECT_DEVTYPE_TCP.rawValue
        if self.isDeviceNetwork(deviceInfo) {
            deviceType = EPOS_EASY_SELECT_DEVTYPE_TCP.rawValue
        }
        else if self.isDeviceBluetooth(deviceInfo) {
            deviceType = EPOS_EASY_SELECT_DEVTYPE_BLUETOOTH.rawValue
        }
        
        return Int(deviceType)
    }
    
    class func getAddressFrom(_ deviceInfo: Epos2DeviceInfo) -> String {
        var address: String = ""
        if self.isDeviceNetwork(deviceInfo) {
            address = deviceInfo.macAddress
        }
        else if self.isDeviceBluetooth(deviceInfo) {
            address = deviceInfo.bdAddress
        }
        
        return address
    }
}
