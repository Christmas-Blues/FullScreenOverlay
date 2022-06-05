import SwiftUI
import FullScreenOverlay

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private struct RootView: View {

    @State private var isPresentingBottomSheet: Bool = false

    var body: some View {
        List {
            Button(
                "Present Bottom Sheet",
                action: { isPresentingBottomSheet = true }
            )
            .fullScreenOverlay(presentationSpace: .named("RootView")) {
                if isPresentingBottomSheet {
                    BottomSheet(onDismiss: { isPresentingBottomSheet = false })
                }
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private struct BottomSheet: View {

    var onDismiss: () -> Void

    @State private var isAppearing: Bool = false

    var body: some View {
        Color.black.opacity(0.2)
            .edgesIgnoringSafeArea(.all)
            .zIndex(-1)
            .onTapGesture(perform: onDismiss)
            .transition(.opacity.animation(.default))
        VStack {
            Text("Bottom Sheet")
                .font(.title.weight(.semibold))
                .padding(.vertical, 128)
            Button("Dismiss", action: { isAppearing = false; onDismiss() })
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .background(
            Color.white
                .shadow(radius: 1)
                .edgesIgnoringSafeArea(.all)
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
        .transition(.move(edge: .bottom))
        .animation(.spring())
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
internal struct SwiftUIView_Previews: PreviewProvider {

    static var previews: some View {
        RootView()
            .fullScreenOverlayPresentationSpace(name: "RootView")
    }
}
