//
//  ViewController.swift
//  trafficAI
//
//  Created by Mac on 2017/9/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class ViewController: UIViewController {

    let speechSynthesizer = AVSpeechSynthesizer()

    @IBOutlet weak var tfInput: UITextField!
    
    @IBOutlet weak var viewColor: UIView!
    
    @IBAction func btnSendDidTouch(_ sender: Any)
    {
        let request = ApiAI.shared().textRequest()
        if let text = self.tfInput.text, text != "" {
            request?.query = text
        } else {
            return
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if response.result.action == "change.color"{
                if let parameters = response.result.parameters as? [String: AIResponseParameter]{
                    if let color = parameters["colors"]?.stringValue{
                        switch color{
                        case "red":
                            self.changeViewColor(color: UIColor.red)
                        case "yellow":
                            self.changeViewColor(color: UIColor.yellow)
                        default:
                            self.changeViewColor(color: UIColor.green)
                        }
                    }
                }
            } else {
                self.changeViewColor(color: UIColor.black)
            }
            
            if let textResponse = response.result.fulfillment.speech as? String{
                self.speak(text: textResponse)
            }
            
        }, failure: { (request, error) in
            print(error)
        })
        
        ApiAI.shared().enqueue(request)
        tfInput.text = ""
    }
    
    //Device speak
    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }
    //Animation with color change on UIView
    func changeViewColor(color: UIColor) {
        viewColor.alpha = 0
        viewColor.backgroundColor = color
        UIView.animate(withDuration: 1, animations: {
            self.viewColor.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

