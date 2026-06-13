import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    private let storeKey = "promptLibraryData"

    func makeCoordinator() -> Coordinator { Coordinator(storeKey: storeKey) }

    func makeUIView(context: Context) -> WKWebView {
        let controller = WKUserContentController()
        // Receive save requests from JS and persist them on device.
        controller.add(context.coordinator, name: "store")

        // Inject the saved data BEFORE the page script runs.
        let saved = UserDefaults.standard.string(forKey: storeKey) ?? "[]"
        let escaped = saved
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "")
        let js = "window.__INITIAL_PROMPTS__ = '\(escaped)';"
        controller.addUserScript(
            WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        )

        let config = WKWebViewConfiguration()
        config.userContentController = controller

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.backgroundColor = UIColor(red: 0.910, green: 0.918, blue: 0.933, alpha: 1) // matches --bg
        webView.isOpaque = true

        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKScriptMessageHandler {
        let storeKey: String
        init(storeKey: String) { self.storeKey = storeKey }
        func userContentController(_ ucc: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "store", let json = message.body as? String {
                UserDefaults.standard.set(json, forKey: storeKey)
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        WebView()
            .ignoresSafeArea()
    }
}
