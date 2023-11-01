import SwiftUI
import MapKit

struct MapRepresentable: UIViewRepresentable {
    @Binding var region: MapRegion
    @Binding var waterFountains: [WaterFountain]
    @Binding var mapSelection: MKMapItem?
    @Binding var selectedFountain: WaterFountain?
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var isPopupVisible: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsCompass = false
        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
        mapView.addSubview(userTrackingButton)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userTrackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 60),
            userTrackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
        ])
        return mapView
    }
    
    static func getRegion(with center: CLLocationCoordinate2D, span: MKCoordinateSpan) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: center, span: span)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if !isPopupVisible {
            uiView.userTrackingMode = userTrackingMode
        }
        
        if !isPopupVisible {
            if let userLocation = uiView.userLocation.location {
                CLGeocoder().reverseGeocodeLocation(userLocation) { placemarks, error in
                    if let city = placemarks?.first?.locality {
                        print("User's current city: \(city)")
                    }
                }
            }
        }
        
        let fountainAnnotations = waterFountains.map { fountain in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: fountain.latitude, longitude: fountain.longitude)
            return annotation
        }
        uiView.addAnnotations(fountainAnnotations)
        

    }
    
    
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapRepresentable
        
        init(parent: MapRepresentable) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let selectedAnnotation = view.annotation as? MKPointAnnotation else {
                return
            }
            
            let selectedCoordinate = selectedAnnotation.coordinate
            
            if let selectedFountain = parent.waterFountains.first(where: { fountain in
                fountain.latitude == selectedCoordinate.latitude && fountain.longitude == selectedCoordinate.longitude
            }) {
                // Display the popup with an animation and update the selected fountain
                withAnimation {
                    parent.isPopupVisible = true
                    parent.selectedFountain = selectedFountain
                }
            }
        }
        
    }
}
