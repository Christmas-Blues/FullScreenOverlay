import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct FullScreenOverlayPresenter: ViewModifier {

    var presentationSpace: PresentationSpace

    @ObservedObject private var container: FullScreenOverlayContainer = .shared

    func body(content: Content) -> some View {
        content.overlay(
            ZStack {
                ForEach(
                    container.overlays[presentationSpace, default: [:]].sorted(by: { $0.key.hashValue < $1.key.hashValue }),
                    id: \.key
                ) { _, overlay in
                    overlay
                }
            }
        )
    }
}
