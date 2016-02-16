//
//  ViewController.swift
//  MotionLED
//
//  Created by youringtone on 2016/02/13.
//  Copyright © 2016年 youringtone. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    //定数
    let FILTERING_FACTOR: Float = 0.1
    
    //変数
    var _motionManager: CMMotionManager?
    var _label: UILabel?
    var _aX: Float = 0
    var _aY: Float = 0
    var _aZ: Float = 0
    
    var _aXMax: Float = 0
    var _aYMax: Float = 0
    var _aZMax: Float = 0
    
    var _aXMin: Float = 0
    var _aYMin: Float = 0
    var _aZMin: Float = 0
    
    
    var _orientation: String = ""
    
    //====================
    //UI
    //====================
    //ロード完了時に呼ばれる

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //ラベルの生成
        _label = makeLabel(CGPointMake(0, 20), text: "AccelerometerEx",
            font: UIFont.systemFontOfSize(24))
        self.view.addSubview(_label!)
        
        //センサー情報の通知の開始(1)
        _motionManager = CMMotionManager()
        _motionManager!.deviceMotionUpdateInterval = 1.0/60.0
        _motionManager?.startDeviceMotionUpdatesToQueue(
            NSOperationQueue.currentQueue()!,
            withHandler: {(motion, error) in
                self.updateMotion(motion!)
        })
        
        //端末の向き通知の開始(5)
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "didRotate:",
            name: UIDeviceOrientationDidChangeNotification,
            object: nil)
    
    }
    
    //ラベルの生成
    func makeLabel(pos: CGPoint, text: NSString, font: UIFont) -> UILabel {
        let label = UILabel()
        label.frame = CGRectMake(pos.x, pos.y, 9999, 9999)
        label.text = text as String
        label.font = font
        label.textAlignment = NSTextAlignment.Left
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }
    
    //====================
    //センサー
    //====================
    //端末の向きの通知受信時の処理(6)
    func didRotate(notification: NSNotification) {
        let device = notification.object as! UIDevice
        if device.orientation == UIDeviceOrientation.LandscapeLeft {
            _orientation = "横(左90度回転)"
        } else if device.orientation == UIDeviceOrientation.LandscapeRight {
            _orientation = "横(右90度回転)"
        } else if device.orientation == UIDeviceOrientation.PortraitUpsideDown {
            _orientation = "縦(上下逆)"
        } else if device.orientation == UIDeviceOrientation.Portrait {
            _orientation = "縦"
        } else if device.orientation == UIDeviceOrientation.FaceUp {
            _orientation = "画面が上向き"
        } else if device.orientation == UIDeviceOrientation.FaceDown {
            _orientation = "画面が下向き"
        }
    }
    
    
    //モーション通知時の処理
    func updateMotion(motion: CMDeviceMotion) {
        let str = NSMutableString()
        
        //端末の加速度の取得(2)
        let gravity = motion.gravity
        str.appendString("AccelerometerEx\n")
        
        //加速度にローパスフィルタをあてる(3)
        _aX = (Float(gravity.x)*FILTERING_FACTOR) + (_aX*(1.0-FILTERING_FACTOR))
        _aY = (Float(gravity.y)*FILTERING_FACTOR) + (_aY*(1.0-FILTERING_FACTOR))
        _aZ = (Float(gravity.z)*FILTERING_FACTOR) + (_aZ*(1.0-FILTERING_FACTOR))
        
        print("X軸加速度:%+.2f\n", _aX)
        print("Y軸加速度:%+.2f\n", _aY)
        print("Z軸加速度:%+.2f\n", _aZ)
        
        //最大値チェック

        if _aXMax < _aX {
           _aXMax = _aX
            print("X　最大値　更新")
        }
        //最小値チェック
        
        if _aX < _aXMin {
            _aXMin = _aX
            print("X　最小値　更新")
        }
        
        //加速度の更新
        str.appendFormat("X軸加速度:%+.2f %+.2f %+.2f\n", _aX,_aXMax,_aXMin)
        str.appendFormat("Y軸加速度:%+.2f\n", _aY)
        str.appendFormat("Z軸加速度:%+.2f\n", _aZ)
        str.appendString("\n")
        
        
        if _motionManager!.gyroAvailable {
            //端末の傾きの取得(4)
            let attitude = motion.attitude
            
            //端末の傾きの更新
            str.appendFormat("X軸回転角度:%+.2f\n", attitude.pitch*180/M_PI)
            str.appendFormat("Y軸回転角度:%+.2f\n", attitude.yaw*180/M_PI)
            str.appendFormat("Z軸回転角度:%+.2f\n", attitude.roll*180/M_PI)
            str.appendString("\n")
        }
        
        //端末の向きの更新
        str.appendFormat("端末の向き: %@\n", _orientation)
        str.appendString("\n")
        
        //ラベルの更新
        _label!.text = str as String
        _label!.frame.size.width = 9999
        _label!.frame.size.height = 9999
        _label?.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

