//
//  NormalModeViewController.swift
//  AR Annotator
//
//  Created by Jurjen Braam on 06-01-18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Firebase

class NormalModeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return annotations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = annotationsTableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        
        let tag = annotations[indexPath.row].tag
        cell.textLabel?.text = String(tag)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedAnnotation = self.annotations[indexPath.row]
        performSegue(withIdentifier: "NormaltoAnnotate", sender: nil)
        
    }
    
    @IBAction func addNewAnnotation(_ sender: Any) {
        let annotation = Annotation()
        annotation.x = 0
        annotation.y = 0
        annotation.painting = self.paintingPassed
        annotation.name = self.namePassed
        annotation.mode = mode
        annotation.key = Database.database().reference().child("paintings").child(self.paintingPassed).child(self.namePassed).child(mode).childByAutoId().key;
        annotation.tag = self.annotations.count + 1
        annotations.append(annotation)
        selectedAnnotation = annotation
        performSegue(withIdentifier: "NormaltoAnnotate", sender: nil)
    }
    
    @IBOutlet weak var annotationsTableView: UITableView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var painting: UILabel!
    
    var namePassed = ""
    var paintingPassed = ""
    var imagePassed = UIImage()
    var mode = ""

    
    var i = 0
    var annotations: [Annotation] = []
    var selectedAnnotation: Annotation = Annotation()
    
    var annotationX = 0
    var annotationY = 0
    
    @IBOutlet weak var overlay: UIView!
    
    @IBOutlet weak var tutorialview: UIView!
    
    @IBAction func tutorialButton(_ sender: Any) {
        setView(view1: overlay, view2:tutorialview, hidden: true)
    }
    
    func setView(view1: UIView, view2: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view1.isHidden = hidden
            view2.isHidden = hidden
        }, completion: nil)
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overlay.isHidden = false
        tutorialview.isHidden = false
        annotationsTableView.dataSource = self
        annotationsTableView.delegate = self
        addButton.layer.cornerRadius = 10
        name.text = namePassed
        painting.text = paintingPassed

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let ref = Database.database().reference().child("paintings").child(self.paintingPassed).child(self.namePassed).child(mode)
        
        self.annotations.removeAll()
        
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            
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
                annotation.mode = self.mode
                annotation.x = annotationData!["x"] as! NSInteger
                annotation.y = annotationData!["y"] as! NSInteger
                annotation.data = (annotationData!["data"] as! NSString) as String
                annotation.tag = annotationData!["tag"] as! NSInteger
                
                self.annotations.append(annotation)
            }
            
            self.annotationsTableView.reloadData()
            
        })
        self.annotationsTableView.reloadData()
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
