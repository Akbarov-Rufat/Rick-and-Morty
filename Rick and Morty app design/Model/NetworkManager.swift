//
//  NetworkManager.swift
//  Rick and Morty app design
//
//  Created by Rufat  on 25.05.24.
//

import Foundation
import UIKit
protocol DidFetchData : AnyObject{
    func showError(message: String)
}
struct NetworkManager {
    weak var delegate : DidFetchData?
    static var shared = NetworkManager()
    var pageNum = 1
    private var baseURL = "https://rickandmortyapi.com/api/character/?page="
    func fetchData( queryText: String ,completion :  @escaping (Results) -> Void) {
        guard let url = URL(string: baseURL + String(pageNum) + queryText) else{return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    delegate?.showError(message: "Server error. Please try again later.")
                    return
                }
            }
            guard let safeData = data else{return}
            do {
                let items = try JSONDecoder().decode(Results.self, from: safeData)
                completion(items)
            } catch {
                print(error)
            }
        }.resume()
    }
    func fetchImage(url : String, into myImageView : UIImageView) {
        guard let safeURL = URL(string: url ) else{return}
        URLSession.shared.dataTask(with: safeURL) { data,response,error in
            guard error == nil  else {return}
            guard let safeData = data else{return}
            if let image = UIImage(data: safeData) {
                DispatchQueue.main.async {
                    myImageView.image = image
                }
            }
        }.resume()
    }
    
    private init(){}
}
