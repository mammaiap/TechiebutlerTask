//
//  SceneDelegate.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import UIKit
import os

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    private lazy var baseURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    private lazy var logger = Logger(subsystem: "com.muvee.TechiebutlerTask", category: "main")
    
    private lazy var httpClient: HTTPClient = {
            URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        }()
    
    private lazy var navigationController = UINavigationController(rootViewController: makeAndShowPostListScene())
    
    convenience init(httpClient: HTTPClient) {
            self.init()
            self.httpClient = httpClient
        }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        configureWindow()
    }
    
    func configureWindow(){
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func makeAndShowPostListScene() -> PostListViewController {
        let remotePostLoader = RemotePostLoader(baseURL: baseURL, client: HTTPClientProfilingDecorator(decoratee: httpClient, logger: logger))
        
        let postListViewController = PostUIComposer.postComposedWith(postLoader: remotePostLoader,onSelection: showPostDetailScene)
        
        return postListViewController
        
    }

    private func showPostDetailScene(for model: Post) {       
        
        let detailController = PostDetailUIComposer.postDetailComposedWith(model: model)
        
        DispatchQueue.main.async{
            self.navigationController.pushViewController(detailController, animated: true)
        }
    }

}

private class HTTPClientProfilingDecorator: HTTPClient{
    private let decoratee: HTTPClient
    private let logger: Logger
    
    init(decoratee: HTTPClient, logger: Logger) {
        self.decoratee = decoratee
        self.logger = logger
    }
    
    func get(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        logger.trace("Started loading URLRequest:\(request)")
        let startTime = CACurrentMediaTime()
        return decoratee.get(request) { [logger] result in
            if case let .failure(error) = result{
                logger.trace("failed to load URLRequest: \(request) with error:\(error.localizedDescription)")
            }
                
            let finishedTime = CACurrentMediaTime()
            let elapsed = finishedTime - startTime
            logger.trace("Finished loading URLRequest:\(request) in \(elapsed) seconds")
            completion(result)
        }
    }
}
