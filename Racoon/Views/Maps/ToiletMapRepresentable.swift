import SwiftUI
import MapKit

struct ToiletMapRepresentable: UIViewRepresentable {
    @Binding var region: MapRegion
    @Binding var toilets: [Toilet]
    @Binding var mapSelection: MKMapItem?
    @Binding var selectedToilet: Toilet?
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
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "customAnnotationView")
        return mapView
    }
    
    
    static func getRegion(with center: CLLocationCoordinate2D, span: MKCoordinateSpan) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: center, span: span)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if !isPopupVisible {
            uiView.userTrackingMode = userTrackingMode
        }
        
        if let userLocation = uiView.userLocation.location {
            
            let existingAnnotations = uiView.annotations.filter { $0 is MKPointAnnotation }
            uiView.removeAnnotations(existingAnnotations)
        }
        
        uiView.removeAnnotations(uiView.annotations)
        for toilet in toilets {
            let annotation = ToiletAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: toilet.latitude, longitude: toilet.longitude),
                title: "Toilet",
                subtitle: "",
                toilet: toilet
            )
            
            uiView.addAnnotation(annotation)
        }
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ToiletMapRepresentable
        
        init(parent: ToiletMapRepresentable) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let selectedAnnotation = view.annotation as? ToiletAnnotation else {
                return
            }
            
            let selectedToilet = selectedAnnotation.toilet
            
            withAnimation {
                parent.isPopupVisible = true
                parent.selectedToilet = selectedToilet
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let toiletAnnotation = annotation as? ToiletAnnotation else {
                return nil
            }
            
            let identifier = "customAnnotationView"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: toiletAnnotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = toiletAnnotation
            }
            
            return annotationView
        }
        
    }
    class ToiletAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        var toilet: Toilet
        
        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, toilet: Toilet) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
            self.toilet = toilet
        }
    }
    class CustomAnnotationView: MKMarkerAnnotationView {
        override var annotation: MKAnnotation? {
            willSet {
                if let toiletAnnotation = newValue as? ToiletAnnotation {
                    markerTintColor = .main
                    glyphText = "🚽"
                }
            }
        }
    }
    
    
}


