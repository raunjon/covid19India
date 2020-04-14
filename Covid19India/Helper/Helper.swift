//
//  Helper.swift
//  Covid19India
//
//  Created by CeX on 14/04/20.
//  Copyright © 2020 CeX. All rights reserved.
//

import Foundation

class Parser  {
    static func GET<T : Decodable>(showLoader : Bool = true, urlString : String, completionHandler: @escaping (_ timeseries  : T?, Error?) -> Void)   {
            if showLoader   {
                Loader.show()
            }
            let urlRequest = URLRequest(url: URL(string : urlString)!)
            URLSession.shared.dataTask(with: urlRequest) { (data : Data?, response : URLResponse?, error :  Error?) in
                if error != nil {
                    completionHandler(nil,error)
                }
                else    {
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data!)
                            completionHandler(response,nil)
                        }
                        catch let e {
                            completionHandler(nil,e)
                        }
                }
                Loader.hide()
                }.resume()
            }
}

extension Encodable {
    func toData() -> Data?   {
        do  {
            return try JSONEncoder().encode(self)
        }
        catch _ {
            return nil
        }
    }
    func toDict() -> [String : AnyObject]? {
        return self.toData()?.toDict()
    }
    func toPrettyPrintedJSONString() -> NSString?  {
        return self.toData()?.toPrettyPrintedJSONString()
    }
}


extension Data  {
    func toDict() -> [String : AnyObject]? {
        do  {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.allowFragments)
            guard let jsonDict = jsonObject as? [String : AnyObject] else {
                return nil
            }
            return jsonDict
        }
        catch   {
            return nil
        }
    }
    
    func toPrettyPrintedJSONString() -> NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}

struct StateCode {
    static let jsonCodes : String = """
{
    "AN":"Andaman and Nicobar Islands",
    "AP":"Andhra Pradesh",
    "AR":"Arunachal Pradesh",
    "AS":"Assam",
    "BR":"Bihar",
    "CH":"Chandigarh",
    "DN":"Dadra and Nagar Haveli",
    "DD":"Daman and Diu",
    "DL":"Delhi",
    "GA":"Goa",
    "GJ":"Gujarat",
    "HR":"Haryana",
    "HP":"Himachal Pradesh",
    "JK":"Jammu and Kashmir",
    "JH":"Jharkhand",
    "KA":"Karnataka",
    "KL":"Kerala",
    "LA":"Ladakh",
    "LD":"Lakshadweep",
    "MP":"Madhya Pradesh",
    "MH":"Maharashtra",
    "MN":"Manipur",
    "ML":"Meghalaya",
    "MZ":"Mizoram",
    "NL":"Nagaland",
    "OR":"Odisha",
    "PY":"Puducherry",
    "PB":"Punjab",
    "RJ":"Rajasthan",
    "SK":"Sikkim",
    "TN":"Tamil Nadu",
    "TS":"Telangana",
    "TR":"Tripura",
    "UP":"Uttar Pradesh",
    "UT":"Uttarakhand",
    "WB":"West Bengal",
    "CT":"Chhattisgarh",
    "TG":"Telangana",
    "TT":"Total"
}
"""
    
    static var Dictionary : [String : String] {
        return self.jsonCodes.convertToDictionary() as? [String : String] ?? [:]
    }
}

extension Dictionary {
    
    func toData() -> Data?  {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        }
        catch let e   {
            print(e)
            return nil
        }
    }
}

import UIKit

extension UIColor {

    convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension String    {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
