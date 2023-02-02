//
//  Publisher+Async.swift
//  KICommon
//
//  Created by kang1131 on 2023/01/11.
//

import Combine

@available(iOS 14.0, *)
public extension Publisher {
    func asyncMap<T>(_ transform: @escaping (Output) async throws -> T) -> Publishers.FlatMap<Future<T, Error>, Publishers.SetFailureType<Self, Error>> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}
