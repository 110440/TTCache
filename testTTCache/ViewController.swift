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
        let commTable = TTCache.sharedInstance.getTable("commTable")
        
        try! hotTable?.put("who i am ", toKey: "key1")
        try! hotTable?.put("i am who", toKey: "key2")
        try! hotTable?.put("i am who", toKey: "key3")
        try! hotTable?.put("i am who", toKey: "key4")
        try! hotTable?.put("i am who", toKey: "key5")
        try! hotTable?.put("i am who", toKey: "key6")
        try! hotTable?.put("i am who", toKey: "key7")
        try! hotTable?.put("i am who", toKey: "key8")
        try! hotTable?.put("i am who", toKey: "key9")
        
        try! commTable?.put("on", toKey: "key1")
        
        
        let allItem = hotTable?.getAllItems()
        for item in allItem!{
            print(item.itemId)
        }

        TTCache.sharedInstance.trimToSizeByDate(tableName: (hotTable?.name)!, size: 8)
        
        let allItem2 = hotTable?.getAllItems()
        for item in allItem2!{
            print(item.itemId)
        }
    }
    

}

