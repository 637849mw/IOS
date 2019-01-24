

import UIKit
import MessageUI
import MapKit

/// Klasse die de contact gegevens controleert.
class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var uiMail: UIImageView!
    @IBOutlet weak var uiPhone: UIImageView!
    @IBOutlet weak var uiMapp: UIImageView!
    @IBOutlet weak var lblOpening: UILabel!
    
    
    /// Bepalen van click eventents op images.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapMail = UITapGestureRecognizer(target: self, action: #selector(ContactViewController.mailTapped))
        uiMail.addGestureRecognizer(tapMail)
        
        let tapPhone = UITapGestureRecognizer(target: self, action: #selector(ContactViewController.phoneTapped))
        uiPhone.addGestureRecognizer(tapPhone)
        
        let tapMap = UITapGestureRecognizer(target: self, action: #selector(ContactViewController.mapTapped))
        uiMapp.addGestureRecognizer(tapMap)
        
        
        calculateOpening()
    }
    
    
    /// Methode die uitgevoerd indien er geklikt wordt op een mail-icon
    @objc func mailTapped(){
        //email conny
        let toRecipients = ["Strijkatelier@gmail.com.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate=self
        mc.setToRecipients(toRecipients)
        mc.setSubject("Vraag/opmerking")
        
        mc.setMessageBody("", isHTML: false)
        
        self.present(mc,animated: true,completion:nil)
    }
    
     /// Methode die uitgevoerd indien er geklikt wordt op een mail-icon
    @objc func phoneTapped(){
        guard let number = URL(string: "tel://051625636." ) else { return }
        UIApplication.shared.open(number)
    }
     /// Methode die uitgevoerd indien er geklikt wordt op een map-icon
    @objc func mapTapped(){
        
        //Defining destination
        let latitude:CLLocationDegrees = 51.062618
        let longitude:CLLocationDegrees = 3.279999
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "'t Strijkatelier"
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue: print("Cancelled")
        case MFMailComposeResult.failed.rawValue: print("Failed")
        case MFMailComposeResult.saved.rawValue: print("Saved")
        case MFMailComposeResult.sent.rawValue: print("Sent") default: break;
            
        }
        self.dismiss(animated: true,completion: nil)
        
    }
    
    func calculateOpening(){
        
        lblOpening.text = String("Gesloten")
        lblOpening.textColor = UIColor.red
        
        let myCalendar = Calendar(identifier: .gregorian)
        let today = Date()
        
        
        if (1 < myCalendar.component(.weekday, from: today) && 7 >= myCalendar.component(.weekday, from: today)){
            if (myCalendar.component(.hour, from: today) > 7 && 12 > myCalendar.component(.hour, from: today)) {
                lblOpening.text = String("Open")
                lblOpening.textColor = UIColor.green
            }
            
            if (myCalendar.component(.weekday, from: today) != 7){
                
                if (myCalendar.component(.hour, from: today) == 13 && 30 <= myCalendar.component(.minute, from: today)){
                    lblOpening.text = String("Open")
                    lblOpening.textColor = UIColor.green
                }
                
                if (myCalendar.component(.hour, from: today) == 14 || 15 == myCalendar.component(.minute, from: today)){
                    lblOpening.text = String("Open")
                    lblOpening.textColor = UIColor.green
                }
                
                if (myCalendar.component(.hour, from: today) == 16 && 30 >= myCalendar.component(.minute, from: today)){
                    lblOpening.text = String("Open")
                    lblOpening.textColor = UIColor.green
                }
                
            }
            
        }
    }
}
