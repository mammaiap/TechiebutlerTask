//
//  LoadPostFromRemoteUseCaseTests.swift
//  TechiebutlerTaskTests
//
//  Created by Muthulingam on 28/04/24
//

import XCTest
@testable import TechiebutlerTask

final class LoadPostFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromRemote() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromRemote() {
        
        let request = makePagedPostRequest(pagedStart: 0)
        
        let expectedURL = makeURL("https://jsonplaceholder.typicode.com/posts?_start=\(request.start)&_limit=\(request.limit)")
        
        let baseURL = makeURL("https://jsonplaceholder.typicode.com/posts")
        
        let (sut, client) = makeSUT(baseURL: baseURL)
        sut.load(request) { _ in }

        XCTAssertEqual(client.requestedURLs, [expectedURL])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        
        let request = makePagedPostRequest(pagedStart: 0)
        let expectedURL = makeURL("https://jsonplaceholder.typicode.com/posts?_start=\(request.start)&_limit=\(request.limit)")
        
        let baseURL = makeURL("https://jsonplaceholder.typicode.com/posts")
        let (sut, client) = makeSUT(baseURL: baseURL)

        sut.load(request) { _ in }
        sut.load(request) { _ in }

        XCTAssertEqual(client.requestedURLs, [expectedURL, expectedURL])
    }
    
    func test_load_deliversErrorOnClientError() {
        
        let (sut, client) = makeSUT()
        
        expect(sut,toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
        
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        
        let (sut, client) = makeSUT()
        
       let samples = [199,201,300,400,500]
        
        samples.enumerated().forEach{ index, code in
            
            expect(sut,toCompleteWith: failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
            
        }
        
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        
        let (sut, client) = makeSUT()
        
        expect(sut,toCompleteWith: failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)            
            client.complete(withStatusCode: 200, data:invalidJSON)
        }
        
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut,toCompleteWith: .success([])) {
            
            let emptyListJSON = makeItemsJSON([])
            
            client.complete(withStatusCode: 200, data:emptyListJSON)
        }
        
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(userId: 1, id: 1, title: "a title", body: "a body")
        
        let item2 = makeItem(userId: 2, id: 2, title: "another title", body: "another body")
        
        
        let items = [item1.model, item2.model]
        
        expect(sut,toCompleteWith: .success(items)) {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
        
    }
    
    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: PostLoader? = RemotePostLoader(baseURL: makeURL(), client: client)
        var output: Any? = nil
        sut?.load(.init(start: 0), completion: { output = $0 })
        sut = nil

        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        XCTAssertNil(output)        
        
    }
     
    
    // MARK: - Helpers
    
    private func makeSUT(baseURL: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemotePostLoader,client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePostLoader(baseURL: baseURL,client: client)
        trackMemoryLeaks(sut,file: file,line: line)
        trackMemoryLeaks(client,file: file,line: line)
        return (sut,client)
        
    }    
    
    private func failure(_ error: RemotePostLoader.Error) -> RemotePostLoader.Result {
        return .failure(error)
        
    }
    
    private func makeItem(userId: Int, id: Int, title: String, body: String) -> (model: Post, json: [String: Any]) {
        
        let item = Post(userId: userId, id: id, title: title, body: body)
        
        let json = [
            "userId": item.userId,
            "id": item.id,
            "title": item.title,
            "body": item.body
        
        ].compactMapValues{ $0 }
        
        return (item,json)
        
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        
        let data = try! JSONSerialization.data(withJSONObject: items)
        return data
        
    }
    
    private func expect(_ sut: RemotePostLoader, toCompleteWith expectedResult: RemotePostLoader.Result, when action: ()-> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "wait for load completion")
        let req = makePagedPostRequest(pagedStart: 0)
        sut.load(req){receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemotePostLoader.Error), .failure(expectedError as RemotePostLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead",file: file, line: line)
            }
            
            exp.fulfill()
            
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makePagedPostRequest(pagedStart: Int = 0) -> PagedPostRequest {
        return PagedPostRequest(start: pagedStart)
    }

}
