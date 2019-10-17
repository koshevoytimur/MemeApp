//
//  ViewController.swift
//  MemeApp
//
//  Created by Тимур Кошевой on 10/11/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: RootViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var likeDislikeImageView: UIImageView!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    let networkManager = NetworkManager()
    
    let image_placeholder = "image_placeholder.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOutlets()
        resetCard()
        showMeme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func resetCard() {
        self.cardView.center = self.view.center
        UIView.animate(withDuration: 0.4) {
            self.cardView.alpha = 1
        }
        self.likeDislikeImageView.alpha = 0
    }
    
    func clearCard() {
        self.label.text = ""
        self.imageView.image = UIImage()
    }
    
    func showMeme() {
        showSpinner(onView: view)
        networkManager.getRandomMeme(urlString: URL_RANDOM_MEME) { (meme, error) in
            if let meme = meme {
                DispatchQueue.global().async { [weak self] in
                    let url = URL(string: meme.url)
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imageView.image = image
                                self?.label.text = meme.title
                            }
                        }
                    }
                    self!.removeSpinner()
                }
            } else {
                self.removeSpinner()
                self.label.text = error!
            }
        }
    }
    
    func setUpOutlets() {
        label.text = ""
        
        cardView.layer.cornerRadius = 16
        self.cardView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        buttonOutlet.backgroundColor = UIColor.clear
        buttonOutlet.layer.borderColor = UIColor.systemRed.cgColor
        buttonOutlet.layer.borderWidth = 1
        buttonOutlet.layer.cornerRadius = 16
        buttonOutlet.setTitleColor(.systemRed, for: .normal)
        buttonOutlet.setTitleColor(.systemRed, for: .highlighted)
        buttonOutlet.titleLabel?.text = "NEXT MEME"
    }
    
    @IBAction func onButtonAction() {
        showMeme()
    }
    
    @IBAction func cardPan(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        if xFromCenter > 0 {
            likeDislikeImageView.image = UIImage(named: "like")
            likeDislikeImageView.tintColor = .systemGreen
        } else {
            likeDislikeImageView.image = UIImage(named: "dislike")
            likeDislikeImageView.tintColor = .systemRed
        }
        
        likeDislikeImageView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 100 {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y)
                    card.alpha = 0
                }) { (done) in
                    if done {
                        self.clearCard()
                        self.resetCard()
                        self.showMeme()
                    }
                }
                return
            } else if card.center.x > (view.frame.width - 100) {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y)
                    card.alpha = 0
                }) { (done) in
                    if done {
                        self.clearCard()
                        self.resetCard()
                        self.showMeme()
                    }
                }
                return
            }
            
            UIView.animate(withDuration: 0.2) {
                self.resetCard()
            }
        }
    }
    
}
