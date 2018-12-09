import Foundation
class Wasmand: Codable{
    var aantalStuks: Int
    var datumBinnen: Date
    var datumOphalen: Date
    
    init(aantalStuks: Int, datumBinnen: Date, datumOphaling: Date) {
        self.aantalStuks = aantalStuks
        self.datumBinnen = datumBinnen
        self.datumOphalen = datumOphaling
    }
    
   // Methodes op gegevens locaal op te slaan
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("wasmand").appendingPathExtension("plist")
    
    
    static func saveToFile(wasmanden: [Wasmand]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedWasmanden = try? propertyListEncoder.encode(wasmanden)
        
        try? codedWasmanden?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Wasmand]? {
        guard let codedWasmanden = try? Data(contentsOf: ArchiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode(Array<Wasmand>.self, from: codedWasmanden)
    }
}
