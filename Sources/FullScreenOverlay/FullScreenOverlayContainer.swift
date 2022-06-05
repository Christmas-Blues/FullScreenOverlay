import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
class FullScreenOverlayContainer: ObservableObject {

    static let shared: FullScreenOverlayContainer = .init()

    @Published private(set) var overlays: [PresentationSpace: [AnyHashable: AnyView]] = .init()

    func updateOverlay<ID: Hashable, Overlay: View>(_ overlay: Overlay, for id: ID, in presentationSpace: PresentationSpace) {
        self.overlays[presentationSpace, default: [:]].updateValue(AnyView(overlay), forKey: id)
    }

    func removeOverlay<ID: Hashable>(for id: ID, in presentationSpace: PresentationSpace) {
        self.overlays[presentationSpace, default: [:]].removeValue(forKey: id)
    }
}
