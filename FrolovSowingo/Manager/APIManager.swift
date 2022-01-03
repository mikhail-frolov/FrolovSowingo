// Name: Mikhail Frolov
// IOS DEV TEST
// APIManager.swift

import Foundation
import UIKit

enum APIError: String, Error {
   
    case invalidURL = "The URL attached to this listing is invalid."

}

class APIManager {
 
    static let shared = APIManager()
    // temporarily store transient key-value pairs
    let cache = NSCache<NSString, UIImage>()
    
    // APPI's
    private let productsURL = "https://demo5514996.mockable.io/products"
    private let favoritesURL = "https://demo5514996.mockable.io/favorites"
  
    private init() {}
    
    func fetchAllProducts() async throws -> [Product] {
    
        guard let url = URL(string: productsURL) else {
        
            throw APIError.invalidURL
        
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        // converts snake-case keys to camel-case keys
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let hits = try decoder.decode(Hits.self, from: data)
        
        return hits.products
        
    }
    
    
    func setFavoriteProduct(selected: Bool) async throws -> Favorite {
       
        guard let url = URL(string: favoritesURL) else {
        
            throw APIError.invalidURL
        
        }
        
        // request
        var req = URLRequest(url: url)
        req.httpMethod = selected ? "DELETE" : "POST"
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let favorite = try JSONDecoder().decode(Favorite.self, from: data)
        
        return favorite
    
    }
    
    
    func downloadImage(from urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
    
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
        
            completionHandler(image)
            
            return
        
        }
        
        guard let url = URL(string: urlString) else {
        
            completionHandler(nil)
            return
        
        }
        
        let imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                   
                    completionHandler(nil)
                    return
            
                }
            
            self.cache.setObject(image, forKey: cacheKey)
            completionHandler(image)
        
        }
        
        imageTask.resume()
    
    }
}
