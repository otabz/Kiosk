//
//  TimerVC.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/27/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit

protocol PopToRootDelegate: class {
    func pop()
}

class TimerVC: UIViewController {
    
    var popupWaitTimer: Timer?
    var delegate: PopToRootDelegate?
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblSubHeader: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.popupWaitTimer = Timer.scheduledTimer(timeInterval: CloseTimer.popupWaitTimeInterval,
                             target: self,
                             selector: #selector(TimerVC.dissmiss),
                             userInfo: "", // any object to be received in #selector
                             repeats: false)
        //localization
        lblHeader.text = "Transaction time up!".localized()
        lblSubHeader.text = "Do you want more time?".localized()
        btnYes.setTitle("Yes".localized(), for: .normal)
        btnNo.setTitle("No".localized(), for: .normal)
    }
    
    @IBAction func yes(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.popupWaitTimer?.invalidate()
        })
    }
    
    @IBAction func no(_ sender: UIButton) {
        self.dismiss(animated: false, completion: {
            self.popupWaitTimer?.invalidate()
            self.delegate?.pop()
        })
    }
    
    func dissmiss() {
        self.dismiss(animated: false, completion: {
            self.delegate?.pop()
        })
        
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
