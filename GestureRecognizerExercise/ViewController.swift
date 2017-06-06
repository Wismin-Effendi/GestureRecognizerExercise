//
//  ViewController.swift
//  GestureRecognizerExercise
//
//  Created by Wismin Effendi on 6/6/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Gesture: String {
        case tapGesture = "Tap Gesture"
        case pinchGesture = "Pinch Gesture"
        case panGesture = "Pan Gesture"
        case screenEdgePanGesture = "Screen Edge Pan Gesture"
        case rotationGesture = "Rotation Gesture"
        case swipeUpGesture = "Swipe Up Gesture"
        case swipeDownGesture = "Swipe Down Gesture"
        case longPressGesture = "Long Press Gesture"
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gestureLabel: UILabel!
    
    var imageFilename: String? {
        didSet {
            if let imageFilename = imageFilename {
                imageView.image = UIImage(named: imageFilename)
            }
        }
    }
    
    var tapCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNewImage(for: "car")
        setGestureText(for: nil)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp(_:)))
        swipeUpGesture.direction = .up

        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeDownGesture.direction = .down
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        
        let screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan(_:)))
        screenEdgePanGesture.edges = .right
        
        
        imageView.isUserInteractionEnabled = true
        imageView.gestureRecognizers = [panGesture, tapGesture, rotateGesture, pinchGesture, longPressGesture]
        
        // swipe up and swipe down + screen edge are to be added to the root View
        view.gestureRecognizers = [swipeUpGesture, swipeDownGesture, screenEdgePanGesture]
    }

    // helper 
    private func setNewImage(for basename: String) {
        let idx = arc4random_uniform(10)
        let imageFileName = basename + "0\(idx).jpg"
        print(imageFileName)
        self.imageFilename = imageFileName
    }
    
    private func setGestureText(for gesture: Gesture?) {
        if let gesture = gesture{
            gestureLabel.text = "\(gesture.rawValue) detected"
        } else {
            gestureLabel.text = ""
        }
    }
    
    
    // Gesture handler
    func handleTap(_ sender: UITapGestureRecognizer) {
        tapCounter += 1
        
        // reset to initial size & no roation
        if let view = sender.view {
            view.transform = CGAffineTransform.identity
        }
        // change to different train / car / motorcycle 
        let tapVehicleType = ["car", "motorcycle", "train"]
        let choosenVehicleType = tapVehicleType[tapCounter % 3]
        setNewImage(for: choosenVehicleType)
        setGestureText(for:.tapGesture)
    }
    
    func handlePinch(_ sender: UIPinchGestureRecognizer) {
        // zoom in / out
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
        setGestureText(for: .pinchGesture)
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        // move the image
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        setGestureText(for: .panGesture)
    }
    
    func handleScreenEdgePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        // change opacity of the background
        let alpha = sender.location(in: view).x / view.bounds.width
        view.alpha = alpha 
        setGestureText(for: .screenEdgePanGesture)
    }
    
    func handleRotation(_ sender: UIRotationGestureRecognizer) {
        // rotate image
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
        setGestureText(for: .rotationGesture)
    }
    
    func handleSwipeUp(_ sender: UISwipeGestureRecognizer) {
        // change image to a random airplane
        setNewImage(for: "airplane")
        setGestureText(for: .swipeUpGesture)
    }
    
    func handleSwipeDown(_ sender: UISwipeGestureRecognizer) {
        // change image to a random airplane
        setNewImage(for: "ship")
        setGestureText(for: .swipeDownGesture)
    }
    
    func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        // reset to initial size & no roation 
        if let view = sender.view {
            view.transform = CGAffineTransform.identity
        }
        // change image to randomly bicycle.
        setNewImage(for: "bicycle")
        setGestureText(for: .longPressGesture)
    }

}

