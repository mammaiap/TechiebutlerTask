//
//  XCTestCase+MemoryLeakTracking.swift
//  TechiebutlerTaskTests
//
//  Created by Muthulingam on 28/04/24
//

import Foundation
import XCTest

extension XCTestCase {
    
    func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated.Potential memory leak.", file: file,line: line)
        }
        
    }
}
