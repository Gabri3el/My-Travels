//
//  StorageData.swift
//  My Travels
//
//  Created by Gabriel on 26/08/21.
//

import UIKit

class StorageData {
    let keyStorage = "LocalTravel"
    var travels: [Dictionary<String,String>] = []
    
   
    
    func Save(travel: Dictionary<String,String> ){
        travels = getData()
        travels.append(travel)
        UserDefaults.standard.set(travels, forKey: keyStorage)
        UserDefaults.standard.synchronize()
        
    }
    
    func getData()-> [Dictionary<String,String>]{
        let data = UserDefaults.standard.object(forKey: keyStorage)
        if data != nil{
            print(data!)
            return data as! [Dictionary<String, String>]
        }else{
            return []
        }
    }
    
    func Remove(indice: Int){
        travels = getData()
        travels.remove(at: indice)
        UserDefaults.standard.set(travels, forKey: keyStorage)
        UserDefaults.standard.synchronize()
        
    }
}
