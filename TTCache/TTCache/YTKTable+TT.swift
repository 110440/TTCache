//
//  YTKTable+TT.swift
//  TTCache
//
//  Created by tanson on 16/3/12.
//  Copyright © 2016年 tanson. All rights reserved.
//

import Foundation


//MARK:- YTKTable extension
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
    
    public var count:Int {
        get{
            return self.db!.scalar(self.tableHandle!.count)
        }
    }
}
