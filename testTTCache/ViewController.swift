//
//  ViewController.swift
//  testTTCache
//
//  Created by tanson on 16/2/24.
//  Copyright © 2016年 tanson. All rights reserved.
//

import UIKit
import TTCache

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.test()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func test(){
        
        let hotTable = TTCache.sharedInstance.getTable("hotTable")
        
        if hotTable!.isExists {
            print(" table is exists ")
        }
        
       
        let commTable = TTCache.sharedInstance.getTable("commTable")
        try! commTable?.put("test", toKey: "t")
        try! commTable?.delete("dd")
        try! commTable?.delete("dd")
        
        var  value = [String:AnyObject]()
        
        value["name"] = "xiaoming"
        value["age"] = 1
        try! hotTable?.put(value, toKey: "key1")
        value["age"] = 2
        try! hotTable?.put(value, toKey: "key2")
        value["age"] = 3
        try! hotTable?.put(value, toKey: "key3")
        value["age"] = 4
        try! hotTable?.put(value, toKey: "key4")
        value["age"] = 5
        try! hotTable?.put(value, toKey: "key5")
        value["age"] = 6
        try! hotTable?.put(value, toKey: "key6")
        value["age"] = 7
        try! hotTable?.put(value, toKey: "key7")
        value["age"] = 8
        try! hotTable?.put(value, toKey: "key8")
        value["age"] = 9
        try! hotTable?.put(value, toKey: "key9")
        
        let allItem = hotTable?.getAllItems()
        for item in allItem!{
            print(item.itemId)
        }

    }
    

}

