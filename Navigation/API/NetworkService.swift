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
}
