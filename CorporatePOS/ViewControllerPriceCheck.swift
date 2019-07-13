//
//  ViewControllerPriceCheck.swift
//  CorporatePOS
//
//  Created by user154891 on 5/31/19.
//  Copyright © 2019 user154891. All rights reserved.
//

import UIKit
import Foundation

struct DataResponse: Codable {
    
    var Name: String
    var Price: String
    var Photo: String
    
}


struct DataRequest: Codable {
    
    var Barcode: String
    
}


class ViewControllerPriceCheck: UIViewController {

    
    @IBOutlet weak var PicFromServer: UIImageView!
    @IBOutlet weak var LabelPrice: UILabel!
    @IBOutlet weak var LabekName: UILabel!
    @IBOutlet weak var ButtonClose: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

 
    @IBAction func SendData(_ sender: UIButton) {
        
    }
    
    
    @IBAction func CloseWindow(_ sender: Any) {
    dismiss(animated: true)
        
    }
    
   
    
    @IBAction func UnwindFromBarcodeReader(_ sender:UIStoryboardSegue)
    {
        guard let ScannerVC = sender.source as? ScannerViewController else { return }
        print(ScannerVC.Barcode)
        
        
        let myUrl = URL(string: "http://95.47.183.240:600/TSD/hs/limema/getdata")
        let dataRequest = DataRequest(Barcode: ScannerVC.Barcode)
        
        
        
        let encodedData = try? JSONEncoder().encode(dataRequest)
        
        print("111")
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"
        
        
        
        //guard let httpBody = try? JSONSerialization.data(withJSONObject: par, options: []) else { return}
        
        guard let httpBody = encodedData else { return}
        
        
        
        request.httpBody = httpBody
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                
                let alert = UIAlertController(title: "Error", message: "You havent't connect with Internet!", preferredStyle: .alert)
                let ac = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ac)
                self.present(alert, animated: true)
                
                print("error=\(String(describing: error))")
                
                return
                
            }
            
            
            
            if error != nil {
                
                print("error=\(String(describing: error))")
                
                return
                
            }
            
            print("222")
            
            print(data)
            
            do {
                
                
                
                // let json = try JSONSerialization.jsonObject(with: data, options:[])
                
                print("333")
                
                let decodedData = try JSONDecoder().decode(DataResponse.self, from: data)
                
                print("decodedData")
                
                print(decodedData)
                
                // print("json")
                
                // print(json)
                DispatchQueue.main.async {
                    
                    self.LabekName.text  =  decodedData.Name
                    self.LabelPrice.text =  decodedData.Price + " руб."
                    
                    
                    if let url = URL(string: decodedData.Photo){
                        
                        do {
                            let data = try Data(contentsOf: url)
                            self.PicFromServer.image = UIImage(data: data)
                            
                        }catch let err {
                            print(" Error : \(err.localizedDescription)")
                        }
                        
                        
                    }
                    
                    
                }
                
                
            } catch {
                
                print("error")
                
                print(error)
                
            }
            
        }
        
        
        
        
        
        task.resume()
        
        
    }
    

}
