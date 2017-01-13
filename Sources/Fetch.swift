//
// Fetch.swift
//
// Copyright (c) 2017 Marko Tadić <tadija@me.com> http://tadija.net
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

public typealias ThrowDataWithInnerBlock = (() throws -> Data) -> Void
public typealias ThrowDictionaryWithInnerBlock = (() throws -> [AnyHashable : Any]) -> Void
public typealias ThrowArrayWithInnerBlock = (() throws -> [Any]) -> Void

public extension Network {
    
    // MARK: - API
    
    public func fetchData(with request: URLRequest, completion: @escaping ThrowDataWithInnerBlock) {
        
        if let cachedResponse = getCachedResponse(for: request) {
            completion {
                return cachedResponse.data
            }
        } else {
            sendRequest(request, completion: completion)
        }
        
    }
    
    public func fetchDictionary(with request: URLRequest, completion: @escaping ThrowDictionaryWithInnerBlock) {
        fetchData(with: request) { (data) -> Void in
            do {
                let data = try data()
                let dict = try self.parseDictionary(from: data)
                completion {
                    return dict
                }
            } catch {
                completion {
                    throw error
                }
            }
        }
    }
    
    public func fetchArray(with request: URLRequest, completion: @escaping ThrowArrayWithInnerBlock) {
        fetchData(with: request) { (response) -> Void in
            do {
                let data = try response()
                let array = try self.parseArray(from: data)
                completion {
                    return array
                }
            } catch {
                completion {
                    throw error
                }
            }
        }
    }
    
}