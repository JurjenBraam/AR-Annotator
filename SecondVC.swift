//
//  SecondVC.swift
//  Multiview
//
//  Created by Jurjen Braam on 23-11-17.
//  Copyright © 2017 Jurjen Braam. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable
class RoundUIView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}

class SecondVC: UIViewController, UIScrollViewDelegate {
    
    var namePassed = ""
    var paintingPassed = ""
    var imagePassed = UIImage()
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var painting: UILabel!
    
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var overlay: UIView!
    
    @IBOutlet weak var tutorialview: UIView!
    @IBOutlet weak var tutorialButton: UIButton!
    
    @IBAction func tutorialButton(_ sender: Any) {
        setView(view1: overlay, view2:tutorialview, hidden: true)
    }

    
    
    
    func setView(view1: UIView, view2: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view1.isHidden = hidden
            view2.isHidden = hidden
        }, completion: nil)
    }
    
    
    var longPressGesture = UILongPressGestureRecognizer()
    
    var i = 0
    var annotations: [Annotation] = []
    var selectedAnnotation: Annotation = Annotation()
    
    var annotationX = 0
    var annotationY = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlay.isHidden = false;
        tutorialview.isHidden = false;
        // Do any additional setup after loading the view.
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        if namePassed == "" {
            name.text = "Default"
        }
        else {
            name.text = namePassed
        }
        painting.text = paintingPassed
        inputImageView.image = imagePassed
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureHandler))
        inputImageView.isUserInteractionEnabled = true
        longPressGesture.minimumPressDuration = 0.3
        inputImageView.addGestureRecognizer(longPressGesture)
        
        tutorialButton.layer.cornerRadius = 4
        
        
        let ref = Database.database().reference().child("paintings").child(self.paintingPassed).child(self.namePassed).child("2D")
        
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            
            guard snapshot.hasChildren() else {
                return
            }
            self.i = Int(snapshot.childrenCount)
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let annotationData = rest.value as? NSDictionary
                let annotation = Annotation()
                annotation.key = rest.key
                annotation.name = self.namePassed
                annotation.painting = self.paintingPassed
                annotation.mode = "2D"
                annotation.x = annotationData!["x"] as! NSInteger
                annotation.y = annotationData!["y"] as! NSInteger
                annotation.data = (annotationData!["data"] as! NSString) as String
                annotation.tag = annotationData!["tag"] as! NSInteger
                
                self.annotations.append(annotation)
            }
            
            self.renderAnnotations(annotations: self.annotations)
        })
     
        
    }
        
    
    /// handle tap here
    @objc func handleTap(sender: UITapGestureRecognizer) {

    
        self.selectedAnnotation = self.annotations[(sender.view?.tag)!]
        performSegue(withIdentifier: "2DtoAnnotate", sender: nil)
        

    }
    
    func renderAnnotations(annotations: [Annotation]) {
        for annotation in annotations {
            let label = UIButton(type: .infoLight)
            label.frame = CGRect(x: annotation.x, y: annotation.y, width: 20, height: 20)
            label.backgroundColor = UIColor(white: 1, alpha: 0.5)
            label.layer.cornerRadius = 10
            
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
            label.addGestureRecognizer(tapGesture)
            label.tag = Int(annotation.tag)
            self.inputImageView.addSubview(label)
        }
    }
    
    @objc func longPressGestureHandler(press:UILongPressGestureRecognizer) {
        if (press.state == .began) {
            print("Long press")
            print(press.location(in: inputImageView))
            
            let annotation = Annotation()
            annotation.x = Int(press.location(in: inputImageView).x)
            annotation.y = Int(press.location(in: inputImageView).y)
            annotation.painting = self.paintingPassed
            annotation.name = self.namePassed
            annotation.mode = "2D"
            annotation.key = Database.database().reference().child("paintings").child(self.paintingPassed).child(self.namePassed).child("2D").childByAutoId().key;
            annotation.tag = i
            print(annotation.tag)
            annotations.append(annotation)
        
            let label = UIButton(type: .infoLight)
            label.frame = CGRect(x: annotation.x - 10, y: annotation.y - 10, width: 20, height: 20)
            label.backgroundColor = UIColor(white: 1, alpha: 0.5)
            label.layer.cornerRadius = 10
        
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
            label.addGestureRecognizer(tapGesture)

            
            label.tag = i
            i += 1
            
            self.inputImageView.addSubview(label)
        
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.inputImageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is AnnotationViewController
        {
            let vc = segue.destination as? AnnotationViewController
            vc?.annotation = self.selectedAnnotation
        }
    }
    

}
