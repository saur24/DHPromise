//
//  Result.swift
//  DHPromise-iOS
//
//  Created by David Harris on 4/20/18.
//  Copyright © 2018 thedavidharris. All rights reserved.
//

import Foundation

/// Enum to wrap a successful Value or an error of Error type
///
/// - success: success type with associated value
/// - failure: error type with associated Error value
public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

// MARK: Convenience Accessors

extension Result {

    /// Convenience accessor for value
    public var value: Value? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }

    /// Convenience accessor for error
    public var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}

// MARK: Throwable Conversion

extension Result {
    /// Constructs a Result enum from a function that `throws`
    ///
    /// - Parameter throwing: closure that returns a Value type or `throws`
    public init(_ throwing: () throws -> Value) {
        do {
            self = .success(try throwing())
        } catch {
            self = .failure(error)
        }
    }

    /// Unwraps a result enum and throws an error in the failure case
    ///
    /// - Returns: Result value if success
    /// - Throws: Result error if failure
    public func unwrap() throws -> Value {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}

// MARK: Monadic

extension Result {

    /// Chains result enums
    ///
    /// - Parameter transform: closure used to generate a new Result
    /// - Returns: New Result enum
    public func flatMap<U>(_ transform: (Value) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let value): return transform(value)
        case .failure(let error): return .failure(error)
        }
    }


    /// Transforms Result type into another Result type
    ///
    /// - Parameter transform: closure to transform the Result
    /// - Returns: New Result type enum
    public func map<U>(_ transform: (Value) throws -> U) -> Result<U> {
        switch self {
        case .success(let value): return Result<U> { try transform(value) }
        case .failure(let error): return .failure(error)
        }
    }
}
