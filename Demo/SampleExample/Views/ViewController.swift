//
//  ViewController.swift
//  SampleExample
//
//  Created by Amit Shah on 14/11/23.
//

import UIKit
import CountryPickerAKS

class ViewController: UIViewController {
    
    @IBOutlet weak var responseLbl: UILabel!
    @IBOutlet weak var btn001: UIButton!
    @IBOutlet weak var btn002: UIButton!
    @IBOutlet weak var btn003: UIButton!
    @IBOutlet weak var btn004: UIButton!
    @IBOutlet weak var btn005: UIButton!
    @IBOutlet weak var btn006: UIButton!
    @IBOutlet weak var btn007: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn001.isHidden = true
        btn002.isHidden = true
        btn003.isHidden = true
        btn004.isHidden = true
        btn005.isHidden = true
        btn006.isHidden = true
        btn007.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Optimize button animations by using a batch approach
        let buttons = [btn001, btn002, btn003, btn004, btn005, btn006, btn007]
        
        for (index, button) in buttons.enumerated() {
            guard let button = button else { continue }
            
            UIView.animate(withDuration: 0.15, delay: Double(index) * 0.05) {
                button.customUI()
            }
        }
    }

    func updateValue(result: Result<CountryList, CustomError>){
        
        switch result {
        case .success(let data):
            UIView.animate(withDuration: 0.3) {
                self.responseLbl.text = "Country Name: \(data.name) \n Flag: \(data.emoji) \n Code: \(data.code) \n Country Code: \(data.dial_code)"
            }
        case .failure(let err):
            debugPrint(err.localizedDescription)
            UIView.animate(withDuration: 0.3) {
                self.responseLbl.text = err.localizedDescription
            }
        }
    }
    
    @IBAction func listViewBtn(_ sender: UIButton) {
        
        switch sender {
        case btn001:
            //Default
            CountryPicker.show(from: self) { result in
                self.updateValue(result: result)
            }
            
        case btn002:
            //Display type update
            CountryPicker.show(from: self, config: Config(display: ShowContent(Flag: true, CountryName: true))) { result in
                self.updateValue(result: result)
            }
            
        case btn003:
            //Text Color Update
            CountryPicker.show(from: self, config: Config(
                color: ThemeColor(
                    primary: .systemGray6,
                    secondary: .systemBackground,
                    textColor: .systemBlue)
            )) { result in
                self.updateValue(result: result)
            }
            
        case btn004:
            //Font Update
            CountryPicker.show(from: self, config: Config(
                font: ThemeFont(
                    searchBar: UIFont(name: "Lemonada-Medium", size: 16) ?? UIFont(),
                    countryName: UIFont(name: "Lemonada-Regular", size: 16) ?? UIFont(),
                    countryCode: UIFont(name: "Lemonada-Light", size: 16) ?? UIFont(),
                    countryFlag: UIFont(name: "Lemonada-Bold", size: 22) ?? UIFont())
            )) { result in
                self.updateValue(result: result)
            }
            
        case btn005:
            //Show Local Country On Top Off
            CountryPicker.show(from: self, config: Config(
                data: CustomizeCountryList(showLocalOnTop: false)
            )) { result in
                self.updateValue(result: result)
            }
            
        case btn006:
            //Update country list Position
            CountryPicker.show(from: self, config: Config(
                data: CustomizeCountryList(alterExisting: [
                    .onTopAfterLocal(["NP","US"]),
                    .onTop(["AQ"]),
                    .onBottom(["AD"])
                ])
            )) { result in
                self.updateValue(result: result)
            }
        
        case btn007:
            //Add New country list Position
            CountryPicker.show(from: self, config: Config(
                data: CustomizeCountryList(
                    addNew: [
                        CountryList(name: "New Country", dial_code: "+12", emoji: "🫡", code: "NCA"),
                        CountryList(name: "New Country B", dial_code: "+13", emoji: "😵‍💫", code: "NCB")
                    ],
                    alterExisting: [
                        .onTop(["NCA", "NCB"]),
                        .onTopAfterLocal(["NP"]),
                        .onBottom(["US"])
                    ]
                )
            )) { result in
                self.updateValue(result: result)
            }
            
//            CountryPicker.show(from: self, config: Config(
//                data: CustomizeCountryList(
//                    addNew: [
//                        CountryList(name: "New Country", dial_code: "+12", emoji: "🫡", code: "NCA"),
//                        CountryList(name: "New Country B", dial_code: "+13", emoji: "😵‍💫", code: "NCB")
//                    ],
//                    alterExisting: [
//                        .displayOnly(["NCA","NCB"]),
//                        .removeOnly(["NCB", "NP"])
//                    ]
//                )
//            )) { result in
//                self.updateValue(result: result)
//            }
            
            
            
        default: break
            
        }
        
    }
    
}
