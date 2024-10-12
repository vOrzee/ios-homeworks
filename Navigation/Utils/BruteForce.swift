//
//  BruteForce.swift
//  Navigation
//
//  Created by Роман Лешин on 11.10.2024.
//
import Foundation
import UIKit

class BruteForce {
    static let shared: BruteForce = BruteForce()
    
    private init() {}
    
    public func generateBruteForce(
        _ string: String = "",
        fromArray array: [String] = String().printable.map{String($0)}
    ) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
    
    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }
    
    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }
}
