//
//  WasmandTableViewCell.swift
//  Project
//
//  Created by Matthias Warnez on 15/11/2018.
//  Copyright © 2018 Matthias Warnez. All rights reserved.
//

import UIKit

class WasmandTableViewCell: UITableViewCell {

    @IBOutlet weak var datumBinnenLabel: UILabel!
    @IBOutlet weak var datumOphalenLabel:UILabel!

    
    func update(with wasmand: Wasmand){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        datumBinnenLabel.text = String(formatter.string(from: wasmand.datumBinnen))
        datumOphalenLabel.text = String(formatter.string(from:wasmand.datumOphalen))
        
    
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
