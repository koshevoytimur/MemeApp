//
//  Presenter.swift
//  MemeApp
//
//  Created by Тимур Кошевой on 23.10.2019.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit

protocol PresenterDelegate: class {
    func updateView(memeImg: UIImage?, message: String)
    func showSpinner()
    func removeSpinner()
}

class Presenter {
    
    weak var delegate: PresenterDelegate?
    let networkManager = NetworkManager()
    let imageCache = NSCache<NSString, UIImage>()
    
    init(with delegate: PresenterDelegate) {
        self.delegate = delegate
    }

    func showMeme() {
        self.delegate?.showSpinner()
        networkManager.getRandomMeme(urlString: URL_RANDOM_MEME) { (meme, error) in
            if let meme = meme {
                DispatchQueue.global().async { [weak self] in
                    let url = URL(string: meme.url)
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.delegate?.updateView(memeImg: image, message: meme.title)
                                self?.delegate?.removeSpinner()
                            }
                        }
                    }
                }
            } else {
                self.delegate?.updateView(memeImg: nil, message: error!)
                self.delegate?.removeSpinner()
            }
        }
    }
    
}

