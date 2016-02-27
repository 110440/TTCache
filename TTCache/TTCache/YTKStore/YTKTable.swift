//
//  YTKTable.swift
//  YTKKeyValueStore
//
//  Created by ysq on 15/2/11.
//  Copyright (c) 2015年 sgxiang. All rights reserved.
//

import UIKit
import SQLite


public struct YTKTable{
    
    public let name : String?
    
    public var isExists : Bool {
        get{
            guard tableHandle != nil else{
                return false
            }
            return db?.scalar("SELECT EXISTS (SELECT * FROM sqlite_master WHERE type = 'table' AND name = ?)",name) as! Int64 > 0
        }
    }
    
    internal let db : Connection?
    internal let tableHandle : Table?
    
    internal init(db : Connection?, _ tableName : String!){
        if YTKTable.checkTableName(tableName){
            self.db = db
            self.name = tableName
            self.tableHandle = Table(tableName)
        }else{
            self.db = nil
            self.name = nil
            self.tableHandle = nil
        }
    }
    
    
    // MARK: -
    internal static func checkTableName(tableName : String!)->Bool{
        if tableName.containsString(" "){
            print("table name : \(tableName) format error")
            return false
        }
        return true
    }
    
    public func clear() throws ->Int{
        
        do{
            let changes = try db?.run(tableHandle!.delete()) ?? 0
            print("table : \(self.name)  number of deleted rows : \(changes)")
            return changes
        }catch let error{
            throw error
        }
        
    }
    
    public func delete(objectIds : String... ) throws -> Int{
        
        do{
            let changes = try db?.run(tableHandle!.filter(objectIds.contains(ID)).delete()) ?? 0
            print("table : <\(self.name!)>  number of deleted rows : \(changes)")
            return changes
        }catch let error{
            throw error
        }

    }
    
    public func deletePreLike(objectId : String!) throws -> Int{
        
        do{
            let changes = try db?.run(tableHandle!.filter(ID.like("\(objectId)%")).delete()) ?? 0
            print("table : <\(self.name!)>  number of deleted rows : \(changes)")
            return changes
        }catch let error{
            throw error
        }
    }
    
    private enum YTKKeyValueType{
        case String,Number,Object
    }
    
    private static func valueWithType(object : AnyObject!)->YTKKeyValueType{
        if object is String{
            return .String
        }else if (object as? NSNumber) != nil{
            return .Number
        }else{
            return .Object
        }
    }
    
    public func put( set :  YTKSetter ) throws{
        
        guard let jsonString : String = set.jsonString else{
            throw YTKError.ValueNoSupport
        }
        
        let query = tableHandle!.filter(ID == set.objectId).limit(1)
        
        do {
            
            if let filter = try db?.prepare(query){
                if filter.generate().next() == nil{
                    do{
                        try db?.run( tableHandle!.insert(ID <- set.objectId,JSON <- jsonString,UPDATETIME <- NSDate(),CREATEDTIME <- NSDate()) )
                        print("[insert] table:<\(name!)> id : \(set.objectId)  jsonString : \(set.jsonString!)")
                   
                    }catch let error{
                        throw error
                    }
                }else{
                    do{
                        try db?.run(query.update(JSON <- jsonString,UPDATETIME <- NSDate()))
                        print("[update] table:<\(name!)> id : \(set.objectId)  jsonString : \(set.jsonString!)")
                    }catch let error{
                        throw error
                    }
                }
            }
        }catch let error{
            throw error
        }
        
    }
    
    public func get( objectId : String! ) -> YTKObject?{
        if let item = self.getItem(objectId){
            return item.itemObject
        }
        return nil
    }
    
    public func getItem(objectId :String!)->YTKItem?{
        
        do {
            if let filter = try db?.prepare( tableHandle!.filter(ID == objectId).limit(1) ){
                for v in filter{
                    var item = YTKItem()
                    item.itemId = objectId
                    item.itemObject = YTKObject(value: v[JSON] )
                    item.createdTime = v.get(CREATEDTIME)
                    item.updateTime = v.get(UPDATETIME)
                    return item
                }
            }
        }catch let error {
            print("TTCache YTKTable getItem() error:\(error)")
            return nil
        }
        return nil
    }
    
    public func getAllItems()->[YTKItem]{
        
        var result : [YTKItem] = []
        do{
            if let filter = try db?.prepare(tableHandle!){
                for vs in filter{
                    var item = YTKItem()
                    item.itemId = vs[ID]
                    item.itemObject = YTKObject(value:vs[JSON])
                    item.createdTime = vs.get(CREATEDTIME)
                    item.updateTime = vs.get(UPDATETIME)
                    result.append(item)
                }
            }
        }catch let error{
            print("TTCache YTKTable getItem() error:\(error)")
            return result
        }
        return result
    }
    
    
}
