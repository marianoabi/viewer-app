//
//  MainPresenter.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import Moya_ObjectMapper

protocol MainPresenterView {
    func successGetImageList(_ presenter: MainPresenter, list: [Image])
    func onError(_ presenter: MainPresenter, error: String)
    func showLoadingView(_ presenter: MainPresenter)
    func removeLoadingView(_ presenter: MainPresenter)
}

class MainPresenter {
    private var view: MainPresenterView?
    private var picsumProvider: BaseMoyaProvider<PicsumService>?
    private var delegate: MainViewController?
    
    init(_ view: MainPresenterView, picsumProvider: BaseMoyaProvider<PicsumService>) {
        self.view = view
        self.picsumProvider = picsumProvider
    }
    
}

extension MainPresenter {
    func getImageList(limit: Int) {
        self.view?.showLoadingView(self)
        self.picsumProvider?.request(.getImageList(limit: limit), completion: { (result) in
            self.view?.removeLoadingView(self)
            switch result {
            case let .success(response):
                do {
                    let imageList = try response.mapArray(Image.self)
                    self.view?.successGetImageList(self, list: imageList)
                    
                } catch {
                    self.view?.onError(self, error: "An error ocurred while mapping JSON.")
                }
                
            case let .failure(error):
                self.view?.onError(self, error: error.localizedDescription)
                self.view?.removeLoadingView(self)
            }
        })
    }
    
    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error fetching image")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
        
        dataTask.resume()
    }
}
