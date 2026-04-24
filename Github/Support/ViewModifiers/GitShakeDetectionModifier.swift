import ObjectiveC
import PulseUI
import SwiftUI
import UIKit

struct GitShakeDetectionModifier: ViewModifier {
    @State private var showPulse = false

    func body(content: Content) -> some View {
        content
            .background(GitShakeDetectorView())
            .onAppear {
                GitShakeEventBridge.activate()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.gitShowPulse)) { _ in
                showPulse = true
            }
            .sheet(
                isPresented: $showPulse,
                onDismiss: {
                    showPulse = false
                },
                content: {
                    pulseView()
                }
            )
    }

    @ViewBuilder
    private func pulseView() -> some View {
        NavigationStack {
            ConsoleView()
        }
    }
}

private struct GitShakeDetectorView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GitShakeDetectorViewController {
        GitShakeDetectorViewController()
    }

    func updateUIViewController(
        _ viewController: GitShakeDetectorViewController,
        context: Context
    ) {
        viewController.becomeFirstResponder()
    }
}

private final class GitShakeDetectorViewController: UIViewController {
    override var canBecomeFirstResponder: Bool {
        true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GitShakeEventBridge.activate()
        becomeFirstResponder()
    }

    override func motionEnded(
        _ motion: UIEvent.EventSubtype,
        with event: UIEvent?
    ) {
        if motion == .motionShake {
            UIDevice.gitPostShakeNotification()
        } else {
            super.motionEnded(
                motion,
                with: event
            )
        }
    }
}

enum GitShakeEventBridge {
    private static var isInstalled = false

    static func activate() {
        UIApplication.shared.applicationSupportsShakeToEdit = false
        install()
    }

    static func install() {
        guard !isInstalled else {
            return
        }

        let applicationClass: AnyClass = type(of: UIApplication.shared)

        guard let originalMethod = class_getInstanceMethod(
            applicationClass,
            #selector(UIApplication.sendEvent(_:))
        ),
            let swizzledMethod = class_getInstanceMethod(
                UIApplication.self,
                #selector(UIApplication.gitSendEvent(_:))
            ) else {
            return
        }

        class_addMethod(
            applicationClass,
            #selector(UIApplication.gitSendEvent(_:)),
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )

        guard let installedSwizzledMethod = class_getInstanceMethod(
            applicationClass,
            #selector(UIApplication.gitSendEvent(_:))
        ) else {
            return
        }

        method_exchangeImplementations(
            originalMethod,
            installedSwizzledMethod
        )
        isInstalled = true
    }
}

private extension UIApplication {
    @objc func gitSendEvent(_ event: UIEvent) {
        gitSendEvent(event)

        guard event.type == .motion,
              event.subtype == .motionShake else {
            return
        }

        UIDevice.gitPostShakeNotification()
    }
}
