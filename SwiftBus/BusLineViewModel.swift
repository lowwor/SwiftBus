//
//  BusViewModel.swift
//  SwiftBus
//
//  Created by ChenCheung Kit on 16/1/16.
//  Copyright © 2016年 ChenCheung Kit. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import Alamofire


class BusLineViewModel{
   
    var disposeBag = DisposeBag()
    private let backgroundWorkScheduler = ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)

    var tableViewStations = PublishSubject<[BusStation]>()
    var tableViewBuses = PublishSubject<[Bus]>()
    var errorAlertController = PublishSubject<UIAlertController>()
    var busLine: BusLine?{
        didSet{
            updateStation()
        }
    }
    
    var lineName :String?
    var fromStation:String?
    var direction  : Bool = true{
        didSet{
            getBusLineForRequest(self.searchText!, directionPositive: self.direction)
        }
    }

    
    var subscription:Disposable?
    
    private var busStations:[BusStation]?
    private var buses:[Bus]?

    var busLineService = BusLineService()

    func updateStation() {
        
        busStations = busLine?.busStations
        if let tempBusStations = busStations {
            tableViewStations.on(.Next(tempBusStations))
        }
    }
    
    func updateBuses() {
        buses = busLine?.buses
        if let tempBuses = buses {
            tableViewBuses.on(.Next(tempBuses))
        }
    }
    
    var searchText:String? {
        didSet {
            if let busLineName = searchText {
                print(searchText)
                getBusLineForRequest(busLineName,directionPositive: true)
            }
        }
    }
    
    func getBusLineForRequest(lineName: String,directionPositive: Bool) {
     busLineService.searchLine(lineName)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { json in
//                    print("JSON: \(json)")
                        let line = JSON(json)
                    
                    if(directionPositive){
                        self.lineName=line["d"][0]["Name"].string!
                        self.fromStation = line["d"][0]["FromStation"].string!
                        self.getStatationByLineId(line["d"][0]["Id"].string!)

                    }else{
                        self.lineName=line["d"][1]["Name"].string!
                        self.fromStation = line["d"][1]["FromStation"].string!
                        self.getStatationByLineId(line["d"][1]["Id"].string!)

                    }
                    
                },
                onError: { error in
                    print("Got error")
                    let gotError = error as NSError
                    
                    print(gotError.domain)
                    self.postError("\(gotError.code)", message: gotError.domain)
            })
            .addDisposableTo(disposeBag)
    }
    
    
    func getStatationByLineId(lineId: String ) {
        busLineService.getStatationByLineId(lineId)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { json in
//                    print("JSON: \(json)")
                    self.busLine = BusLine(jsonObject: json)
                    self.getBusListOnRoadForRequest(self.lineName!, fromStation: self.fromStation!)
                },
                onError: { error in
                    print("Got error")
                    let gotError = error as NSError
                    
                    print(gotError.domain)
                    self.postError("\(gotError.code)", message: gotError.domain)
            })
            .addDisposableTo(disposeBag)
    }
    
    // MARK explicit declare Int  ,sometime can't refer type
    func autoRefreshBus(){
        subscription =    Observable<Int>.interval(3.0,scheduler: backgroundWorkScheduler).subscribe{ event in
            if let lineName = self.lineName ,fromStation = self.fromStation{
                       self.getBusListOnRoadForRequest(lineName,fromStation: fromStation)
            }

        }
  
    }
    
    func cancelAutoRefreshBus(){
        if let subscription = subscription{
            subscription.dispose()

        }
    
    }
    
    func getBusListOnRoadForRequest(lineName: String , fromStation:String) {
        busLineService.getBusListOnRoad( lineName, fromStation: fromStation)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { jsonObject in
                    print("JSON: \(jsonObject)")
                    self.busLine?.initBus( jsonObject)
                    self.updateBuses()
                },
                onError: { error in
                    print("Got error")
                    let gotError = error as NSError
                    
                    print(gotError.domain)
                    self.postError("\(gotError.code)", message: gotError.domain)
            })
            .addDisposableTo(disposeBag)
    }
    
    func postError(title: String, message: String) {
        errorAlertController.on(.Next(UIAlertController(title: title, message: message, preferredStyle: .Alert)))
    }
    
    
}
