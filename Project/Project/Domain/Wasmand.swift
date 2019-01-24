import Foundation
/// Domeinklasse Wasmand. Bevat attributen voor het toevoegen van een wasmand.
/// Deze klasse implementeert de klasse codable voor het opslaan en ophalen van locale gegevens.
class Wasmand: Codable{
    /// Aantal kledingstukken die in de wasmand zitten.
    var aantalStuks: Int
    /// De datum wanneer de wasmand is binnengebracht.
    var datumBinnen: Date
    /// De datum wanneer de wasmand terug is opgehaald.
    var datumOphalen: Date
    
    /// Houdt een url bij naar het punt waar de directory zich bevindt voor het wegschrijven van gegevens.
    /// - Parameters:
    ///     - for: Welke directory er moet gezocht worden.
    ///     - in: refereert naar de users home folder
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    /// De url specifieker maken voor het wegschrijven van de gegevens.
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("wasmand").appendingPathExtension("plist")
    
    
    /// Constructor voor het maken van een nieuw wasmand opbject
    ///
    /// - Parameters:
    ///   - aantalStuks: aantalStuks dat bij een wasmand hoort.
    ///   - datumBinnen: datum wanneer de wasmand is binnen gebracht
    ///   - datumOphaling: datum wanneer de wasmand terug mag opgehaald worden.
    init(aantalStuks: Int, datumBinnen: Date, datumOphaling: Date) {
        self.aantalStuks = aantalStuks
        self.datumBinnen = datumBinnen
        self.datumOphalen = datumOphaling
    }
    
    /// Methode voor het lokaal opslaan van een reeks wasmanden.
    ///
    /// - Parameter wasmanden: list van wasmanden.
    static func saveToFile(wasmanden: [Wasmand]) {
        
        // Encoderen van objecten
        let propertyListEncoder = PropertyListEncoder()
        let codedWasmanden = try? propertyListEncoder.encode(wasmanden)
        
        //Weg schrijven van de geëncodeerde objecten.
        try? codedWasmanden?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    
    /// Methode voor het ophalen van geëncodeerde objecten
    ///
    /// - Returns: lijst van wasmandobjecten.
    static func loadFromFile() -> [Wasmand]? {
        /// Ophalen van de data
        guard let codedWasmanden = try? Data(contentsOf: ArchiveURL) else { return nil }
        
        /// Decoderen van de data
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Wasmand>.self, from: codedWasmanden)
    }
}
