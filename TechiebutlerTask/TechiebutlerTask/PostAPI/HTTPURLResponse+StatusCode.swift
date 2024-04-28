//
//  HTTPURLResponse+StatusCode.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
