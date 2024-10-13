//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Роман Лешин on 12.10.2024.
//

import Foundation

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people"
    case starships = "https://swapi.dev/api/starships"
    case planets = "https://swapi.dev/api/planets"
    
    var url: URL? {
        URL(string: self.rawValue)
    }
}
