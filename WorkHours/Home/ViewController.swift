//
//  ViewController.swift
//  WorkHours
//
//  Created by MacDD02 on 28/08/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var btnCheckinCheckOut:UIButton!
    @IBOutlet var lbLastCheck:UILabel!
    
    var checkingService:CheckingService!
    var currentState:NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkingService = CheckingService()
        self.updateStatus()
        self.updateBtnCheckinCheckOut()
        
        let time = self.checkingService.getChecksOfCurrentDay()
        print(time)
    }
    
    func updateBtnCheckinCheckOut(){
        self.updateLabelLastCheck()
        if self.currentState == 0 {
            self.btnCheckinCheckOut.setTitle("Check in", for:  UIControlState())
        }else if self.currentState == 1 {
            self.btnCheckinCheckOut.setTitle("Check out", for:  UIControlState())
        }
    }
    
    func updateLabelLastCheck(){
        if let lastCheck = self.checkingService.getLastCheck(){
            if let checkout = lastCheck.checkout {
                lbLastCheck.text = "Ultimo Check out: \(checkout.hourToString()) - \(checkout.dateToString())"
                
            }else{
                lbLastCheck.text = "Ultimo Check in: \(String(describing: lastCheck.checkin!.hourToString())) - \(String(describing: lastCheck.checkin!.dateToString()))"
            }
        }
    }
    
    func updateStatus(){
        if let lastCheck = self.checkingService.getLastCheck(){
            if lastCheck.checkout == nil {
                self.currentState = 1
            }else{
                self.currentState = 0
            }
        }
    }
    
    @IBAction func checkInCheckOut(){
        if self.currentState == 0 {
            self.checkingService.create(checkin: Date(), lat: nil, long: nil)
            self.currentState = 1
        }else if self.currentState == 1 {
            self.checkingService.update(checkout: Date())
            self.currentState = 0
        }
        
        self.updateBtnCheckinCheckOut()
    }



}

