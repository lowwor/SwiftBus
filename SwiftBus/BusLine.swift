//
//  BusStation.swift
//  SwiftBus
//
//  Created by ChenCheung Kit on 16/1/16.
//  Copyright © 2016年 ChenCheung Kit. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias BusStation = (id:String?,name:String?,longtitude:String?,latitude:String?,description:String?)
typealias Bus = (busNumber:String?,currentStation:String?)
class BusLine{

    var busStations = [BusStation]()
    var buses = [Bus]()

    init(jsonObject: AnyObject) {
        let json = JSON(jsonObject)
        
        if let busStationArray = json["d"].array {
//            print(busStationArray.count)
            for item in busStationArray {
                let itemBusStation = (
                    id: item["Id"].string,
                    name: item["Name"].string,
                    longtitude: item["Lng"].string,
                    latitude: item["Lat"].string,
                    description: item["Description"].string)
                
                busStations.append(itemBusStation)
            }
        }
    }
    
  func  initBus(jsonObject: AnyObject) -> Void{
        buses.removeAll()
        let json = JSON(jsonObject)
        if let busArray = json["d"].array {
            print(busArray.count)
            for item in busArray {
                let itemBus = (
                    busNumber: item["BusNumber"].string,
                    currentStation: item["CurrentStation"].string)
                
                buses.append(itemBus)
            }
        }
    }
    
    
}