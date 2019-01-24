import UIKit

/// Klasse voor een specifieke layout van een TableViewCell
class WasmandTableViewCell: UITableViewCell {

    
    /// Referentie naar labels
    @IBOutlet weak var datumBinnenLabel: UILabel!
    @IBOutlet weak var datumOphalenLabel:UILabel!

    
    /// Functie die de labels opvult, en in een juist datum formaat zet.
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
