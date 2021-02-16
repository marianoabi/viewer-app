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
}

class MainPresenter {
    private var view: MainPresenterView?
    private var picsumProvider: BaseMoyaProvider<PicsumService>?
    
    init(_ view: MainPresenterView, picsumProvider: BaseMoyaProvider<PicsumService>) {
        self.view = view
        self.picsumProvider = picsumProvider
    }
    
}

extension MainPresenter {
    func getImageList(limit: Int) {
        self.picsumProvider?.request(.getImageList(limit: limit), completion: { (result) in
            
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
            }
        })
    }
}
