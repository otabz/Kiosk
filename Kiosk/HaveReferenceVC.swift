//
//  HaveReferenceVC.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/5/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit

class HaveReferenceVC: UIViewController {

    let isCheck = false
    var haveReference : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPayers" {
            let vc = segue.destination as? PayerSelectionVC
            vc?.isCheck = self.isCheck
            vc?.haveReference = self.haveReference
        }
    }

    @IBAction func yes(_ sender: UIButton) {
        self.haveReference = true
        self.performSegue(withIdentifier: "toPayers", sender: self)
    }
    
    @IBAction func no(_ sender: UIButton) {
        self.haveReference = false
        self.performSegue(withIdentifier: "toPayers", sender: self)
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
