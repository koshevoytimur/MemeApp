//
//  ViewController.swift
//  MemeApp
//
//  Created by Тимур Кошевой on 10/11/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: RootViewController, PresenterDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var likeDislikeImageView: UIImageView!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    lazy var presenter = Presenter(with: self)
    let networkManager = NetworkManager()
    
    let image_placeholder = "image_placeholder.png"
    var startLocation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOutlets()
        resetCard()
        presenter.showMeme()
        
        startLocation = view.center
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
        self.cardView.transform = .identity
    }
    
    func clearCard() {
        self.label.text = ""
        self.imageView.image = UIImage()
    }
    
    func updateView(memeImg: UIImage?, message: String) {
        
        if let image = memeImg {
            self.imageView.image = image
            self.label.text = message
        } else {
            self.label.text = message
        }
    }
    
    func setUpOutlets() {
        label.text = ""
        
        cardView.layer.cornerRadius = 16
        cardView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        buttonOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        buttonOutlet.layer.borderColor = UIColor.systemRed.cgColor
        buttonOutlet.layer.borderWidth = 1
        buttonOutlet.layer.cornerRadius = 16
        buttonOutlet.setTitleColor(.systemRed, for: .normal)
        buttonOutlet.setTitleColor(.systemRed, for: .highlighted)
        buttonOutlet.titleLabel?.text = "NEXT MEME"
    }
    
    @IBAction func onButtonAction() {
        presenter.showMeme()
    }
    
    @IBAction func cardPan(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        let yFromBottom = view.frame.height - card.center.y
        let scale = min(100/abs(xFromCenter), 1)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: atan(xFromCenter / yFromBottom)).scaledBy(x: scale, y: scale)
        
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
                UIView.animate(withDuration: 0.4, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y - 100)
                    card.alpha = 0
                    
                    let stopLocation = sender.location(in: self.view)
                    
                    
                    print("view.center")
                    print(self.view.center)
                    
                    print("stopLocation")
                    print(stopLocation)
                    
                }) { (done) in
                    if done {
                        self.clearCard()
                        self.resetCard()
                        self.presenter.showMeme()
                    }
                }
                return
            } else if card.center.x > (view.frame.width - 100) {
                UIView.animate(withDuration: 0.4, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y - 100)
                    card.alpha = 0
                    
                    let stopLocation = sender.location(in: self.view)
                    
                    print("view.center")
                    print(self.view.center)
                    
                    print("stopLocation")
                    print(stopLocation)
                    
                }) { (done) in
                    if done {
                        self.clearCard()
                        self.resetCard()
                        self.presenter.showMeme()
                    }
                }
                return
            } else if card.center.y > 200 {
                
            }
            
            UIView.animate(withDuration: 0.2) {
                self.resetCard()
            }
        }
    }
    
}

/// 1
//        let velocity = sender.velocity(in: self.view)
//        let xVelocity = velocity.x
//        let yVelocity = velocity.y
//
//        var angle = atan2(yVelocity, xVelocity) * 180.0 / 3.14159
//
//        if angle < 0 {
//            angle += angle + 360.0
//        }
//
//        print(angle)

/// 2
//                    let x = stopLocation.x - self.view.center.x
//                    let y = stopLocation.y - self.view.center.y
//                    let x = self.view.center.x - stopLocation.x
//                    let y = self.view.center.y - stopLocation.y

//                    card.center = CGPoint(x: card.center.x * x, y: card.center.y * y)

//                    let dx = stopLocation.x - self.startLocation.x
//                    let dy = stopLocation.y - self.startLocation.y
//
//                    var angle = atan2(dy, dx) * 180.0 / 3.14159
//
//                    if angle < 0 {
//                        angle += 360.0
//                    }

//                    let velocity = sender.velocity(in: self.view)
//                    let xVelocity = velocity.x
//                    let yVelocity = velocity.y
//
//                    var angle = atan2(yVelocity, xVelocity) * 180.0 / 3.14159
//
//                    if angle < 0 {
//                        angle += angle + 360.0
//                    }

//                    let x = 200 * cos(angle)
//                    let y = 200 * sin(angle)
//                    card.center = CGPoint(x: card.center.x * x, y: card.center.y * y)
//
//                    print(angle)
