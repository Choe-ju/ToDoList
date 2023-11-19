//
//  loadJson.swift
//  TodoList
//
//  Created by 최주원 on 11/7/23.
//

import Foundation

func loadJson<T: Decodable>(_ filename: String) -> T {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("\(filename) not found")
    }
    
    do {
        let data = try Data(contentsOf: file)
        return try JSONDecoder().decode(T.self, from: data)
    }catch {
        fatalError("Could not load \(filename): \(error)")
    }
}
