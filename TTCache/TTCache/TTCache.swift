//
//  TTCache.swift
//  TTCache
//
//  Created by tanson on 16/2/26.
//  Copyright © 2016年 tanson. All rights reserved.
//


import UIKit

public extension YTKTable{
    
    //obj: is one or (NSNumber, String , Array , Dictionary)
    public func put(obj:Any,toKey:String) throws {
        do{
            try self.put(toKey <- obj)
        }catch let error{
            throw error
        }
    }
    
    public func getAllYTKObject()->[YTKObject]{
        let allItem = self.getAllItems()
        return allItem.flatMap{ $0.itemObject }
    }
    
    public func getAllStirng()->[String]{
        let allObj = self.getAllYTKObject()
        return allObj.flatMap{ $0.stringValue }
    }
}

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
    
    // 修剪 table 到指定大小,按 时间 从大到小,(可能定时器定时调用，实现缓存失效算法)
    public func trimToSizeByDate(tableName table:String,size:Int){
        
        let table = self.getTable(table)
        guard table != nil else { return }
        
        let allItem = table?.getAllItems()
        var itemCount = allItem!.count
        guard itemCount > size else { return }
        
        // > 升序 , < 降序 // sql取出也是排好序的??
        //let allItemInSort = allItem?.sort{ $1.createdTime?.timeIntervalSinceDate($0.createdTime!) > 0.0  }
        let allItemInSort = allItem
        
        for item in allItemInSort! {
            do {
                try table?.deletePreLike(item.itemId)
                itemCount--
                if itemCount <= size { break }
            }catch{
                
            }
        }

    }
}

