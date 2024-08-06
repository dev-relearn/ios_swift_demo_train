//
//  MockCarriageService.swift
//  TrainTests
//
//  Created by Athira Krishnan on 26.01.24.
//

import Foundation

@testable import DemoTrain

class MockCarriageService: CarriageServiceDelegate{
    func getCarriages(completion: @escaping (Result<[DemoTrain.Carriage], DemoTrain.AppError>) -> Void) {
        guard let url = Bundle.main.url(forResource: "test", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let model = try? JSONDecoder().decode([Carriage].self, from: data) else {
                  return completion(.failure(.DecodingError))
              }
        completion(.success(model))
    }
    
    
    
}
