//
//  AnnotationViewController.swift
//  AR Annotator
//
//  Created by Jurjen Braam on 13-12-17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase



class AnnotationViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var ref: DatabaseReference!
   
    var annotation = Annotation()

    @IBOutlet weak var modeLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var annotationText: UITextView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = annotation.name
        modeLabel.text = annotation.mode
        deleteButton.layer.cornerRadius = 10
        ref = Database.database().reference().child("paintings").child(annotation.painting).child(annotation.name).child(annotation.mode).child(annotation.key)
    
        ref.observe(DataEventType.value, with: { (snapshot) in

            // Get user value
            
            let value = snapshot.value as? NSDictionary
            
            guard snapshot.exists() else {
                return
            }
            
            self.annotationText.text = value!["data"] as! String
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        ref.setValue([
            "data": self.annotationText.text,
            "tag": self.annotation.tag,
            "x": annotation.x,
            "y": annotation.y,
            ])
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        ref.removeValue()
        navigationController?.popViewController(animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
