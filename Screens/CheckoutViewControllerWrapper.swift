//
//  CheckoutViewControllerWrapper.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 16/5/2023.
//

import SwiftUI

struct CheckoutViewControllerWrapper: UIViewControllerRepresentable {
    let login: String
    func makeUIViewController(context: Context) -> CheckoutViewController {
        return CheckoutViewController(login : login)
        
    }
    
    func updateUIViewController(_ uiViewController: CheckoutViewController, context: Context) {
        // Optional: Implement this method if you need to update the view controller
    }
}
struct CheckoutViewControllerWrapper_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutViewControllerWrapper(login:"" )
    }
}
