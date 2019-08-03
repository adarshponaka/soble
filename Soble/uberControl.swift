
import UIKit
import MapKit
import UberRides
import MessageUI
import Foundation
import Alamofire

class uberControl: UIViewController {

    
    @IBOutlet var addressLabel: UILabel!
    let locationManager = CLLocationManager()
  let uberButton = RideRequestButton()
  
  var accountSID = "ACe8e2fdba22535b8ed70023b9dccadcd8"
  var authToken = "faf4297892ad12b9ee579ce0c1baeae3"
  var completeAddress: String?
  
  
    @IBAction func sendText(_ sender: Any) {
      let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
      let parameters = ["From": "+15138541721", "To": "+15132502565", "Body": "Hey, this is Adarsh. I've been out drinking and I cannot drive. Can you pick me up at \(completeAddress ?? "the local bar")?"]
      
      AF.request(url, method: .post, parameters: parameters)
        .authenticate(username: accountSID, password: authToken)
        .responseJSON { response in
          debugPrint(response)
      }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkLocationServices()
      
        let geocoder = CLGeocoder()
        let address = "7779 Plantation Dr, Mason, OH 45040"
      
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
          if((error) != nil){
            print("Error", error ?? "")
          }
          if let placemark = placemarks?.first {
            let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
            print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
            let dropoffLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            let builder = RideParametersBuilder()
            builder.dropoffLocation = dropoffLocation
            builder.dropoffNickname = "My House"
            self.uberButton.rideParameters = builder.build()
            
            self.uberButton.center = self.view.center
            self.view.addSubview(self.uberButton)
          }
        })
    }
  
  func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func checkLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      setupLocationManager()
      checkLocationAuthorization()
    } else {
      alertUser()
    }
  }
  
  func alertUser() {
    let alert = UIAlertController(title: "Location Service Error", message: "Please enable your location services and allow this app to use your location in order to properly function.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
      NSLog("The \"OK\" alert occured.")
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  func checkLocationAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedWhenInUse:
      locationManager.startUpdatingLocation()
      break
    case .denied:
      // Show alert instructing them how to turn on permissions
      break
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      // Show an alert letting them know what's up
      break
    case .authorizedAlways:
      break
    }
  }
  

}

extension uberControl: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    let location = manager.location!
    let geoCoder = CLGeocoder()
    
    let builder = RideParametersBuilder()
    
    geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
      guard let self = self else { return }
      
      if let _ = error{
        print(error?.localizedDescription)
        return
      }
      
      guard let placemark = placemarks?.first else {
        return
      }
      
      let streetNumber = placemark.subThoroughfare ?? ""
      let street = placemark.thoroughfare ?? ""
      let city = placemark.subAdministrativeArea ?? ""
      let state = placemark.administrativeArea ?? ""
      let zipcode = placemark.postalCode ?? ""
      let country = placemark.country ?? ""
      self.completeAddress = "\(streetNumber) \(street) \(city), \(state) \n \(zipcode) \(country)"
      print(self.completeAddress)
      self.addressLabel.text = "\(streetNumber) \(street) \(city), \(state) \n \(zipcode) \(country)"
    }
    
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
}

