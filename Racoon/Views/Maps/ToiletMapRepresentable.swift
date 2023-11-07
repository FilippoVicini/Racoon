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


        uiView.removeAnnotations(uiView.annotations)

        for toilet in toilets {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: toilet.latitude, longitude: toilet.longitude)
            

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
            guard let selectedAnnotation = view.annotation as? MKPointAnnotation else {
                return
            }

            let selectedCoordinate = selectedAnnotation.coordinate

            if let selectedToilet = parent.toilets.first(where: { toilet in
                toilet.latitude == selectedCoordinate.latitude && toilet.longitude == selectedCoordinate.longitude
            }) {
        
                withAnimation {
                    parent.isPopupVisible = true
                    parent.selectedToilet = selectedToilet
                }
            }
        }
    }
}


