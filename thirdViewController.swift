//
//  thirdViewController.swift
//  bluetoothOperationPractice
//
//  Created by 前薗 謙介 on 2016/01/11.
//  Copyright © 2016年 前薗 謙介. All rights reserved.
//

import UIKit
import CoreBluetooth

class thirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBPeripheralDelegate, UITextFieldDelegate {

    var myTableView: UITableView!
    var myCharacteristicsUuids: NSMutableArray = NSMutableArray()
    var myCharacteristics: NSMutableArray = NSMutableArray()
    var myWriteButton: UIButton!
    var myReadButton: UIButton!
    var myInvokeButton: UIButton!
    var myTargetPeriperal: CBPeripheral!
    var myService: CBService!
    var myTextField: UITextField!
    var myTargetCharacteristics: CBCharacteristic!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blueColor()
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        //tableView
        myTableView = UITableView(frame: CGRectMake(0, barHeight, displayWidth, displayHeight/2 - barHeight))
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)

        //textField
        myTextField = UITextField(frame: CGRectMake(25,displayHeight/2 + 10,displayWidth-50,30))
        myTextField.delegate = self
        myTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(myTextField)

        //Read button
        myReadButton = UIButton()
        myReadButton.frame = CGRectMake(displayWidth/2 + 60 - 100/2, displayHeight/2 + 100, 100, 40)
        myReadButton.backgroundColor = UIColor.redColor()
        myReadButton.layer.masksToBounds = true
        myReadButton.setTitle("Read", forState: UIControlState.Normal)
        myReadButton.tag = 1
        myReadButton.layer.cornerRadius = 20.0
        myReadButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myReadButton)

        // Writeボタン.
        myWriteButton = UIButton()
        myWriteButton.frame = CGRectMake(displayWidth/2 - 60 - 100/2,displayHeight/2 + 100,100,40)
        myWriteButton.backgroundColor = UIColor.greenColor()
        myWriteButton.layer.masksToBounds = true
        myWriteButton.setTitle("Write", forState: UIControlState.Normal)
        myWriteButton.layer.cornerRadius = 20.0
        myWriteButton.tag = 2
        myWriteButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myWriteButton)

        // Invokeボタン.
        myInvokeButton = UIButton()
        myInvokeButton.frame = CGRectMake(displayWidth/2 - 200/2,displayHeight - 100,200,40)
        myInvokeButton.backgroundColor = UIColor.blackColor()
        myInvokeButton.layer.masksToBounds = true
        myInvokeButton.setTitle("Invoke App", forState: UIControlState.Normal)
        myInvokeButton.layer.cornerRadius = 20.0
        myInvokeButton.tag = 3
        myInvokeButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myInvokeButton)
    }

    func setPeripheral(target: CBPeripheral) {
        self.myTargetPeriperal = target
        print(target)
    }

    func setService(service: CBService) {
        self.myService = service
        print(service)
    }

    //Characteristicsの検索
    func searchCharacteristics() {
        print("searchService thirdViewController")
        self.myTargetPeriperal.delegate = self
        self.myTargetPeriperal.discoverCharacteristics(nil, forService: self.myService)
    }

    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("didDiscoverCharacteristicsForService")
        for characteristics in service.characteristics! {
            myCharacteristicsUuids.addObject(characteristics.UUID)
            myCharacteristics.addObject(characteristics)
        }
        myTableView.reloadData()
    }

    //tableView Delegate
    //select Cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("CharactaristicsUuid: \(myCharacteristicsUuids[indexPath.row])")
        myTargetCharacteristics = myCharacteristics[indexPath.row] as! CBCharacteristic
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCharacteristicsUuids.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myCell")

        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor.redColor()
        cell.textLabel!.text = "\(myCharacteristicsUuids[indexPath.row])"
        cell.textLabel!.font = UIFont.systemFontOfSize(16)
        cell.detailTextLabel!.text = "Characteristics"
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12)

        return cell
    }

    func onClickMyButton(sender: UIButton) {
        print("onClickMyButton")
        print("sender.currentTitle: \(sender.currentTitle)")
        print("sender.tag: \(sender.tag)")

        if(self.myTargetCharacteristics != nil) {
            if(sender.tag == 1) {
                print("Read")
                self.myTargetPeriperal.readValueForCharacteristic(myTargetCharacteristics)
            } else if(sender.tag == 2) {
                print("Write")
                let data: NSData! = myTextField.text?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacteristics, type: CBCharacteristicWriteType.WithResponse)
            }
        }

        if(sender.tag == 3) {
            let myAppViewController: appViewController = appViewController()
            myAppViewController.setPeripheral(self.myTargetPeriperal)
            myAppViewController.setCharacterisics(self.myCharacteristics)
            myAppViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            print(self.navigationController)
            self.navigationController?.pushViewController(myAppViewController, animated: true)
        }
    }

    //Read
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("read myTargetChacterisitics:  \(myTargetCharacteristics)")
        var byte: CUnsignedChar = 0
        myTargetCharacteristics.value?.getBytes(&byte, length:1)

        print("************** read ***************")
        print("Uuid: \(myTargetCharacteristics.service.UUID)")
        print("Value: \(myTargetCharacteristics.value)")
        print("Byte: \(byte)")
        print("***********************************")


        //print(characteristic)
        //var out: NSInteger = 0
        //characteristic.value?.getBytes(&out, length: sizeof(NSInteger))
        //print("read: \(UnicodeScalar(out))")
        //myTextField.text = String(UnicodeScalar(out))
        //myTextField.reloadInputViews()
    }

    //Write
    func peripheral(peripheral: CBPeripheral, didUpdateValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        print("Success!")
    }

    //TextField
    func textFieldDidBeginEditing(textField: UITextField) {
        print("textFieldDidBeginEditing:  \(textField.text)")
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing: \(textField.text)")
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
