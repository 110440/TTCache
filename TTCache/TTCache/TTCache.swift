//
//  TTCache.swift
//  TTCache
//
//  Created by tanson on 16/2/26.
//  Copyright © 2016年 tanson. All rights reserved.
//


import UIKit

//MARK:- TTCache
public class TTCache {
    
    let keyStore:YTKKeyValueStore
    
    public static let sharedInstance:TTCache = {
        let ins = TTCache()
        return ins
    }()
    
    private init(){
        keyStore = try! YTKKeyValueStore()
    }
    
    // if no exists ,create it
    public func getTable(name:String)->YTKTable?{
        
        do{
            try self.keyStore.createTable(name)
        }catch let error{
            print("failed to create table , error : \(error)")
            return nil
        }
        
        return self.keyStore[name]
    }
    
    public func isTableExists(name:String)->Bool{
        let table = self.getTable(name)
        return table?.isExists ?? false
    }
    
    /*
    // 修剪 table 到指定大小,按 时间 从大到小,(可能定时器定时调用，实现缓存失效算法)
    // NSDate 比较 ： > 升序 , < 降序 : let ret = time1?.timeIntervalSinceDate(time2) > 0.0
    public func trimToSizeBySort(tableName table:String,size:Int,isOrderedBefore:(item1:YTKItem,item2:YTKItem)->Bool){
        let allItemInSort = allItem?.sort{ $0.time?.timeIntervalSinceDate($!.time) > 0.0 }
    }*/
    
}

