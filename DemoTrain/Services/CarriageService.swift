//
//  CarriageService.swift
//  Train
//
//  Created by Athira Krishnan on 26.01.24.
//

import Foundation
enum AppError: Error {
    case BadURL
    case NoData
    case DecodingError
}

protocol CarriageServiceDelegate: CarriageDelegate  {
    
}

protocol CarriageDelegate {
    func getCarriages(completion: @escaping(Result<[Carriage], AppError>) -> Void)
}



class CarriageService: CarriageServiceDelegate  {
    
    func getCarriages(completion: @escaping(Result<[Carriage], AppError>) -> Void) {
        
        return completion(.failure(.NoData))

    }
}
