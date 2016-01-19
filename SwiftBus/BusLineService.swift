//
//  BusLineService.swift
//  SwiftBus
//
//  Created by ChenCheung Kit on 16/1/17.
//  Copyright © 2016年 ChenCheung Kit. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

class BusLineService{
    struct Constants {
        static let baseUrl = "http://www.zhbuswx.com/BusLine/WS.asmx/"
        static let searchLine =   "SearchLine"
        static let getStatationByLineId = "LoadStationByLineId"
        static let getBusListOnRoad = "GetBusListOnRoad"
        
    }
    
    func searchLine(lineName:String) -> Observable<AnyObject>{
//        print(lineName)
        let parameters = [
            "key":lineName
        ]
        return  Alamofire.request(.POST, Constants.baseUrl+Constants.searchLine,parameters:parameters,encoding: .JSON).rx_responseJSON()
    }
    
    func getStatationByLineId(lineId:String) -> Observable<AnyObject>{
//        print(lineId)
        let parameters = [
            "lineId":lineId
        ]
        return  Alamofire.request(.POST, Constants.baseUrl+Constants.getStatationByLineId,parameters:parameters,encoding: .JSON).rx_responseJSON()    }
    
    func getBusListOnRoad(lineName:String,fromStation:String) -> Observable<AnyObject>{
        print(lineName+fromStation)
        let parameters = [
             "lineName":lineName,
             "fromStation":fromStation
        ]
        return  Alamofire.request(.POST, Constants.baseUrl+Constants.getBusListOnRoad,parameters:parameters,encoding: .JSON).rx_responseJSON()    }
    
    
}