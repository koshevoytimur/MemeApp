//
//  NetworkManager.swift
//  MemeApp
//
//  Created by Тимур Кошевой on 10/11/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import Foundation
import Alamofire

let URL_RANDOM_MEME = "https://meme-api.herokuapp.com/gimme"

class NetworkManager {
    
    func getRandomMeme(urlString: String, completion: @escaping (_ meme: Meme?, _ error: String?) -> Void) {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.method = HTTPMethod.get
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        AF.request(request).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                        let meme: Meme = try! JSONDecoder().decode(Meme.self, from: data)
                        completion(meme, nil)
                }
            case let .failure(error):
                completion(nil, "\(error.localizedDescription)")
            }
        }
        
    }
    
}
