import MapKit
import SwiftUI
struct MapRepresentable: UIViewRepresentable {
  @Binding var region: MapRegion
  @Binding var waterFountains: [WaterFountain]
  @Binding var mapSelection: MKMapItem?
  @Binding var selectedFountain: WaterFountain?
  @Binding var userTrackingMode: MKUserTrackingMode


  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.showsUserLocation = true
    mapView.pointOfInterestFilter = .excludingAll
      
    let userTrackingButton = MKUserTrackingButton(mapView: mapView)
    mapView.addSubview(userTrackingButton)
    userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      userTrackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 60),  // You can adjust the constant as needed
      userTrackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),  // You can adjust the constant as needed
    ])
    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
    let coordinateRegion = MKCoordinateRegion(center: region.center, span: region.span)
    uiView.setRegion(coordinateRegion, animated: true)
    // Set the user tracking mode based on the binding
    uiView.userTrackingMode = userTrackingMode

    // Add new annotations for water fountains
    for fountain in waterFountains {
      let annotation = MKPointAnnotation()
      annotation.coordinate = CLLocationCoordinate2D(
        latitude: fountain.latitude, longitude: fountain.longitude)
      uiView.addAnnotation(annotation)
    }
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

          // Find the selected fountain based on its coordinate
          let selectedCoordinate = selectedAnnotation.coordinate
          if let selectedFountain = parent.waterFountains.first(where: { fountain in
              fountain.latitude == selectedCoordinate.latitude && fountain.longitude == selectedCoordinate.longitude
          }) {
              // Set the selectedFountain and mapSelection to trigger the overlay view
              parent.selectedFountain = selectedFountain
              parent.mapSelection = MKMapItem(placemark: MKPlacemark(coordinate: selectedCoordinate))
          }
      }

  }
}