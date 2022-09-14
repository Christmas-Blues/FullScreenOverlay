import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {

    func fullScreenOverlayPresentationSpace<T: Hashable>(name: T) -> some View {
        self
            .modifier(FullScreenOverlayPresenter(presentationSpace: .named(name)))
    }

    func fullScreenOverlayPresentationSpace(_ presentationSpace: PresentationSpace) -> some View {
        self
            .modifier(FullScreenOverlayPresenter(presentationSpace: presentationSpace))
    }

    @ViewBuilder func fullScreenOverlay<Overlay: View>(
        presentationSpace: PresentationSpace,
        @ViewBuilder content: () -> Overlay
    ) -> some View {
        self.modifier(FullScreenOverlaySetter(overlay: content(), presentationSpace: presentationSpace))
    }
}
