import MapKit
import UIKit

let count = 1000

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var SubView: UIView!
    
    var posts = NSMutableArray()
    var spotArray: [Spot]! = []
    
    func reload() {
        posts = postss
        loadInitData()
        if mapView == nil{
            print("reload fail")
        }
        mapView?.addAnnotations(spotArray)
    }
    func loadInitData() {
        for post in posts {
            let yadmNm = (post as AnyObject).value(forKey: "sop:rak_nam") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "sop:rak_addr") as! NSString as String
            let Xpos = (post as AnyObject).value(forKey: "sop:xpos") as! NSString as String
            let Ypos = (post as AnyObject).value(forKey: "sop:ypos") as! NSString as String
            let lat = (Ypos as NSString).doubleValue
            let lon = (Xpos as NSString).doubleValue
            //print(lat)
            //print(lon)
            let spot = Spot(title: yadmNm, location: addr, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            spotArray.append(spot)        }
        
        print("Spot: \(spotArray.count)")
    }
    func centerMap(location: CLLocation){
        let regionRadius: CLLocationDistance = 150000
        let coordinate = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView?.setRegion(coordinate, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ini = CLLocation(latitude: 37.5384514, longitude: 127.0709764)
        centerMap(location: ini)
        mapView.delegate = self
        // Do any additional setup after loading the view.
        print("didload")
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        let location = view.annotation as! Spot
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Spot else {return nil}
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            dequeView.annotation = annotation
            view = dequeView
        }
        else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        return view
    }
}


import Contacts

class Spot: NSObject, MKAnnotation{
    let title: String?
    let location: String
    let coordinate: CLLocationCoordinate2D
    
    
    
    init(title: String, location:String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.location = location
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return location
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
