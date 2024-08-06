//
//  DataHandler.swift
//  Train
//
//  Created by Athira Krishnan on 26.01.24.
//

import Foundation

class DataHandler: CarriageDelegate {
   
    
    
    func getCarriages(completion: @escaping(Result<[Carriage], AppError>) -> Void){
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let model = try? JSONDecoder().decode([Carriage].self, from: data) else {
                  return completion(.failure(.DecodingError))
              }
        completion(.success(model))
    }
    
   
    
}
