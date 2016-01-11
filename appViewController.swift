//
//  appViewController.swift
//  bluetoothOperationPractice
//
//  Created by 前薗 謙介 on 2016/01/11.
//  Copyright © 2016年 前薗 謙介. All rights reserved.
//

import UIKit
import CoreBluetooth

class appViewController: UIViewController, CBPeripheralDelegate {

    //var myTableView: UITableView!
    var myCharacteristics: NSMutableArray = NSMutableArray()
    var myRightButton: UIButton!
    var myLeftButton: UIButton!
    var myUpButton: UIButton!
    var myDownButton: UIButton!
    var myStopButton: UIButton!
    var myInvokeButton: UIButton!
    var myTargetPeriperal: CBPeripheral!
    var myService: CBService!
    var myTextField: UITextField!
    var myTargetCharacterstics: CBCharacteristic!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.yellowColor()
        //let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        //Up Button
        myUpButton = UIButton()
        myUpButton.frame = CGRectMake(displayWidth/2 - 60/2, displayHeight/2 - 100 - 60/2, 60, 60)
        myUpButton.backgroundColor = UIColor.blackColor()
        myUpButton.layer.masksToBounds = true
        myUpButton.setTitle("Up", forState: UIControlState.Normal)
        myUpButton.layer.cornerRadius = 30.0
        myUpButton.tag = 1
        myUpButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myUpButton)

        //Down Button
        myDownButton = UIButton()
        myDownButton.frame = CGRectMake(displayWidth/2 - 60/2, displayHeight/2 + 100 - 60/2, 60, 60)
        myDownButton.backgroundColor = UIColor.blackColor()
        myDownButton.layer.masksToBounds = true
        myDownButton.setTitle("Down", forState: UIControlState.Normal)
        myDownButton.layer.cornerRadius = 30.0
        myDownButton.tag = 2
        myDownButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myDownButton)

        //Right Button
        myRightButton = UIButton()
        myRightButton.frame = CGRectMake(displayWidth/2 + 100 - 60/2, displayHeight/2 - 60/2, 60, 60)
        myRightButton.backgroundColor = UIColor.blackColor()
        myRightButton.layer.masksToBounds = true
        myRightButton.setTitle("Right", forState: UIControlState.Normal)
        myRightButton.layer.cornerRadius = 30.0
        myRightButton.tag = 3
        myRightButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myRightButton)

        //Left Butoon
        myLeftButton = UIButton()
        myLeftButton.frame = CGRectMake(displayWidth/2 - 100 - 60/2, displayHeight/2 - 60/2, 60, 60)
        myLeftButton.backgroundColor = UIColor.blackColor()
        myLeftButton.setTitle("Left", forState: UIControlState.Normal)
        myLeftButton.tag = 4
        myLeftButton.layer.masksToBounds = true
        myLeftButton.layer.cornerRadius = 30.0
        myLeftButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myLeftButton)

        //Stop Button
        myStopButton = UIButton()
        myStopButton.frame = CGRectMake(displayWidth/2 - 60/2, displayHeight/2 - 60/2, 60, 60)
        myStopButton.backgroundColor = UIColor.blackColor()
        myStopButton.layer.masksToBounds = true
        myStopButton.setTitle("Stop", forState: UIControlState.Normal)
        myStopButton.layer.cornerRadius = 30.0
        myStopButton.tag = 5
        myStopButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myStopButton)

    }

    //接続先のPeripheral
    func setPeripheral(target: CBPeripheral) {
        self.myTargetPeriperal = target
        print(target)
    }

    //Characteristicsの設定
    func setCharacterisics(characteristics: NSMutableArray) {
        self.myCharacteristics = characteristics
        self.myTargetCharacterstics = characteristics[0] as! CBCharacteristic
    }

    //Buttin Events
    func onClickMyButton(sender: UIButton) {
        print("onClickMyButton")
        print("sender.currentTitle: \(sender.currentTitle)")
        print("sender.tag:\(sender.tag)")

        if(self.myTargetPeriperal != nil) {
            if(sender.tag == 1) {
                let data: NSData! = "1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacterstics, type: CBCharacteristicWriteType.WithResponse)
            } else if(sender.tag == 2) {
                let data: NSData! = "2".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacterstics, type: CBCharacteristicWriteType.WithResponse)
            } else if(sender.tag == 3) {
                let data: NSData! = "3".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)

                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacterstics, type: CBCharacteristicWriteType.WithResponse)
            }
            else if(sender.tag == 4){
                let data: NSData! = "4".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)

                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacterstics, type: CBCharacteristicWriteType.WithResponse)
            }
            else if(sender.tag == 5){
                let data: NSData! = "5".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)

                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacterstics, type: CBCharacteristicWriteType.WithResponse)
            }
        }
    }

    //read
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        var out: NSInteger = 0
        characteristic.value?.getBytes(&out, length: sizeof(NSInteger))
        print(UnicodeScalar(out))
        myTextField.text = String(UnicodeScalar(out))
    }

    //write
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("Success!")
    }

    func peripheral(peripheral: CBPeripheral, didUpdateValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        print("Success")
    }
}
