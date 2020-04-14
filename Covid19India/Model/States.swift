//
//  States.swift
//  Covid19India
//
//  Created by CeX on 13/04/20.
//  Copyright © 2020 CeX. All rights reserved.
//

import Foundation

public class StatesDailyData: Codable {
    var an : String?
    var ap : String?
    var ar : String?
    var assam : String?
    var br : String?
    var ch : String?
    var ct : String?
    var date : String?
    var dd : String?
    var dl : String?
    var dn : String?
    var ga : String?
    var gj : String?
    var hp : String?
    var hr : String?
    var jh : String?
    var jk : String?
    var ka : String?
    var kl : String?
    var la : String?
    var ld : String?
    var mh : String?
    var ml : String?
    var mn : String?
    var mp : String?
    var mz : String?
    var nl : String?
    var or : String?
    var pb : String?
    var py : String?
    var rj : String?
    var sk : String?
    var status : String?
    var tg : String?
    var tn : String?
    var tr : String?
    var tt : String?
    var up : String?
    var ut : String?
    var wb : String?
    
    public enum CodingKeys: String, CodingKey {
        case an = "an"
        case ap = "ap"
        case ar = "ar"
        case assam = "as"
        case br = "br"
        case ch = "ch"
        case ct = "ct"
        case date = "date"
        case dd = "dd"
        case dl = "dl"
        case dn = "dn"
        case ga = "ga"
        case gj = "gj"
        case hp = "hp"
        case hr = "hr"
        case jh = "jh"
        case jk = "jk"
        case ka = "ka"
        case kl = "kl"
        case la = "la"
        case ld = "ld"
        case mh = "mh"
        case ml = "ml"
        case mn = "mn"
        case mp = "mp"
        case mz = "mz"
        case nl = "nl"
        case or = "or"
        case pb = "pb"
        case py = "py"
        case rj = "rj"
        case sk = "sk"
        case status = "status"
        case tg = "tg"
        case tn = "tn"
        case tr = "tr"
        case tt = "tt"
        case up = "up"
        case ut = "ut"
        case wb = "wb"
    }

    
    
}
