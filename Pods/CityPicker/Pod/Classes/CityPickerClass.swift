//
//  CityPickerClass.swift
//  Noemi Official
//
//  Created by LIVECT LAB on 13/03/2016.
//  Copyright © 2016 LIVECT LAB. All rights reserved.
//

import UIKit


class cityPickerClass {
    
    
    
    class func getNations() -> (nations:[String], allValues:NSDictionary){
        
        
        var nations = [String]()
        var allValues = NSDictionary()
        let podBundle = Bundle(for: self)
        
        if let path = podBundle.path(forResource: "countriesToCities", ofType: "json") {
            
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    let nationsArray = jsonResult.allKeys as! [String]
                    let sortedNations = nationsArray.sorted {  $0 < $1 }
                    
                    nations = sortedNations
                    
                    allValues = jsonResult
                    
                } catch {}
            } catch {}
        }
        
        
        return (nations, allValues)
    }
    
    
    
    
    
}
