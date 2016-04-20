//
//  ViewController.swift
//  MotionLED
//
//  Created by youringtone on 2016/02/13.
//  Copyright © 2016年 youringtone. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController ,UITableViewDelegate{
    
    //MARK:IBOutlet
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var label_demoScreen: UILabel!
    
    @IBOutlet weak var sw_ZeroGravity: UISwitch!
    //MARK:定数
    let FILTERING_FACTOR: Float = 0.1
    
    //MARK:変数
    var _motionManager: CMMotionManager?
    var _updateTime:NSTimeInterval! = 1.0/100.0
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
    
    var _colorChangeView:UIViewController?
    
    
    struct ColorSet {
        var Red:CGFloat     = 1.0
        var Green:CGFloat   = 1.0
        var Blue:CGFloat    = 1.0
        var Alpha:CGFloat   = 1.0
        func now() -> UIColor{
            return UIColor(red: Red, green: Green, blue: Blue, alpha: Alpha)
        }
    }
    var _colorSet = [ColorSet]()
    
    struct MovingColor {
        var Up      = ColorSet()
        var Down    = ColorSet()
        var Letf    = ColorSet()
        var Right   = ColorSet()
        var Stop   = ColorSet()
    }
    var _originalColorPreset = [MovingColor]()
    
    
    
    
    var _defaults = NSUserDefaults.standardUserDefaults()
    let _dic_Preset = [String:AnyObject]()

    
    //----------------------------------------------------
    //MARK:- ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.size)
        
        //センサー情報の通知の開始(1)
        _motionManager = CMMotionManager()
        //初期設定値
        _motionManager!.deviceMotionUpdateInterval = _updateTime
        
        _motionManager?.startDeviceMotionUpdatesToQueue(
            NSOperationQueue.currentQueue()!,
            withHandler: {(motion, error) in
                self.updateMotion(motion!)
        })
        
        //設定をよみこみ
        self.load_Setting()
        self.load_Preset()
        
        
    }
    
    
    //MARK:NSUserDefaults

    func load_Setting(){
        if ((_defaults.objectForKey("SETTING")) != nil){
            
//            if _originalColorPreset.count == 0 {
//                //プリセットがなにもない
//                //プリセットを準備する
//                self.firstPreiset()
//            }
            
        }
        
    }
    
    
    func load_Preset(){
        if ((_defaults.objectForKey("PRESET_COLOR")) != nil){
            
            if _originalColorPreset.count == 0 {
                //プリセットがなにもない
                //プリセットを準備する
                self.firstPreiset()
//                _defaults.setObject(_dic_Preset, forKey: "preset")
//                _defaults.setObject(_originalColorPreset, forKey: "q")
                
//                    _originalColorPreset, forKey: "PRESET_COLOR")
            }
            
        }
    }
    
    func seve_Setting(){
        
    }
    
    func save_Preset(){
        
    }

    
    @IBAction func action_ColorChange(sender: UIButton) {
        switch sender.tag {
        case 0,1,2,3,4:
            //テーブルビューにセット
            self.tableView.reloadData()
        default:
            print("No matching Button")
            
        }
        
    }
    
    @IBAction func action_ZeroGravity(sender: UISwitch) {
        if sender.on {
            //重力カット
            NSLog("重力カットする")
        }else{
            //重力あり
            NSLog("重力あり")
        }
        
    }
    
    //MARK: -
    //MARK: table view setting
    let settingList = ["Red","Green","Blue","Alpha"]
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return settingList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        print(cell.frame.size)
        let label = self.make_Label(settingList[indexPath.row],size:cell.frame.size)
        label.frame.origin = CGPoint(x: 160, y: 0)
        cell.addSubview(label)
        
        let sw = make_Switch(indexPath.row)
        sw.frame.origin = CGPoint(x: 0, y: 0)
        cell.addSubview(sw)
        return cell
    }
    // ラベル　作成
    func make_Label(string:String,size:CGSize) -> UILabel{
        let label = UILabel()
        label.frame = CGRect(x:0 , y: 0, width:size.width , height: size.height)
        label.text = string
        return label
    }
    // スイッチ作成
    func make_Switch(tag:Int) -> UISwitch{
        let sw = UISwitch()
        sw.tag = tag
        sw.on = true
        // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
        sw.addTarget(self, action: "onClickMySwicth:", forControlEvents: UIControlEvents.ValueChanged)
        return sw
    }
    
    
    //MARK: switch event
    func onClickMySwicth(sender:UISwitch){
        print(__FUNCTION__)
        
 //       var value:CGFloat = 0.0
        
        if sender.on  {
            print("スイッチNo." + String(sender.tag) + " ON")
//            value = 1.0
        }else{
            print("スイッチNo." + String(sender.tag) + " OFF")
        }
        
        
        
//        switch sender.tag {
//        case 0:
//            _newColor.Red = value
//        case 1:
//            _newColor.Green = value
//        case 2:
//            _newColor.Blue = value
//        case 3:
//            _newColor.Alpha = value
//        default:
//            print("変更なし")
//            
//        }
        
        
 //       self.chenge_BackGroundColer()
    }
    
    func chenge_BackGroundColer(){
//        self.view.backgroundColor = UIColor(red:_newColor.Red , green: _newColor.Green, blue: _newColor.Blue, alpha: _newColor.Alpha)
    }
    
    
    
    func firstPreiset(){
        
        func color(){
            
            var colset = ColorSet()
            
            let white = colset
            
            colset.Red = 0.0
            colset.Green = 0.0
            colset.Blue = 0.0
            colset.Alpha = 1.0
            let black = colset
            
            colset.Red = 1.0
            let red = colset
            
            colset.Green = 1.0
            let color_RG = colset
            
            colset.Red = 0.0
            //        colset.Green = 1.0
            let green = colset
            
            colset.Blue = 1.0
            let color_GB = colset
            
            colset.Green = 0.0
            let blue = colset
            
            colset.Red = 1.0
            let color_RB = colset
            
            _colorSet = [black,white,red,green,blue,color_RG,color_GB,color_RB]
        }
        
        func moving(){
            
            var movingColor = MovingColor()
            movingColor.Stop = _colorSet[0]
            movingColor.Up = _colorSet[1]
            movingColor.Down = _colorSet[3]
            movingColor.Letf = _colorSet[2]
            movingColor.Right = _colorSet[3]
            
            _originalColorPreset.append(movingColor)
        }
    }
    
    //ラベルの生成
    //    func makeLabel(pos: CGPoint, text: NSString, font: UIFont) -> UILabel {
    //        let label = UILabel()
    //        label.frame = CGRectMake(pos.x, pos.y, 9999, 9999)
    //        label.text = text as String
    //        label.font = font
    //        label.textAlignment = NSTextAlignment.Left
    //        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    //        label.numberOfLines = 0
    //        label.sizeToFit()
    //        return label
    //    }
    
    func changeColor(){
        
        func directionCheck(){
            //X方向
            if _aX < -0.1 {
                let r:Float = _aX * -1.0
                self.changeColorRed(r)
            }else if _aX > 0.1 {
                let r:Float = _aX
                self.changeColorRed(r)
            }
            //Y方向
            if _aY < -0.1 {
                
            }else if _aY > 0.1 {
                
            }
            //Y方向
            if _aZ < -0.1 {
                
            }else if _aZ > 0.1 {
                
            }
        }
        //軸にたいしての色設定
        
        
        directionCheck()
        
        
        
    }
    
    func changeColorRed(r:Float){
        //        print("ChangeColor")
        //        colorView.backgroundColor = UIColor(colorLiteralRed: r, green: 0, blue: 0, alpha: 1)
        
        self.view.backgroundColor = UIColor(colorLiteralRed: r, green: 0, blue: 0, alpha: 1)
    }
    func changeColorBlue(b:Float){
        //        print("ChangeColor")
        //        colorView.backgroundColor = UIColor(colorLiteralRed: r, green: 0, blue: 0, alpha: 1)
        
        self.view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: b, alpha: 1)
    }
    
    func showColorSettingValue(){
        print(self.view.backgroundColor)
    }
    
    
    
    //====================
    //MARK:センサー
    //====================
    
    //モーション通知時の処理
    func updateMotion(motion: CMDeviceMotion) {
        
        //端末の加速度の取得(2)
        let gravity = motion.gravity
        //        str.appendString("AccelerometerEx\n")
        
        //:加速度にローパスフィルタをあてる(3)
        
        _aX = (Float(gravity.x)*FILTERING_FACTOR) + (_aX*(1.0-FILTERING_FACTOR))
        _aY = (Float(gravity.y)*FILTERING_FACTOR) + (_aY*(1.0-FILTERING_FACTOR))
        _aZ = (Float(gravity.z)*FILTERING_FACTOR) + (_aZ*(1.0-FILTERING_FACTOR))
        
        //重力カット
        if self.sw_ZeroGravity.on{
         //Y軸に補正を掛ける
            
        }
            
        
        
        
        //        print("X軸加速度:%+.2f\n", _aX)
        //        print("Y軸加速度:%+.2f\n", _aY)
        //        print("Z軸加速度:%+.2f\n", _aZ)
        
        label1.text = "X軸:" + String(NSString(format: "%.2f", _aX))
        label2.text = "Y軸:" + String(NSString(format: "%.2f", _aY))
        label3.text = "Z軸:" + String(NSString(format: "%.2f", _aZ))
        
        self.changeColor()
        
        //最大値チェック
        
        if _aXMax < _aX {
            _aXMax = _aX
            print("X　最大値　更新:" + String(NSString(format: "%.2f", _aX)))
            print(String(NSString(format: "%.2f", _aX)))
        }
        //最小値チェック
        
        if _aX < _aXMin {
            _aXMin = _aX
            print("X　最小値　更新:" + String(NSString(format: "%.2f", _aX)))
            print(String(NSString(format: "%.2f", _aX)))
        }
        
        
        //        if _motionManager!.gyroAvailable {
        //            //端末の傾きの取得(4)
        //            let attitude = motion.attitude
        //
        //            //端末の傾きの更新
        //            str.appendFormat("X軸回転角度:%+.2f\n", attitude.pitch*180/M_PI)
        //            str.appendFormat("Y軸回転角度:%+.2f\n", attitude.yaw*180/M_PI)
        //            str.appendFormat("Z軸回転角度:%+.2f\n", attitude.roll*180/M_PI)
        //            str.appendString("\n")
        //        }
        //
        //        //端末の向きの更新
        //        str.appendFormat("端末の向き: %@\n", _orientation)
        //        str.appendString("\n")
        //
        //        //ラベルの更新
        //        _label!.text = str as String
        //        _label!.frame.size.width = 9999
        //        _label!.frame.size.height = 9999
        //        _label?.sizeToFit()
    }
    //端末の向きの通知受信時の処理(6)
    //    func didRotate(notification: NSNotification) {
    //        let device = notification.object as! UIDevice
    //        if device.orientation == UIDeviceOrientation.LandscapeLeft {
    //            _orientation = "横(左90度回転)"
    //        } else if device.orientation == UIDeviceOrientation.LandscapeRight {
    //            _orientation = "横(右90度回転)"
    //        } else if device.orientation == UIDeviceOrientation.PortraitUpsideDown {
    //            _orientation = "縦(上下逆)"
    //        } else if device.orientation == UIDeviceOrientation.Portrait {
    //            _orientation = "縦"
    //        } else if device.orientation == UIDeviceOrientation.FaceUp {
    //            _orientation = "画面が上向き"
    //        } else if device.orientation == UIDeviceOrientation.FaceDown {
    //            _orientation = "画面が下向き"
    //        }
    //    }
    
    //MARK: -
    //MARK:Touch Event
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        //下地と同じ色のビューをつくる
        let all = self.childViewControllers
        print(all)
        for view in all {
            if view.isKindOfClass(UILabel){
                print("UILabel")
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        
        
        
        let vc = UIViewController()
        vc.view.frame = self.view.frame
        vc.view.backgroundColor = self.view.backgroundColor
        self.view.addSubview(vc.view)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

