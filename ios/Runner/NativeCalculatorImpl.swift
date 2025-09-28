//
//  NativeCalculatorImpl.swift
//  Runner
//
//  Created by Sagar Mahobia on 27/09/25.
//

import Foundation
import Flutter

class NativeCalculatorImpl: NativeCalculator {

    func add(a: Int64, b: Int64) throws -> Int64 {
        return a + b
    }

    func addLate(a: Int64, b: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        completion(.success(a + b))
    }

    func subtract(a: Int64, b: Int64) throws -> Int64 {
        return a - b
    }

    func subtractLate(a: Int64, b: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        completion(.success(a - b))
    }

    func multiply(a: Int64, b: Int64) throws -> Int64 {
        return a * b
    }

    func multiplyLate(a: Int64, b: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        completion(.success(a * b))
    }

    func divide(a: Int64, b: Int64) throws -> Int64 {
        guard b != 0 else {
            throw PigeonError(code: "division-by-zero", message: "Cannot divide by zero", details: nil)
        }
        return a / b
    }

    func divideLate(a: Int64, b: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        do {
            let result = try divide(a: a, b: b)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
    
    func setUp(binaryMessenger: FlutterBinaryMessenger) {
        NativeCalculatorSetup.setUp(binaryMessenger: binaryMessenger, api: self)
     }
    
}
