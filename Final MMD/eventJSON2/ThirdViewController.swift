//
//  ThirdViewController.swift
//  eventJSON2
//
//  Created by Nathan Seibert on 5/2/18.
//  Copyright © 2018 Nathan Seibert. All rights reserved.
//

import UIKit
struct Events1: Decodable {
    let id: Int
    let shop: String
    let styles: String
    
    
}


class ThirdViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate   {
    
    var selection: String!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var theEvent: UITextView!
    let items = ["Select A Style", "American Traditional", "Japanese Traditional", "Black"]
    
    
    
    override func viewDidLoad() {
        picker.delegate = self
        picker.dataSource = self

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //establishes the number of components (columns)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //establishes the number of rows in the json
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    //establishes selection of each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    //this is the function that runs when you select a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selection = items[row]
        let yrStyles = selection!
        theEvent.text! = "You picked \(yrStyles):\n"
        
        // url for json file. Must be https and hosted on a secure server. Change the location to your json file on your server
        
        let json = "https://resultjson.nathanseibert.com/tats2.json"
        
        // guard statements protect the app if there is no response
        guard let url = URL(string: json)
            else { return }
        
        // this area sets up a urlsession with the json
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data
                else { return }
            
            // use do, try, catch to deal with errors
            do {
                
                // JSONDecoder decodes json array
                let events1 = try JSONDecoder().decode([Events1].self, from: data)
                //enumerated adds the index to the array
                for (_, event) in events1.enumerated() {
                    if(event.styles == yrStyles) {
                        //must use this to change the ui element outside of the urlsession. Use of += to append to the TextView
                        DispatchQueue.main.sync {
                            self.theEvent.text! += ("\(event.styles) - \(event.shop) \n")
                        }
                    }
                }
            }
                
            catch let jsonErr {
                print("Error", jsonErr)
            }
            
            }.resume()
        
        
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
