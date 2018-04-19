//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var selectedRow : Int = 0

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        finalURL = baseURL + currencyArray[0]
        getBitcoinPriceData(url: finalURL)
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
//        print(finalURL) // https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD
        getBitcoinPriceData(url: finalURL)
        selectedRow = row
    }
    

    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPriceData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

//                    print("Sucess! Got the price data")
                    let priceJSON : JSON = JSON(response.result.value!)

                    self.updatePriceData(json: priceJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updatePriceData(json : JSON) {
        
        if let priceResult = json["last"].double {
            bitcoinPriceLabel.text = symbolArray[selectedRow] + String(priceResult)
            
        } else {
            bitcoinPriceLabel.text = "No data available"
        }
    }
    




}

