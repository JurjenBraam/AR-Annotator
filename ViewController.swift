//
//  ViewController.swift
//  Multiview
//
//  Created by Jurjen Braam on 22-11-17.
//  Copyright © 2017 Jurjen Braam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var imagePicker: UIPickerView!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var selectedPaintingLabel: UILabel!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    let paintings = [["Painting 1", "painting1"], ["Painting 2", "painting2"], ["Painting 3", "painting3"]]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paintings[row][0]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paintings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPaintingLabel.text = paintings[row][0]
        imageViewer.image = UIImage(named: paintings[row][1])
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view, typically from a nib.
         imagePicker.delegate?.pickerView?(imagePicker, didSelectRow: 0, inComponent: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startClicked(_ sender: Any) {
        
        if modeSelector.selectedSegmentIndex == 0 {
         
            let myVC = storyboard?.instantiateViewController(withIdentifier: "NormalModeViewController") as! NormalModeViewController
            if (self.inputName.text! != "") {
                myVC.namePassed = self.inputName.text!
            }
            else  {
                myVC.namePassed = "default"
            }
            myVC.mode = "Normal"
            myVC.paintingPassed = selectedPaintingLabel.text!
            myVC.imagePassed = self.imageViewer.image!
            navigationController?.pushViewController(myVC, animated: true)
        }
        
        else if modeSelector.selectedSegmentIndex == 1 {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
            if (self.inputName.text! != "") {
                    myVC.namePassed = self.inputName.text!
            }
            else  {
                myVC.namePassed = "default"
            }
            
            myVC.paintingPassed = selectedPaintingLabel.text!
            myVC.imagePassed = self.imageViewer.image!
            navigationController?.pushViewController(myVC, animated: true)
        }
        else if modeSelector.selectedSegmentIndex == 2 {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            if (self.inputName.text! != "") {
                myVC.namePassed = self.inputName.text!
            }
            else  {
                myVC.namePassed = "default"
            }
            myVC.paintingPassed = selectedPaintingLabel.text!
            navigationController?.pushViewController(myVC, animated: true)
        }
        
    }
    
}

