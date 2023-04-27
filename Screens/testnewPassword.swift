//
//  testnewPassword.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 28/3/2023.
//

import SwiftUI

struct testnewPassword: View {
    @State var login: String = ""
    @State var password: String = ""
    func resetPassword(login: String, password: String) {
        let url = URL(string: "http://localhost:9090/user/restorPassword")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "login": login,
          "password": password
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Password reset successfully")
                } else {
                    print("Password reset failed with status code \(httpResponse.statusCode)")
                }
            }
            
        }.resume()
    }
    var body: some View {
        VStack {
            TextField("Login", text: $login)
            SecureField("Password", text: $password)
            Button(action: {
                resetPassword(login: login, password: password)
            }) {
                Text("Reset Password")
            }
        }
    }
    
  
   
}


struct testnewPassword_Previews: PreviewProvider {
    static var previews: some View {
        testnewPassword()
    }
}

