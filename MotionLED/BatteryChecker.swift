//
//  BatteryChecker.swift
//  MotionLED
//
//  Created by youringtone on 2016/02/26.
//  Copyright © 2016年 youringtone. All rights reserved.
//


import UIKit

class BatteryChecker {
    //デバイスとバッテリー残量の宣言.

    let myDevice: UIDevice = UIDevice.currentDevice()
    
    init(){
        //バッテリー状態の監視.
        myDevice.batteryMonitoringEnabled = true
        
    }

//    func batteryCheck(){
    
            func level() -> String{
                let myBatteryLevel = myDevice.batteryLevel
                print((NSString(format: "%.2f", myBatteryLevel) as String) + "%")
                return String((NSString(format: "%.2f", myBatteryLevel) as String) + "%")
                
            }
            
        //バッテリープロパティ表示用のラベル.
            func state() -> String{
            let myBatteryState = myDevice.batteryState
        
                //バッテリー状態の取得.
                //0.0~1.0で残量表示。残量不明の時は-1.0を返す.
                var stateString = ""
                switch (myBatteryState) {
                    
                case .Full:
                    stateString = "Full"
                case .Unplugged:
                    stateString = "Unplugged"
                case .Charging:
                    stateString = "Charging"
                case .Unknown:
                    stateString = "Unknown"
                }
                
                return stateString
                
        }
        
    }

    

