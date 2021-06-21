//
//  Service.swift
//  InterviewPrep
//
//  Created by Raghu, Reshma L on 21/06/21.
//

import UIKit

class Service {
    let endpoint = "https://images-api.nasa.gov/search"
    
    static var sharedInstance = Service()
    private init(){}
    
    func fetchImages(for keyWordSearch: String, completionHandler: @escaping ([ImageModel]) -> Void) {
        
        let queryItems = [URLQueryItem(name: "q", value: "\(keyWordSearch)"),
                          URLQueryItem(name: "media_type", value: "image")]
        var urlComponents = URLComponents(string: endpoint)
        urlComponents?.queryItems = queryItems
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
              if let error = error {
                print("Error with fetching images: \(error)")
                return
              }
              
              guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
              }
              print("❇️ \(String(describing: data))");
              if let data = data,
                let response = try? JSONDecoder().decode(Response.self, from: data) {
                completionHandler(response.collection.items)
              }
            })
            task.resume()
        } else {
            return
        }
        
    }
}
