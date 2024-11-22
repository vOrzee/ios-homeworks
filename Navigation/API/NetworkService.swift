//
//  NetworkService.swift
//  Navigation
//
//  Created by Роман Лешин on 12.10.2024.
//
import Foundation
import UIKit

struct NetworkService {
    
    static func getToDoTask(withId id: Int, completion: @escaping (Result<TodoTask, AppError>) -> Void) async {
        let urlString = "https://jsonplaceholder.typicode.com/todos/\(id)"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(.networkUnavailable(NSLocalizedString("Network unavailable", comment: ""))))
                    print(error.localizedDescription)
                    return
                }
                guard let data else {
                    completion(.failure(.dataNotFound))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.networkUnavailable(NSLocalizedString("Invalid response type", comment: ""))))
                    return
                }
                if !(200..<300).contains(response.statusCode) {
                    completion(.failure(.networkUnavailable("\(response.statusCode)")))
                    return
                }
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data)
                    guard let jsonObj = jsonObj as? [String : Any],
                          let id = jsonObj["id"] as? Int,
                          let userId = jsonObj["userId"] as? Int,
                          let title = jsonObj["title"] as? String,
                          let completed = jsonObj["completed"] as? Bool
                    else {
                        completion(.failure(.dataNotFound))
                        return
                    }
                    completion(.success(TodoTask(userId: userId, id: id, title: title, completed: completed)))
                } catch {
                    completion(.failure(.dataNotFound))
                }
            }
        }.resume()
    }
    
    static func getTatooinePlanetInfo(completion: @escaping (Result<PlanetModel, AppError>) -> Void) async {
        let urlString = "https://swapi.dev/api/planets/1"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(.networkUnavailable(NSLocalizedString("Network unavailable", comment: ""))))
                    print(error.localizedDescription)
                    return
                }
                guard let data else {
                    completion(.failure(.dataNotFound))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.networkUnavailable(NSLocalizedString("Invalid response type", comment: ""))))
                    return
                }
                if !(200..<300).contains(response.statusCode) {
                    completion(.failure(.networkUnavailable("\(response.statusCode)")))
                    return
                }
                do {
                    let tatooine = try JSONDecoder().decode(PlanetModel.self, from: data)
                    completion(.success(tatooine))
                } catch {
                    completion(.failure(.dataNotFound))
                }
            }
        }.resume()
    }
}
