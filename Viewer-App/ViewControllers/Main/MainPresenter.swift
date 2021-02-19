//
//  MainPresenter.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

//import Moya_ObjectMapper
import Foundation

// MARK: - Protocol
protocol MainPresenterView {
    func showLoadingView()
    func removeLoadingView()
    
    func successGetImageList(_ presenter: MainPresenter, list: [Image])
    func onError(_ presenter: MainPresenter, error: String)
}

// MARK: - Properties/Overrides
class MainPresenter {
    private var view: MainPresenterView?
    private var delegate: MainViewController?
    
    init(_ view: MainPresenterView) {
        self.view = view
    }
    
}

// MARK: - API Calls
extension MainPresenter {
    func getImageList(limit: Int) {
        
        let urlString = "\(CoreService.picsumBaseURLString)/list?limit=\(limit)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
                
        let session = URLSession.shared
        self.view?.showLoadingView()
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.view?.removeLoadingView()
                
                if error != nil {
                    DispatchQueue.main.async {
                        self.view?.onError(self, error: error?.localizedDescription ?? ViewerApp.ErrorMessages.byDefault)
                    }
                } else {
                    
                    do {
                        let decoder = JSONDecoder()
                        let images = try decoder.decode([Image].self, from: data!)
                        
                        DispatchQueue.main.async {
                            self.view?.successGetImageList(self, list: images)
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            self.view?.onError(self, error: ViewerApp.ErrorMessages.decodeDataError)

                        }
                    }
                }
            }
        }
        
        dataTask.resume()
    }
}
