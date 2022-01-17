//
//  ViewController.swift
//  RefreshAPIProtocol
//
//  Created by 장효원 on 2022/01/17.
//

import UIKit
import Alamofire
import SwiftyJSON
import JAlert

class ViewController: UIViewController {
    var timer:Timer!
    var count:Int = 0
    @IBOutlet var startButton: UIButton!
    @IBOutlet var endButton: UIButton!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 1
        endButton.layer.borderColor = UIColor.black.cgColor
        endButton.layer.borderWidth = 1
    }

    func setTimer(isStrat:Bool) {
        if isStrat {
            let alert = JAlert(title: "알림", message: "타이머를 시작합니다.", alertType: .default)
            alert.setButton(actionName: "OK", onActionClicked: {
                self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.requestAPI), userInfo: nil, repeats: true)
            })
            alert.show()
        } else {
            if timer == nil {
                DispatchQueue.main.async {
                    let alert = JAlert(title: "알림", message: "타이머를 먼저 시작해주세요.", alertType: .default)
                    alert.show()
                }
                return
            }
            
            timer.invalidate()
            timer = nil
            
            let alert = JAlert(title: "알림", message: "타이머를 종료합니다.", alertType: .default)
            alert.show()
        }
    }
    
    @objc func requestAPI() {
        AF.request("https://gist.githubusercontent.com/JacksonJang/12c792ac5856900ea4fb5640f8c5d4e4/raw/299ec4b301973eef7dc3bff4031507dbefa6629f/example.json",
                   method: .get).responseJSON { response in
            switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    
                    DispatchQueue.main.async {
                        self.resultLabel.text = json.rawString()
                    }
                    
                    if self.count >= 10 {
                        self.count = 0
                        self.setTimer(isStrat: false)
                        break
                    }
                
                    self.count += 1
                    self.updateCountLabel(count: String(self.count))
                    debugPrint(json)
                    break
                case .failure(let error) :
                    print("에러 발생")
                    print(error)
                    let alert = JAlert(title: "알림", message: "에러 발생", alertType: .default)
                    alert.show()
                    break
                }
        }
    }
    
    func updateCountLabel(count:String) {
        DispatchQueue.main.async {
            self.countLabel.text = "시도한 횟수 : \(count)"
        }
    }
    
    @IBAction func onTouchStart(_ sender: Any) {
        setTimer(isStrat: true)
    }
    
    @IBAction func onTouchStop(_ sender: Any) {
        setTimer(isStrat: false)
    }
}

