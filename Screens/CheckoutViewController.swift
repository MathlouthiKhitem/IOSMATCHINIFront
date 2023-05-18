//
//  CheckoutViewController.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 16/5/2023.
import UIKit
import StripePaymentSheet
import SwiftUI

class CheckoutViewController: UIViewController {

    let login: String
       
       // Rest of your code
       
       init(login: String) {
           self.login = login
           print("dfghjkl",login);
           print("self.login ",self.login );

           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    private static let backendURL = URL(string: "http://127.0.0.1:4242")!

    private var paymentIntentClientSecret: String?

    private lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Pay now", for: .normal)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        StripeAPI.defaultPublishableKey = "pk_test_51N5FRxLwcHojLkgQOQIVis89z6aWgYHrcXZM8uWaOdvqFVpcEO56YgNFMbzUJMOAeZXQtbpP1ZzgXIF6U59deqr400w3jA2Zec"

        view.backgroundColor = .systemBackground
        view.addSubview(payButton)

        NSLayoutConstraint.activate([
            payButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])


        self.fetchPaymentIntent()
    }

    func fetchPaymentIntent() {
        let url = Self.backendURL.appendingPathComponent("/create-payment-intent")

        let shoppingCartContent: [String: Any] = [
            "items": [
                ["id": "xl-shirt"]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: shoppingCartContent)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let clientSecret = json["clientSecret"] as? String
            else {
                let message = error?.localizedDescription ?? "Failed to decode response from server."
                self?.displayAlert(title: "Error loading page", message: message)
                return
            }

            print("Created PaymentIntent")
            self?.paymentIntentClientSecret = clientSecret

            DispatchQueue.main.async {
                self?.payButton.isEnabled = true
            }
        })

        task.resume()
    }

    func displayAlert(title: String, message: String? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }

    @objc
    func pay() {
        guard let paymentIntentClientSecret = self.paymentIntentClientSecret else {
            return
        }
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Example, Inc."

        let paymentSheet = PaymentSheet(
            paymentIntentClientSecret: paymentIntentClientSecret,
            configuration: configuration)

        paymentSheet.present(from: self) { [weak self] (paymentResult) in
            self?.handlePaymentResult(paymentResult)
        }
    }
    func handlePaymentResult(_ paymentResult: PaymentSheetResult) {
        switch paymentResult {
        case .completed:
         let loginView = matche(login: login)
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "paid")
            let loginViewController = UIHostingController(rootView: loginView)
            navigationController?.pushViewController(loginViewController, animated: true)
        case .canceled:
            print("Payment canceled!")
        case .failed(let error):
            displayAlert(title: "Payment failed", message: error.localizedDescription)
        }
    }
    func checkPaymentStatus() {
        guard let paymentIntentClientSecret = self.paymentIntentClientSecret,
              let url = URL(string: "https://api.stripe.com/v2/payment_intents/retrieve") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("sk_test_51N5FRxLwcHojLkgQ8Nllpvx8WhWFZWfyiiGbtiZATYE8aOBoBUE3lmJGTenCl3BQDTeDWiPRnbMXbWiAGxCkB0kn00V3ohPGkc", forHTTPHeaderField: "Authorization") // Replace with your Stripe API key

        let parameters: [String: Any] = [
            "client_secret": paymentIntentClientSecret
        ]
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        request.url = urlComponents?.url

        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                // Handle the error
                self?.displayAlert(title: "Error", message: error.localizedDescription)
                return
            }

            guard let data = data else {
                // Handle empty data or invalid response
                self?.displayAlert(title: "Error", message: "Invalid response from server")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let status = json?["status"] as? String {
                    if status == "succeeded" {
                        // Payment is successful
                        self?.displayAlert(title: "Payment Success", message: "Your payment was successful!")
                        // Perform any additional logic or UI updates
                        // For example, navigate to a success screen
                        // self?.navigateToSuccessScreen()
                    } else if status == "requires_payment_method" {
                        // Payment requires a new payment method
                        self?.displayAlert(title: "Payment Failed", message: "The payment failed. Please try again with a different payment method.")
                        // Perform any additional logic or UI updates
                    } else {
                        // Other payment status cases
                        self?.displayAlert(title: "Payment Status", message: "The payment status is \(status).")
                        // Perform any additional logic or UI updates
                    }
                }
            } catch {
                // Handle JSON parsing error
                self?.displayAlert(title: "Error", message: "Failed to parse response")
            }
        }.resume()
    }



}


