//
//  ViewController.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 3/28/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import UIKit
import Localize_Swift

class ViewController: UIViewController {

    var isCheck : Bool!
    
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var lblSmallHeader: UILabel!
    @IBOutlet weak var lblLargeHeader: UILabel!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnScan: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnLanguage.setTitle("اللغة العربية".localized(), for: .normal)
        lblSmallHeader.text = "Check status of".localized()
        lblLargeHeader.text = "Medical Insurance and\nApprovals".localized()
        lblOR.text = "OR".localized()
        btnCard.setTitle("Enter Insurance Card".localized(), for: .normal)
        btnScan.setTitle("Press to Scan QR".localized(), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPayers" {
            let vc = segue.destination as? PayerSelectionVC
            vc?.isCheck = self.isCheck
        }
    }

    @IBAction func check(_ sender: UIButton) {
        self.isCheck = true
        self.performSegue(withIdentifier: "toPayers", sender: self)
    }
    
    @IBAction func inquire(_ sender: UIButton) {
        self.isCheck = false
    }
    
    @IBAction func scan(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toScan", sender: self)
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        if Localize.currentLanguage() == "en" {
            Localize.setCurrentLanguage("ar")
        } else {
            Localize.setCurrentLanguage("en")
        }
        viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func growl(_ msg: String) {
        //let alert = UIAlertView(title: "", message: msg, delegate: nil, cancelButtonTitle: "", otherButtonTitles: "")
        let alert = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: false, completion: {
                    self.dismiss(animated: false, completion: nil)
                })
            }
        })
        
    }
}

extension UIActivityIndicatorView {
    func scale(factor: CGFloat) {
        guard factor > 0.0 else { return }
        
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM\ndd"
        return dateFormatter.string(from: self)
    }
    func toPrintFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}


