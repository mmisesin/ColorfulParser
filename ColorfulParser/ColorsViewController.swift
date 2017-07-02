//
//  ViewController.swift
//  ColorfulParser
//
//  Created by Artem Misesin on 6/29/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class ColorsViewController: UIViewController {

    let colorsParser = Parser()
    
    @IBOutlet weak var colorsTable: UITableView!
    
    @IBOutlet weak var addressTextfield: UITextField!
    
    @IBOutlet weak var connectionIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performConvertion()
    }
    
    // all the action happens here
    fileprivate func performConvertion(){
        self.connectionIndicator.startAnimating()
        if var urlString = addressTextfield.text {
            
            // checking the level of user' lazyness
            if !urlString.contains("http") {
                urlString = "http://" + urlString
            }
            if let actualURL = URL(string: urlString) {
                
                // getting the html asynchronously
                colorsParser.getHTML(from: actualURL) { (data, response, error) in
                    guard let html = data, error == nil else { return }
                    
                    // passing the html to the model
                    self.colorsParser.parse(data: html)
                    
                    // refreshing UI on the main thread
                    DispatchQueue.main.async() { () -> Void in
                        self.connectionIndicator.stopAnimating()
                        self.colorsTable.reloadData()
                    }
                }
            }
        }
        self.view.endEditing(true)
    }

}

extension ColorsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performConvertion()
        return false
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ColorsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension ColorsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LineGenerator.shared.lineHeight(from: colorsParser.wordsArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "line", for: indexPath)
        cell.backgroundColor = LineGenerator.shared.lineColor(from: colorsParser.wordsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorsParser.amountOfData
    }
}

