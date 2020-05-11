//
//  RequestData.swift
//  Marvel_Battle
//
//  Created by MAC on 11/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import Foundation


enum Type:String {
    case GET
    case POST
    case PUT
    case DELETE
}

class RequestData{
    
    func networkRequest<T: Decodable>(MethodType:Type, url:String, codableType: T.Type, onComplete: @escaping (_ response: Characters) -> Void) {
        guard let getUrl = URL(string: url) else {return}
        if MethodType == Type.GET{
            URLSession.shared.dataTask(with: getUrl) { (data, response, err) in
                if let urlRes = response as? HTTPURLResponse{
                    if 200...300 ~= urlRes.statusCode {
                        guard let data = data else {return}
                        do {
                            let model = try JSONDecoder().decode(T.self, from: data)
                            onComplete(model as! Characters)
                        }
                        catch let jsonErr {
                            print("Error Occured :"+jsonErr.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
    }
    
}
