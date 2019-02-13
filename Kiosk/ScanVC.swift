//
//  ScanVC.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/30/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, PopToRootDelegate {

    var waitTimer = Timer()
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var ID: String = ""
    var policy: String = ""
    var code: Int!
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    func timerDidEnd() {
        self.performSegue(withIdentifier: "timeUp", sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        messageLabel.text = "Bring QR code infront of screen".localized()
        waitTimer = Timer.scheduledTimer(timeInterval: CloseTimer.waitTimeInterval,
                                         target: self,
                                         selector: #selector(PayerSelectionVC.timerDidEnd),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        var captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if #available(iOS 10.0, *) {
            captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the message label to the top view
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: closeButton)
            
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
         waitTimer.invalidate()
        if captureSession == nil {
            return
        }
        if captureSession!.isRunning {
            self.captureSession!.stopRunning()
        }
    }

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                conform(detection: metadataObj.stringValue)
            }
        }
    }
    
    func conform(detection: String) {
        let barcodeStr = detection.components(separatedBy: "\n")
        if barcodeStr.count == 3 {
            let dataStr = barcodeStr[1].components(separatedBy: ":")
            if dataStr.count == 2 {
                let str = dataStr[1].components(separatedBy: ",")
                if str.count == 3 {
                    self.ID = str[0]
                    self.policy = str[1]
                    if checkCode(code: Int(str[2])) {
                        self.waitTimer.invalidate()
                        self.performSegue(withIdentifier: "toEligibility", sender: self)
                    }
                }
            }
        }
    }
    
    func checkCode(code: Int?) -> Bool {
        self.code = code
        if code == nil {
            return false
        }
        else if code == 102 {
            return true
        } else if code == 300 {
            return true
        } else if code == 201 {
            return true
        } else if code == 204 {
            return true
        } else if code == 205 {
            return true
        } else if code == 207 {
            return true
        } else if code == 209 {
            return true
        } else if code == 302 {
            return true
        } else if code == 306 {
            return true
        } else if code == 208 {
           return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timeUp" {
            let vc = segue.destination as! TimerVC
            vc.delegate = self
        } else  if segue.identifier == "toEligibility" {
            let vc = segue.destination as! CheckResultVC
            vc.ID = self.ID
            vc.policy = self.policy
            vc.code = self.code
            vc.isScan = true
            vc.scanCloseDelegate = self
        }
    }

    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func pop() {
        self.dismiss(animated: false, completion: nil)
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
