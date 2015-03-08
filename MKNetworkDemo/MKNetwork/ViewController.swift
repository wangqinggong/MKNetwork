//
//  ViewController.swift
//  MKNetwork
//
//  Created by wangqinggong on 15/3/9.
//  Copyright (c) 2015年 Michael King. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let net = MKNetwork()
    let urlString:String = "http://httpbin.org/get"
    
    func loadData()
    {
      net.requestJSON(.GET, urlString, nil) { (result, error) -> () in
        if error != nil
        {
            return
        }
        
        println(result)
    }

 }
}

