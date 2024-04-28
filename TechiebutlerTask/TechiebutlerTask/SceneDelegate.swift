//
//  SceneDelegate.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    private lazy var baseURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
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
        let remotePostLoader = RemotePostLoader(baseURL: baseURL, client: httpClient)
        
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

