//
//  NetworkManager.swift
//  WheatherApp
//
//  Created by Neha Gupta on 06/05/21.
//

import Foundation

final class NetworkManager<T: Codable>{
    
    static func fetch(for url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let objReach:Reachability = Reachability()
        if objReach.isConnectedToNetwork() == false {
            completion(.failure(.noInternetconnection(err: "No Internet Connection")))
            return
        }
        URLSession.shared.dataTask(with: url) { (data,response, error) in
            guard error == nil else {
                print(String(describing: error))
                completion(.failure(.error(err: error!.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(.success(json))
            }catch let err {
                print((String.init(describing: err.localizedDescription)))
                completion(.failure(.DecoadingError(err: err.localizedDescription)))
            }
        }.resume()
    }
    
    
}

enum NetworkError: Error{
 
    case invalidResponse
    case invalidData
    case error(err: String)
    case DecoadingError(err: String)
    case noInternetconnection(err: String)
}
