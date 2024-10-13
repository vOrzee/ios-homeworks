//
//  NetworkService.swift
//  Navigation
//
//  Created by Роман Лешин on 12.10.2024.
//
import Foundation
import UIKit

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        guard let url = URL(string: configuration.rawValue) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data, let response = response as? HTTPURLResponse else {return}
            print("Вывод результата для \"a. data — в доступном для понимания виде, то есть String в стандартной кодировке\":")
            let outputString = String(data: data, encoding: .utf8) ?? "Получить строку не удалось"
            print(outputString)
            print("Вывод результата для \"b. свойство .allHeaderFields и .statusCode у response\":")
            print("response.allHeaderFields: \(response.allHeaderFields)")
            print("response.statusCode: \(response.statusCode)")
        }.resume()
    }
    
    static func getToDoTask(withId id: Int, completion: @escaping (Result<TodoTask, AppError>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/todos/\(id)"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(.networkUnavailable("Сеть недоступна")))
                    print(error.localizedDescription)
                    return
                }
                guard let data else {
                    completion(.failure(.dataNotFound))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.networkUnavailable("Некорректный тип ответа")))
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
    
    static func getTatooinePlanetInfo(completion: @escaping (Result<PlanetModel, AppError>) -> Void) {
        let urlString = "https://swapi.dev/api/planets/1"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(.networkUnavailable("Сеть недоступна")))
                    print(error.localizedDescription)
                    return
                }
                guard let data else {
                    completion(.failure(.dataNotFound))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.networkUnavailable("Некорректный тип ответа")))
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
