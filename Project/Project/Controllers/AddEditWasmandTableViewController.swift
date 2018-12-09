//
//  addEditWasmandTableViewController.swift
//  Project
//
//  Created by Matthias Warnez on 15/11/2018.
//  Copyright © 2018 Matthias Warnez. All rights reserved.
//

import UIKit

class AddEditWasmandTableViewController: UITableViewController {
    
    var wasmand: Wasmand? = nil
    
    @IBOutlet weak var saveButton:UIBarButtonItem!
    
    
    @IBOutlet weak var aantalLabel:UITextField!
    @IBOutlet weak var datumbinnenDatepicker:UIDatePicker!
    @IBOutlet weak var datumOphalingLabel: UILabel!
    
    @IBOutlet weak var vandaagLabel:UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //indien er een nieuw object gemaakt moet worden.
        datumbinnenDatepicker.minimumDate = Calendar.current.startOfDay(for: Date())
        datumOphalingLabel.text = geefDatumAlsString(datum: berekenOphaaldatum(datum: Date()))
        
        vandaagLabel.text="Vandaag: " + geefDatumAlsString(datum: Date())
        
        
        // indien het een aanpassing is
        if let wasmand = self.wasmand{
            aantalLabel.text = String(wasmand.aantalStuks)
            datumbinnenDatepicker.setDate(wasmand.datumBinnen, animated: true)
            datumOphalingLabel.text = geefDatumAlsString(datum: wasmand.datumOphalen)
        }
        
        updateSaveButtonState()
    }
    
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    
    @IBAction func dateChanged2(_ sender: Any) {
        datumOphalingLabel.text = geefDatumAlsString(datum: berekenOphaaldatum(datum: datumbinnenDatepicker.date))
    }
    
    func updateSaveButtonState() {
        let aantal = aantalLabel.text ?? ""
        saveButton.isEnabled = !aantal.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let aantal = aantalLabel.text ?? ""
        let datumbinnen = datumbinnenDatepicker.date
        let datumophaal = berekenOphaaldatum(datum: datumbinnenDatepicker.date)
        wasmand = Wasmand(aantalStuks: Int(aantal)!, datumBinnen: datumbinnen, datumOphaling: datumophaal)
        
    }
    
    private func berekenOphaaldatum(datum: Date) -> Date{
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: datum)
        let ophaal: Date
        
        switch weekDay {
        // Maandag
        case 2,3,4,5:
            ophaal = datum.addingTimeInterval(2*86400)
        default :
            ophaal = datum.addingTimeInterval(4*86400)
        }
        return ophaal
    }
    
    private func geefDatumAlsString(datum: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        
        // dag van de week bepalen
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: datum)
        
        
        switch weekDay {
        case 2: return "ma " + formatter.string(from: datum)
        case 3: return "di "  + formatter.string(from: datum)
        case 4: return "woe " + formatter.string(from: datum)
        case 5: return "do " + formatter.string(from: datum)
        case 6: return "vrij " + formatter.string(from: datum)
        case 7: return "za " + formatter.string(from: datum)
        case 1: return "zo " + formatter.string(from: datum)
            
        default:
            formatter.string(from: datum)
        }
        
        return ""
    }
}
