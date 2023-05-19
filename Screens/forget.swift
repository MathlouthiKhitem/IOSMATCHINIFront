//
//  forget.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 16/3/2023.
//

import SwiftUI
import Intents




struct forget: View {
    
   

    @State var login : String = ""
    @State var value : String = ""
    @State var newpassword : String = ""
    @State var text : String = ""
    @State var isLoggingIn = false
    @State private var isTextFieldVisible = false
    @State private var isShowingModal = false
    @State var texts: [String] = []
    @State var responseString: String = ""
    
    @State var reponse : String = ""

    func fogetemail() {
        let url = URL(string: "http://localhost:9090/user/forgot")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
              
        let parameters: [String: Any] = [
            "login": login.self,
        ]
              
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
              
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            // Convertir les données en chaîne
        
            if let data = data {
                
             let    responseString = String(data: data, encoding: .utf8)
//                print(responseString ?? "")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let value = json["value"] as? String {
                            self.value = value
                               isShowingModal = true
                            
                                                    print(value)
                            
                                                }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                let response = try?
                
                JSONDecoder().decode(LoginResponse.self,from:data)
                if let response = response {
                         
                    if response.success {
                      print (LoginResponse.self)

                    } else {
                        print("Erreur : \(error?.localizedDescription ?? "Aucune erreur disponible.")")
                    }
                } else {
                    // handle error decoding response
                }
            } else {
                // handle error making request
            }
        }
        task.resume()
    }
  
    var body: some View {
     
       
        ZStack(alignment:.center) {
            Text("Forget").font(.largeTitle)
                .padding(.bottom,450.0)
                .foregroundColor(.red)
                .font(.largeTitle)
                .fontWeight(.bold)
                .bold()
                .background(Image("login").padding(.top,20.0))
        
            VStack( spacing: 31.0 ){

                TextField(" Email", text:$login)
                    .padding(.leading)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.09))
                    .cornerRadius(50)
              
//                if isTextFieldVisible {
//                             TextField(" New Password", text:$text)
//                                 .padding(.leading)
//                                 .frame(width: 300, height: 50)
//                                 .background(Color.black.opacity(0.09))
//                                 .cornerRadius(50)
//                         }
                Button("Forget", action: {
                    fogetemail()
                                  // isTextFieldVisible = true
                    isShowingModal = true

                   
                               })
               
                    .disabled(login.isEmpty || isLoggingIn)
                                .opacity(login.isEmpty || isLoggingIn ? 0.5 : 1)
                            
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color(red: 0.94, green: 0.393, blue: 0.408))
                .cornerRadius(50)
                .padding(.top,50)
              
           
                
                
            }.padding(.top,100)
            
            if isShowingModal {
                ModalView(code: $text, isShowingModal: $isShowingModal, login :$login, value: $value, reponse : $reponse)
                            .frame(width: 350, height: 400)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                
                    }
            
            
        }
          
    }
        
    }

struct ModalView: View {
  
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

       @State private var showAlert = false
    
    @Binding var code: String
    @Binding var isShowingModal: Bool
    @State var isButton1Visible = true
       @State var isButton2Visible = false
   
    @Binding var login: String
    @Binding var value: String
    @State var isTextFiel2dVisible = true
    @State var isTextFiel1dVisible = false
    @Binding  var reponse: String
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
            Text("Verifivation Code")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.red)
                .fontWeight(.bold)
           
            if isTextFiel2dVisible {  TextField(" Entre Code", text: $code)
                    .padding(.leading)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.09))
                .cornerRadius(50)}
            
            if isTextFiel1dVisible {
                         TextField("New Password", text: $password)
                    .padding(.leading)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.09))
                    .cornerRadius(50)
                     }
            if isButton1Visible {
                Button("Verifee") {
                    if(code==value){
                        print(code==value)
                        isTextFiel1dVisible = true
                      isTextFiel2dVisible = false


                    }
                    isButton1Visible = false
                    isButton2Visible = true
                    
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color(red: 0.94, green: 0.393, blue: 0.408))
                .cornerRadius(50)
                .padding(.top,50)
                .padding()
            }
            if isButton2Visible {
                Button("New Password") {
                   
                               isButton1Visible = true
                               isButton2Visible = false
                    resetPassword(login: login, password: password)
                    DispatchQueue.main.async {

                                                           presentationMode.wrappedValue.dismiss()

                                                       }

                                        showAlert = true
                           } .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color(red: 0.94, green: 0.393, blue: 0.408))
                    .cornerRadius(50)
                    .padding(.top,50)
                    .padding()
                       }
        }.alert(isPresented: $showAlert) {
        Alert(
            
            title: Text("Success"),

            message: Text("Password reseted successfully"),

            dismissButton: .default(Text("OK")) {

                // Dismiss the current view and go back to the previous view

                presentationMode.wrappedValue.dismiss()

            }

        )

    }
    }
}


struct forget_Previews: PreviewProvider {
    static var previews: some View {
        forget()
    }
}
