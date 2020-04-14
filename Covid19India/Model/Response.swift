//
//  Response.swift
//  Covid19India
//
//  Created by CeX on 03/04/20.
//  Copyright © 2020 CeX. All rights reserved.
//

import Foundation

class Response: Codable {
    static var URLString : String = "https://api.covid19india.org/data.json"
    
    var cases_time_series : [CaseTimeSeries]?
    var key_values : [KeyValues]?
    var statewise : [Statewise]?
    
    class func GET(completionHandler: @escaping (_ timeseries  : Response?, Error?) -> Void)    {
        Parser.GET(urlString: URLString, completionHandler: completionHandler)
    }
}

class KeyValues: Codable {
    var confirmeddelta : String?
    var counterforautotimeupdate : String?
    var deceaseddelta : String?
    var statewise : Statewise?
}

class Statewise: Codable {
    static var URLString : String = "https://api.covid19india.org/v2/state_district_wise.json"
    var active : String?
    var confirmed : String?
    var deaths : String?
    var recovered : String?
    var state : String?
    var delta : Delta?
    var deltaconfirmed : String?
    var deltadeaths : String?
    var deltarecovered : String?
    var date : String?
    var statecode : String?
    var districtData : [DistrictData]?
    var totalConfrimedCalculated : Int  {
        var total = 0
        for data in self.districtData ?? []  {
            total += Int(data.confirmed ?? 0)
        }
        return total
    }
    var totalConfrimedDelta : Int  {
        var total = 0
        for data in self.districtData ?? []  {
            total += data.delta?.confirmed ?? 0
        }
        return total
    }
    
    class func GET(completionHandler: @escaping (_ timeseries  : [Statewise]?, Error?) -> Void)    {
        Parser.GET(urlString: URLString, completionHandler: completionHandler)
    }
}

class DistrictData: Codable {
    var district : String?
    var confirmed : Int?
    var delta : Delta?
}

class Delta : Codable  {
    var active : Int?
    var confirmed : Int?
    var deaths : Int?
    var recovered : Int?
}


class CaseTimeSeries: Codable {
    var dailyconfirmed : String?
    var dailydeceased : String?
    var dailyrecovered : String?
    var date : String?
    var totalconfirmed : String?
    var totaldeceased : String?
    var totalrecovered : String?
    var active : String? {
        let confirmed = Int(self.totalconfirmed ?? "") ?? 0
        let deceased = Int(self.totaldeceased ?? "") ?? 0
        let recovered = Int(self.totalrecovered ?? "") ?? 0
        let active = (confirmed - (deceased + recovered))
        return String(active)
    }
}

class StateWiseData : Codable   {
    static var URLString : String = "https://api.covid19india.org/states_daily.json"

    var states_daily : [StatesDailyData]? = []
    var states_daily_confirmed : [StatesDailyData]  {
        return self.getStates(byStatus: "Confirmed")
    }
    var states_daily_deceased : [StatesDailyData]  {
        return self.getStates(byStatus: "Deceased")
    }
    var states_daily_recovered : [StatesDailyData]  {
        return self.getStates(byStatus: "Recovered")
    }
        
    class func GET(completionHandler: @escaping (_ timeseries  : StateWiseData?, Error?) -> Void)    {
        Parser.GET(urlString: URLString, completionHandler: completionHandler)
    }
    
    func getForStates(_ statesWise : [Statewise]) -> [String : [Statewise]] {
        guard let keys = self.states_daily_confirmed.first.toDict()?.keys else { return [:] }
        var statesObject : [String : [Statewise]] = [:]
        let stateKeys = Array(keys)
        for stateKey in stateKeys   {
            if stateKey != StatesDailyData.CodingKeys.date.stringValue && stateKey != StatesDailyData.CodingKeys.status.stringValue {
                print(stateKey)
                var stateCode = stateKey.uppercased()
                let stateTemp = statesWise.filter{$0.statecode == stateCode}.first
                stateCode = stateCode.lowercased()
                guard let state = stateTemp else { return [:] }
                var prevConfirmed = 0
                var prevDeceased = 0
                var prevRecovered = 0
                var confirmed = (Int(state.confirmed ?? "") ?? 0)
                var deceased = (Int(state.deaths ?? "") ?? 0)
                var recovered = (Int(state.recovered ?? "") ?? 0)
                var states : [Statewise] = []
                for i in 0..<(self.states_daily_confirmed.reversed()).count   {
                    let sc = self.states_daily_confirmed.reversed()[i]
                    let sd = self.states_daily_deceased.reversed()[i]
                    let sr = self.states_daily_recovered.reversed()[i]
                    let scDict = sc.toDict()
                    let sdDict = sd.toDict()
                    let srDict = sr.toDict()
                    let statewise = Statewise()
                    confirmed = confirmed - prevConfirmed
                    deceased = deceased - prevDeceased
                    recovered = recovered - prevRecovered
                    let active = (confirmed - (deceased + recovered))
                    statewise.confirmed = "\(confirmed)"
                    statewise.deaths = "\(deceased)"
                    statewise.recovered = "\(recovered)"
                    statewise.active = "\(active)"
                    prevConfirmed = Int((scDict?[stateCode] as? String) ?? "") ?? 0
                    prevDeceased = Int((sdDict?[stateCode] as? String) ?? "") ?? 0
                    prevRecovered = Int((srDict?[stateCode] as? String) ?? "") ?? 0
                    statewise.date = sc.date
                    statewise.deltaconfirmed = String(prevConfirmed)
                    statewise.deltadeaths = String(prevDeceased)
                    statewise.deltarecovered = String(prevRecovered)
                    states.append(statewise)
                }
                statesObject[stateCode.uppercased()] = states.reversed()
            }
        }
        return statesObject
    }
    
    func getStates(byStatus status : String) -> [StatesDailyData] {
        guard let states = self.states_daily else { return [] }
        var array = [StatesDailyData]()
        for state in states  {
            if state.status == status  {
                array.append(state)
            }
        }
        return array
    }
    
    func getActive(forState state : String?) -> [StatesDailyData] {
        guard let state = state?.lowercased() else { return [] }
        let confirmedArray = self.states_daily_confirmed
        let deceasedArray = self.states_daily_deceased
        let recoveredArray = self.states_daily_recovered
        var array = [StatesDailyData]()
        for i in 0..<confirmedArray.count  {
            let confirmed = Int((confirmedArray[i].toDict()?[state] as? String) ?? "") ?? 0
            let deceased = Int((deceasedArray[i].toDict()?[state] as? String) ?? "") ?? 0
            let recovered = Int((recoveredArray[i].toDict()?[state] as? String) ?? "") ?? 0
            let active = confirmed - (deceased + recovered)
            var activeDict : [String : Any] = [:]
            activeDict[StatesDailyData.CodingKeys.date.stringValue] = confirmedArray[i].date
            activeDict[state] = "\(active)"
            let data = activeDict.toData()
            do {
                let activeObject = try JSONDecoder().decode(StatesDailyData.self, from: data!)
                array.append(activeObject)
            }
            catch let e {
                print(e)
            }
        }
        return array
    }
}



class Maharashtra: Codable {
    static var URLString : String = "https://services5.arcgis.com/h1qecetkQkV9PbPV/arcgis/rest/services/DatewiseCumulative/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=OBJECTID%2CPositive_Cumulative%2CReport_Date&orderByFields=Report_Date%20asc&resultOffset=0&resultRecordCount=2000&cacheHint=true"
    
    var features : [Feature]?
    
    class func GET(completionHandler: @escaping (_ timeseries  : Maharashtra?, Error?) -> Void)    {
        Parser.GET(urlString: URLString, completionHandler: completionHandler)
    }
}

class Feature: Codable {
    var attributes : Attribute?
}

class Attribute: Codable {
    var OBJECTID : Int?
    var Positive_Cumulative : Int?
    var Report_Date : Int?
}

