//
//  SharedTestHelpers.swift
//  TechiebutlerTaskTests
//
//  Created by Muthulingam on 28/04/24
//

import Foundation

func anyNSError() -> NSError {
     return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyURLRequest() -> URLRequest {
    return URLRequest(url: URL(string: "http://any-url.com")!)
}

func makeURL(_ string: String = "https://some-given-url.com", file: StaticString = #file, line: UInt = #line) -> URL {
  guard let url = URL(string: string) else {
    preconditionFailure("Could not create URL for \(string)", file: file, line: line)
  }
  return url
}
