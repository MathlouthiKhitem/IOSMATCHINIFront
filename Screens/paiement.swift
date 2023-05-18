//import SwiftUI
//import StripePaymentSheet
//struct CheckoutView: View {
//
//    @State private var paymentIntentClientSecret: String?
//
//    private let backendURL = URL(string: "http://127.0.0.1:4242")!
//
//    var body: some View {
//        VStack {
//            Button("Pay now") {
//                pay()
//            }
//            .disabled(paymentIntentClientSecret == nil)
//        }
//        .onAppear(perform: fetchPaymentIntent)
//    }
//
//    func fetchPaymentIntent() {
//        let url = backendURL.appendingPathComponent("/create-payment-intent")
//
//        let shoppingCartContent: [String: Any] = [
//            "items": [
//                ["id": "xl-shirt"]
//            ]
//        ]
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONSerialization.data(withJSONObject: shoppingCartContent)
//
//        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
//            guard
//                let response = response as? HTTPURLResponse,
//                response.statusCode == 200,
//                let data = data,
//                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
//                let clientSecret = json["clientSecret"] as? String
//            else {
//                let message = error?.localizedDescription ?? "Failed to decode response from server."
//                self.displayAlert(title: "Error loading page", message: message)
//                return
//            }
//
//            print("Created PaymentIntent")
//            self.paymentIntentClientSecret = clientSecret
//        }
//        task.resume()
//    }
//
//    func displayAlert(title: String, message: String? = nil) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default))
//        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true)
//    }
//
//    func pay() {
//        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
//            return
//        }
//
//        var configuration = PaymentSheet.Configuration()
//        configuration.merchantDisplayName = "Example, Inc."
//
//        let paymentSheet = PaymentSheet(
//            paymentIntentClientSecret: paymentIntentClientSecret,
//            configuration: configuration)
//
//        paymentSheet.present(from: (UIApplication.shared.windows.first?.rootViewController)!) { [self] (paymentResult) in
//            switch paymentResult {
//            case .completed:
//                self.displayAlert(title: "Payment complete!")
//            case .canceled:
//                print("Payment canceled!")
//            case .failed(let error):
//                self.displayAlert(title: "Payment failed", message: error.localizedDescription)
//            }
//        }
//    }
//}
//import SwiftUI
//import WebKit

//struct paiement: View {
//    let tokenout: String
//    
//    var body: some View {
//        PaymentView(tokenout: tokenout)
//    }
//    
//    struct PaymentView: View {
//        
//        @State private var showWebview = true
//        @State private var finalURL: String?
//        @State private var showAlert = false
//        let tokenout: String
//        
//        var paymeeURL: URL {
//            URL(string: "https://sandbox.paymee.tn/gateway/\(tokenout)/?paymee")!
//            
//            
//        }
//        var body: some View {
//            NavigationView {
//                VStack {
//                    
//                    if showWebview {
//                        
//                        WebView(url: self.paymeeURL, hideWebView: $showWebview, finalURL: $finalURL, tokenout: tokenout)
//                        
//                        
//                        
//                    } else {
//                        Text("Payment complete! Final URL: \(finalURL ?? "unknown")")
//                    }
//                    Button(action: {
//                        paiement(tokenout: self.tokenout).checkPayment(token: self.tokenout)
//                    }) {
//                        Text("Check payment")
//                    }
//                    .navigationBarTitle("Payment")
//                    
//                }
//                .alert(isPresented: $showAlert, content: {
//                    Alert(title: Text("Payment"), message: Text("Do you want to proceed with the payment?"), primaryButton: .default(Text("Yes"), action: {
//                        self.showWebview = true
//                    }), secondaryButton: .cancel(Text("No"), action: {
//                        self.showWebview = false
//                    }))
//                })
//                .navigationBarItems(trailing: Button(action: {
//                    self.showAlert = true
//                }) {
//                    Text("Payer")
//                })
//            }
//        }
//    }
//    
//    
//    struct PaymentResponse: Codable {
//        
//        let status: Bool
//        
//        let message: String
//        
//        let code: Int
//        
//        let data: PaymentData
//        
//    }
//    
//    
//    
//    struct PaymentData: Codable {
//        
//        let firstname: String
//        
//        let paymentStatus: Bool
//        
//        let phone: String
//        
//        let cost: Int
//        
//        let amount: Float
//        
//        let receivedAmount: Int
//        
//        let note: String
//        
//        let token: String
//        
//        let lastname: String
//        
//        let email: String
//        
//        let transactionId: Int
//        
//        let buyerId: Int
//        
//        
//        
//        enum CodingKeys: String, CodingKey {
//            
//            case firstname, phone, cost, amount, note, token, lastname, email
//            
//            case paymentStatus = "payment_status"
//            
//            case receivedAmount = "received_amount"
//            
//            case transactionId = "transaction_id"
//            
//            case buyerId = "buyer_id"
//            
//        }
//        
//    }
//    func checkPayment(token: String) {
//        
//        
//        
//        let url = URL(string: "https://sandbox.paymee.tn/api/v1/payments/\(token)/check")!
//        print("token",token);
//        var request = URLRequest(url: url)
//        
//        request.httpMethod = "GET"
//        
//        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let apiToken = "8cb752ab1b41f36363c73d5d7205f8175d3e21bd"
//        
//        request.setValue("Token \(apiToken)", forHTTPHeaderField: "Authorization")
//        
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        
//        
//        let session = URLSession.shared
//        
//        let task = session.dataTask(with: request) { data, response, error in
//            
//            guard let data = data, error == nil else {
//                
//                print("error")
//                
//                return
//                
//            }
//            
//            
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                
//                print("HTTP status code: \(httpResponse.statusCode)")
//                
//            }
//            
//            
//            
//            do {
//                
//                let decoder = JSONDecoder()
//                
//                let paymentResponse = try decoder.decode(PaymentResponse.self, from: data)
//                
//                print(paymentResponse)
//                
//                
//                
//                // TODO: Use the payment data here
//                
//                // You can access the data fields like this:
//                
//                let firstname = paymentResponse.data.firstname
//                
//                let amount = paymentResponse.data.amount
//                
//                let status = paymentResponse.data.paymentStatus
//                
//                
//                print("statusstatusstatus",status)
//                
//                if(status == true) {
//                    print("statusstatusstallltus",status)
//                    
//                    
//                }
//                
//                else {
//                    
//                    // Handle the case where status is false
//                    
//                }
//                
//            } catch let error {
//                
//                print(error.localizedDescription)
//                
//            }
//            
//            
//            
//        }
//        
//        
//        
//        task.resume()
//        
//    }
//    
//    struct WebView: UIViewRepresentable {
//        var url: URL
//        @State private var currentURL: URL?
//        @Binding var hideWebView: Bool
//        @Binding var finalURL: String?
//        let tokenout: String  // add tokenout here
//        
//        func makeUIView(context: Context) -> WKWebView {
//            let webView = WKWebView()
//            webView.navigationDelegate = context.coordinator
//            webView.load(URLRequest(url: url))
//            return webView
//        }
//        
//        func updateUIView(_ uiView: WKWebView, context: Context) {
//            if currentURL != url {
//                uiView.load(URLRequest(url: url))
//                currentURL = url
//            }
//        }
//        
//        
//        func makeCoordinator() -> Coordinator {
//            
//            Coordinator(self, tokenout: tokenout)
//            // pass tokenout here
//        }
//        
//        class Coordinator: NSObject, WKNavigationDelegate {
//            var parent: WebView
//            let tokenout: String  // add tokenout here
//            
//            init(_ parent: WebView, tokenout: String) {
//                self.parent = parent
//                self.tokenout = tokenout
//                
//            }
//            
//            func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//                if let url = webView.url {
//                    print("}}}}}}}}}}}}   ",url)
//                    parent.currentURL = url
//                    if url.absoluteString.contains("/loader") {
//                        parent.hideWebView = true
//                        parent.finalURL = url.absoluteString
//                        
//                        
//                        paiement(tokenout: self.tokenout).checkPayment(token: self.tokenout) 
//                    }
//                    print("The payment is completed.",url.absoluteString)
//                }
//            }
//        }
//        
//    }
//}
//// Define a view that represents a web view
//struct Paiement_Previews: PreviewProvider {
//    static var previews: some View {
//        paiement(tokenout: "")
//    }
//}
//
//
//
