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
        mapView.register(CustomFountainAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
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
            let annotation = WaterFountainAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: fountain.latitude, longitude: fountain.longitude),
                title: "Refill",
                subtitle: "",
                fountain: fountain
            )
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
            guard let selectedAnnotation = view.annotation as? WaterFountainAnnotation else {
                return
            }
            let selectedFountain = selectedAnnotation.fountain
            withAnimation {
                parent.isPopupVisible = true
                parent.selectedFountain = selectedFountain
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let fountainAnnotation = annotation as? WaterFountainAnnotation else {
                return nil
            }
            let identifier = "customFountainAnnotationView"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomFountainAnnotationView
            if annotationView == nil {
                annotationView = CustomFountainAnnotationView(annotation: fountainAnnotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = fountainAnnotation
            }
            return annotationView
        }

        func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
            let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)
            cluster.title = "\(memberAnnotations.count)"
            return cluster
        }
    }

    class WaterFountainAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        var fountain: WaterFountain

        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, fountain: WaterFountain) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
            self.fountain = fountain
        }
    }

    class CustomFountainAnnotationView: MKMarkerAnnotationView {
        override var annotation: MKAnnotation? {
            willSet {
                if let fountainAnnotation = newValue as? WaterFountainAnnotation {
                    markerTintColor = .main
                    glyphText = "⛲️"
                }
            }
        }
    }
}
