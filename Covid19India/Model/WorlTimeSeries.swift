//
//  WorlTimeSeries.swift
//  Covid19India
//
//  Created by CeX on 15/04/20.
//  Copyright © 2020 CeX. All rights reserved.
//

import UIKit

class WorldTimeSeries: Codable {
    static var URLString : String = "https://pomber.github.io/covid19/timeseries.json"

    var afghanistan : [Timeseries]?
    var albania : [Timeseries]?
    var algeria : [Timeseries]?
    var andorra : [Timeseries]?
    var angola : [Timeseries]?
    var argentina : [Timeseries]?
    var armenia : [Timeseries]?
    var australia : [Timeseries]?
    var austria : [Timeseries]?
    var azerbaijan : [Timeseries]?
    var bahamas : [Timeseries]?
    var bahrain : [Timeseries]?
    var bangladesh : [Timeseries]?
    var barbados : [Timeseries]?
    var belarus : [Timeseries]?
    var belgium : [Timeseries]?
    var benin : [Timeseries]?
    var bhutan : [Timeseries]?
    var bolivia : [Timeseries]?
    var brazil : [Timeseries]?
    var brunei : [Timeseries]?
    var bulgaria : [Timeseries]?
    var cambodia : [Timeseries]?
    var cameroon : [Timeseries]?
    var canada : [Timeseries]?
    var centralAfricanRepublic : [Timeseries]?
    var chad : [Timeseries]?
    var chile : [Timeseries]?
    var china : [Timeseries]?
    var colombia : [Timeseries]?
    var croatia : [Timeseries]?
    var cuba : [Timeseries]?
    var cyprus : [Timeseries]?
    var czechia : [Timeseries]?
    var denmark : [Timeseries]?
    var djibouti : [Timeseries]?
    var ecuador : [Timeseries]?
    var egypt : [Timeseries]?
    var eritrea : [Timeseries]?
    var estonia : [Timeseries]?
    var eswatini : [Timeseries]?
    var ethiopia : [Timeseries]?
    var fiji : [Timeseries]?
    var finland : [Timeseries]?
    var france : [Timeseries]?
    var gabon : [Timeseries]?
    var gambia : [Timeseries]?
    var georgia : [Timeseries]?
    var germany : [Timeseries]?
    var ghana : [Timeseries]?
    var greece : [Timeseries]?
    var guatemala : [Timeseries]?
    var guinea : [Timeseries]?
    var guyana : [Timeseries]?
    var haiti : [Timeseries]?
    var honduras : [Timeseries]?
    var hungary : [Timeseries]?
    var iceland : [Timeseries]?
    var india : [Timeseries]?
    var indonesia : [Timeseries]?
    var iran : [Timeseries]?
    var iraq : [Timeseries]?
    var ireland : [Timeseries]?
    var israel : [Timeseries]?
    var italy : [Timeseries]?
    var jamaica : [Timeseries]?
    var japan : [Timeseries]?
    var jordan : [Timeseries]?
    var kazakhstan : [Timeseries]?
    var kenya : [Timeseries]?
    var southKorea : [Timeseries]?
    var kuwait : [Timeseries]?
    var kyrgyzstan : [Timeseries]?
    var latvia : [Timeseries]?
    var lebanon : [Timeseries]?
    var liberia : [Timeseries]?
    var liechtenstein : [Timeseries]?
    var lithuania : [Timeseries]?
    var luxembourg : [Timeseries]?
    var madagascar : [Timeseries]?
    var malaysia : [Timeseries]?
    var maldives : [Timeseries]?
    var malta : [Timeseries]?
    var mauritania : [Timeseries]?
    var mauritius : [Timeseries]?
    var mexico : [Timeseries]?
    var moldova : [Timeseries]?
    var monaco : [Timeseries]?
    var mongolia : [Timeseries]?
    var montenegro : [Timeseries]?
    var morocco : [Timeseries]?
    var namibia : [Timeseries]?
    var nepal : [Timeseries]?
    var netherlands : [Timeseries]?
    var newZealand : [Timeseries]?
    var nicaragua : [Timeseries]?
    var niger : [Timeseries]?
    var nigeria : [Timeseries]?
    var norway : [Timeseries]?
    var oman : [Timeseries]?
    var pakistan : [Timeseries]?
    var panama : [Timeseries]?
    var paraguay : [Timeseries]?
    var peru : [Timeseries]?
    var philippines : [Timeseries]?
    var poland : [Timeseries]?
    var portugal : [Timeseries]?
    var qatar : [Timeseries]?
    var romania : [Timeseries]?
    var russia : [Timeseries]?
    var rwanda : [Timeseries]?
    var saudiArabia : [Timeseries]?
    var senegal : [Timeseries]?
    var serbia : [Timeseries]?
    var seychelles : [Timeseries]?
    var singapore : [Timeseries]?
    var slovakia : [Timeseries]?
    var slovenia : [Timeseries]?
    var somalia : [Timeseries]?
    var southAfrica : [Timeseries]?
    var spain : [Timeseries]?
    var sriLanka : [Timeseries]?
    var sudan : [Timeseries]?
    var suriname : [Timeseries]?
    var sweden : [Timeseries]?
    var switzerland : [Timeseries]?
    var taiwan : [Timeseries]?
    var tanzania : [Timeseries]?
    var thailand : [Timeseries]?
    var togo : [Timeseries]?
    var trinidadAndTobago : [Timeseries]?
    var tunisia : [Timeseries]?
    var turkey : [Timeseries]?
    var uganda : [Timeseries]?
    var ukraine : [Timeseries]?
    var unitedArabEmirates : [Timeseries]?
    var unitedKingdom : [Timeseries]?
    var uruguay : [Timeseries]?
    var usa : [Timeseries]?
    var uzbekistan : [Timeseries]?
    var venezuela : [Timeseries]?
    var vietnam : [Timeseries]?
    var zambia : [Timeseries]?
    var zimbabwe : [Timeseries]?
    var dominica : [Timeseries]?
    var grenada : [Timeseries]?
    var mozambique : [Timeseries]?
    var syria : [Timeseries]?
    var yemen : [Timeseries]?
    var diamondPrincess : [Timeseries]?
    var dominicanRepublic : [Timeseries]?
    var holySee : [Timeseries]?
    var belize : [Timeseries]?
    var laos : [Timeseries]?
    var libya : [Timeseries]?
    var mali : [Timeseries]?
    var kosovo : [Timeseries]?
    var burma : [Timeseries]?
    var botswana : [Timeseries]?
    var burundi : [Timeseries]?
    var malawi : [Timeseries]?
    
    enum CodingKeys: String, CodingKey {
        case afghanistan = "Afghanistan"
        case albania = "Albania"
        case algeria = "Algeria"
        case andorra = "Andorra"
        case angola = "Angola"
        case argentina = "Argentina"
        case armenia = "Armenia"
        case australia = "Australia"
        case austria = "Austria"
        case azerbaijan = "Azerbaijan"
        case bahamas = "Bahamas"
        case bahrain = "Bahrain"
        case bangladesh = "Bangladesh"
        case barbados = "Barbados"
        case belarus = "Belarus"
        case belgium = "Belgium"
        case benin = "Benin"
        case bhutan = "Bhutan"
        case bolivia = "Bolivia"
        case brazil = "Brazil"
        case brunei = "Brunei"
        case bulgaria = "Bulgaria"
        case cambodia = "Cambodia"
        case cameroon = "Cameroon"
        case canada = "Canada"
        case centralAfricanRepublic = "Central African Republic"
        case chad = "Chad"
        case chile = "Chile"
        case china = "China"
        case colombia = "Colombia"
        case croatia = "Croatia"
        case diamondPrincess = "Diamond Princess"
        case cuba = "Cuba"
        case cyprus = "Cyprus"
        case czechia = "Czechia"
        case denmark = "Denmark"
        case djibouti = "Djibouti"
        case dominicanRepublic = "Dominican Republic"
        case ecuador = "Ecuador"
        case egypt = "Egypt"
        case eritrea = "Eritrea"
        case estonia = "Estonia"
        case eswatini = "Eswatini"
        case ethiopia = "Ethiopia"
        case fiji = "Fiji"
        case finland = "Finland"
        case france = "France"
        case gabon = "Gabon"
        case gambia = "Gambia"
        case georgia = "Georgia"
        case germany = "Germany"
        case ghana = "Ghana"
        case greece = "Greece"
        case guatemala = "Guatemala"
        case guinea = "Guinea"
        case guyana = "Guyana"
        case haiti = "Haiti"
        case holySee = "Holy See"
        case honduras = "Honduras"
        case hungary = "Hungary"
        case iceland = "Iceland"
        case india = "India"
        case indonesia = "Indonesia"
        case iran = "Iran"
        case iraq = "Iraq"
        case ireland = "Ireland"
        case israel = "Israel"
        case italy = "Italy"
        case jamaica = "Jamaica"
        case japan = "Japan"
        case jordan = "Jordan"
        case kazakhstan = "Kazakhstan"
        case kenya = "Kenya"
        case southKorea = "Korea, South"
        case kuwait = "Kuwait"
        case kyrgyzstan = "Kyrgyzstan"
        case latvia = "Latvia"
        case lebanon = "Lebanon"
        case liberia = "Liberia"
        case liechtenstein = "Liechtenstein"
        case lithuania = "Lithuania"
        case luxembourg = "Luxembourg"
        case madagascar = "Madagascar"
        case malaysia = "Malaysia"
        case maldives = "Maldives"
        case malta = "Malta"
        case mauritania = "Mauritania"
        case mauritius = "Mauritius"
        case mexico = "Mexico"
        case moldova = "Moldova"
        case monaco = "Monaco"
        case mongolia = "Mongolia"
        case montenegro = "Montenegro"
        case morocco = "Morocco"
        case namibia = "Namibia"
        case nepal = "Nepal"
        case netherlands = "Netherlands"
        case newZealand = "New Zealand"
        case nicaragua = "Nicaragua"
        case niger = "Niger"
        case nigeria = "Nigeria"
        case norway = "Norway"
        case oman = "Oman"
        case pakistan = "Pakistan"
        case panama = "Panama"
        case paraguay = "Paraguay"
        case peru = "Peru"
        case philippines = "Philippines"
        case poland = "Poland"
        case portugal = "Portugal"
        case qatar = "Qatar"
        case romania = "Romania"
        case russia = "Russia"
        case rwanda = "Rwanda"
        case saudiArabia = "Saudi Arabia"
        case senegal = "Senegal"
        case serbia = "Serbia"
        case seychelles = "Seychelles"
        case singapore = "Singapore"
        case slovakia = "Slovakia"
        case slovenia = "Slovenia"
        case somalia = "Somalia"
        case southAfrica = "South Africa"
        case spain = "Spain"
        case sriLanka = "Sri Lanka"
        case sudan = "Sudan"
        case suriname = "Suriname"
        case sweden = "Sweden"
        case switzerland = "Switzerland"
        case taiwan = "Taiwan*"
        case tanzania = "Tanzania"
        case thailand = "Thailand"
        case togo = "Togo"
        case trinidadAndTobago = "Trinidad and Tobago"
        case tunisia = "Tunisia"
        case turkey = "Turkey"
        case uganda = "Uganda"
        case ukraine = "Ukraine"
        case unitedArabEmirates = "United Arab Emirates"
        case unitedKingdom = "United Kingdom"
        case uruguay = "Uruguay"
        case usa = "US"
        case uzbekistan = "Uzbekistan"
        case venezuela = "Venezuela"
        case vietnam = "Vietnam"
        case zambia = "Zambia"
        case zimbabwe = "Zimbabwe"
        case dominica = "Dominica"
        case grenada = "Grenada"
        case mozambique = "Mozambique"
        case syria = "Syria"
        case belize = "Belize"
        case laos = "Laos"
        case libya = "Libya"
        case mali = "Mali"
        case kosovo = "Kosovo"
        case burma = "Burma"
        case botswana = "Botswana"
        case burundi = "Burundi"
        case malawi = "Malawi"
        case yemen = "Yemen"
    }
    
    class func GET(completionHandler: @escaping (_ timeseries  : WorldTimeSeries?, Error?) -> Void)    {
          Parser.GET(urlString: URLString, completionHandler: completionHandler)
    }
}

public class Timeseries : Codable  {
    var date : String?
    var confirmed : Int?
    var deaths : Int?
    var recovered : Int?
    var active : Int?    {
        return ((self.confirmed ?? 0) - ((self.deaths ?? 0) + (self.recovered ?? 0)))
    }
    public enum CodingKeys: String, CodingKey {
        case date = "date"
        case confirmed = "confirmed"
        case deaths = "deaths"
        case recovered = "recovered"
    }
}
