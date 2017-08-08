//
//  AbbreviationsHelper.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/8/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit

let Abbreviations = [
    "apartments": "Apts",
    "center": "Ctr",
    "centre": "Ctr",
    "county": "Co",
    "creek": "Crk",
    "crossing": "Xing",
    "downtown": "Dtwn",
    "father": "Fr",
    "fort": "Ft",
    "heights": "Hts",
    "international": "Int’l",
    "junction": "Jct",
    "junior": "Jr",
    "lake": "Lk",
    "market": "Mkt",
    "memorial": "Mem",
    "mount": "Mt",
    "mountain": "Mtn",
    "national": "Nat’l",
    "park": "Pk",
    "point": "Pt",
    "river": "Riv",
    "route": "Rte",
    "saint": "St",
    "saints": "SS",
    "school": "Sch",
    "senior": "Sr",
    "sister": "Sr",
    "square": "Sq",
    "station": "Sta",
    "township": "Twp",
    "university": "Univ",
    "village": "Vil",
    "william": "Wm",
]

let CompassDirections = [
    "E": "east" ,
    "N": "north" ,
    "NE": "northeast" ,
    "NW": "northwest" ,
    "S": "south" ,
    "SE": "southeast" ,
    "SW": "southwest" ,
    "W": "west"
]

let Classifications = [
    "E": "east" ,
    "N": "north" ,
    "NE": "northeast" ,
    "NW": "northwest" ,
    "S": "south" ,
    "SE": "southeast" ,
    "SW": "southwest" ,
    "W": "west",
    "Aly" : "alley",
    "Ave": "avenue",
    "Blvd": "boulevard",
    "Br": "bridge",
    "Byp": "bypass",
    "Cir": "circle",
    "Ct": "court",
    "Cv": "cove",
    "Cres": "crescent",
    "Dr": "drive",
    "Expy": "expressway",
    "Fwy": "freeway",
    "Ftwy": "footway",
    "Hwy": "highway" ,
    "Ln": "lane" ,
    "Mwy": "motorway" ,
    "Pky": "parkway" ,
    "Plz": "plaza" ,
    "Pk": "pike" ,
    "Pt": "point" ,
    "Pl": "place",
    "Rd": "road" ,
    "Sq": "square" ,
    "St": "street" ,
    "Ter": "terrace" ,
    "Tpk": "turnpike" ,
    "Wk": "walk" ,
    "Wky": "walkway"
]

extension String {
    static fileprivate let mappings = [
        "E": "east" ,
        "N": "north" ,
        "NE": "northeast" ,
        "NW": "northwest" ,
        "S": "south" ,
        "SE": "southeast" ,
        "SW": "southwest" ,
        "W": "west",
        "Aly" : "alley",
        "Ave": "avenue",
        "Blvd": "boulevard",
        "Br": "bridge",
        "Byp": "bypass",
        "Cir": "circle",
        "Ct": "court",
        "Cv": "cove",
        "Cres": "crescent",
        "Dr": "drive",
        "Expy": "expressway",
        "Fwy": "freeway",
        "Ftwy": "footway",
        "Hwy": "highway" ,
        "Ln": "lane" ,
        "Mwy": "motorway" ,
        "Pky": "parkway" ,
        "Plz": "plaza" ,
        "Pk": "pike" ,
        "Pt": "point" ,
        "Pl": "place",
        "Rd": "road" ,
        "Sq": "square" ,
        "St": "street" ,
        "Ter": "terrace" ,
        "Tpk": "turnpike" ,
        "Wk": "walk" ,
        "Wky": "walkway"

    ]
    
    func stringByDecodingXMLEntities() -> String {
        
        guard let _ = self.range(of: " ", options: [.literal]) else {
            return self
        }
        
        var result = ""
        
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil
        
        let boundaryCharacterSet = CharacterSet(charactersIn: " \t\n\r;")
        // let boundaryCharacterSet = NSCharacterSet(charactersInString: " \t\r;") &apos;
        
        repeat {
            var nonEntityString: NSString? = nil
            
            if scanner.scanUpTo(" ", into: &nonEntityString) {
                if let s = nonEntityString as? String {
                    result.append(s)
                }
            }
            
            if scanner.isAtEnd {
                break
            }
            
            var didBreak = false
            for (k,v) in String.mappings {
                if scanner.scanString(k, into: nil) {
                    result.append(v)
                    didBreak = true
                    break
                }
            }
            
            if !didBreak {
                
                if scanner.scanString(" ", into: nil) {
                    
                    var gotNumber = false
                    var charCodeUInt: UInt32 = 0
                    var charCodeInt: Int32 = -1
                    var xForHex: NSString? = nil
                    
                    if scanner.scanString("x", into: &xForHex) {
                        gotNumber = scanner.scanHexInt32(&charCodeUInt)
                    }
                    else {
                        gotNumber = scanner.scanInt32(&charCodeInt)
                    }
                    
                    if gotNumber {
                        let newChar = String(format: "%C", (charCodeInt > -1) ? charCodeInt : charCodeUInt)
                        result.append(newChar)
                        scanner.scanString(" ", into: nil)
                    }
                    else {
                        var unknownEntity: NSString? = nil
                        scanner.scanUpToCharacters(from: boundaryCharacterSet, into: &unknownEntity)
                        let h = xForHex ?? ""
                        let u = unknownEntity ?? ""
                        result.append("&#\(h)\(u)")
                    }
                }
                else {
                    scanner.scanString(" ", into: nil)
                    result.append(" ")
                }
            }
            
        } while (!scanner.isAtEnd)
        
        return result
    }
}




/// Options that specify what kinds of words in a string should be abbreviated.
struct StringAbbreviationOptions : OptionSet {
    let rawValue: Int
    
    /// Abbreviates ordinary words that have common abbreviations.
    static let Abbreviations = StringAbbreviationOptions(rawValue: 1 << 0)
    /// Abbreviates directional words.
    static let Directions = StringAbbreviationOptions(rawValue: 1 << 1)
    /// Abbreviates road name suffixes.
    static let Classifications = StringAbbreviationOptions(rawValue: 1 << 2)
}

extension String {
    /// Returns an abbreviated copy of the string.
//    func stringByAbbreviatingWithOptions(options: StringAbbreviationOptions) -> String {
//        return characters.split(" ").map(String.init).map { (word) -> String in
//            let lowercaseWord = word.lowercased()
//            if let abbreviation = Abbreviations[lowercaseWord], options.contains(.Abbreviations) {
//                return abbreviation
//            }
//            if let direction = CompassDirections[lowercaseWord], options.contains(.Directions) {
//                return direction
//            }
//            if let classification = Classifications[lowercaseWord], options.contains(.Classifications) {
//                return classification
//            }
//            return word
//            }.joined(separator: " ")
//    }
    
    /// Returns the string abbreviated only as much as necessary to fit the given width and font.
//    func stringByAbbreviatingToFitWidth(width: CGFloat, font: UIFont) -> String {
//        var fittedString = self
//        if fittedString.size(attributes: [NSFontAttributeName: font]).width <= width {
//            return fittedString
//        }
//        fittedString = fittedString.stringByAbbreviatingWithOptions(options: [.Classifications])
//        if fittedString.size(attributes: [NSFontAttributeName: font]).width <= width {
//            return fittedString
//        }
//        fittedString = fittedString.stringByAbbreviatingWithOptions(options: [.Directions])
//        if fittedString.size(attributes: [NSFontAttributeName: font]).width <= width {
//            return fittedString
//        }
//        return fittedString.stringByAbbreviatingWithOptions(options: [.Abbreviations])
//    }
}
