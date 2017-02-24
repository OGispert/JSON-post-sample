//
//  Input.swift
//  jsonCodeSample
//
//  Created by Othmar Gispert on 2/1/17.
//  Copyright © 2017 Othmar Gispert. All rights reserved.
//

import Foundation

class Input {
    
    func jsonPost(_ un:String, _ ul:String, _ ud:String, _ uz:String) {
        
        let json: [String: Any] = ["Name": un,
                                   "LastName": ul,
                                   "DOB": ud,
                                   "ZipCode": uz]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: BIN_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
        
    }
}
