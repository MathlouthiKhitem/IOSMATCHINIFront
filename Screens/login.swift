//
//  ContentView.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 9/3/2023.
//

import SwiftUI
import CoreData

//import MyIntent


struct login: View {
     @State var login : String = ""
      @State private var password: String = ""
       @State var isLoggingIn = false
       @State var errorMessage = ""
      @State private var wrongUsername: Float = 0
      @State private var wrongPassword: Float  = 0
      @State private var showingLoginScreen = false
    @State var navigationSelection: String? = nil

    @State private var isRobot = false

    @State private var isLinkActive = false


    @State private var isLoggedIn = false


  

    func test2() {
        isLoggedIn = true

          let url = URL(string: "http://localhost:9090/user/login")!
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")

          let parameters: [String: Any] = [
              "login": login,
              "password": password
          ]

          request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

          let session = URLSession.shared
          let task = session.dataTask(with: request) { data, response, error in
              if let data = data {
                  let response = try? JSONDecoder().decode(LoginResponse.self, from: data)
                  if let response = response {
                      if response.success {
                          print("test")
                        isLinkActive = true
                      } else {
                          // handle failed login
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
    struct CheckboxToggleStyle: ToggleStyle {
        @State private var showAlert = false
        let login: String
        func makeBody(configuration: Configuration) -> some View {
            let isOnBinding = Binding(
                      get: { configuration.isOn },
                      set: { newValue in
                          if newValue {
                              // Check if login exists in shared preferences
                              let defaults = UserDefaults.standard
                              if defaults.string(forKey: "login") != nil {
                                  showAlert = true
                              } else {
                                  // Save login to shared preferences
                                  defaults.set(login, forKey: "login")
                                  configuration.isOn = newValue
                                  
                              }
                          } else {
                              configuration.isOn = newValue
                          }
                      }
                  )
                  
            
            return Button(action: {
                isOnBinding.wrappedValue.toggle()
            }) {
                HStack {
                    Image(systemName: isOnBinding.wrappedValue ? "checkmark.square" : "square")
                        .foregroundColor(isOnBinding.wrappedValue ? .accentColor : .secondary)
                    configuration.label
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login already exists"),
                    message: Text("Please log out of the existing session before logging in again."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    var body: some View {
        
        NavigationView {

        ZStack(alignment:.center) {
            
            
            Text("Login").font(.largeTitle)
                .padding(.bottom,450.0)
                .foregroundColor(.red)
                .font(.largeTitle)
                .fontWeight(.bold)
                .bold()
                .background(Image("login").padding(.top,20.0))
            
            VStack( spacing: 31.0 ){
                
             
                TextField(" Username", text:$login)
                    .padding(.leading)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.09))
                    .cornerRadius(50)
                    .border(.red, width: CGFloat(wrongUsername))
                SecureField("Password", text: $password)
                    .padding(.leading)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.09))
                    .cornerRadius(50)
                    .border(.red, width: CGFloat(wrongPassword))
                
                VStack {
                    // your existing view code here
                    
                    Button("Login", action:{
                        
                        isLoggingIn = true
                       
                        test2()
                        navigationSelection = login
                        print("........ login",navigationSelection)
                    })
                    .disabled(login.isEmpty || password.isEmpty || isLoggingIn)
                    .opacity(login.isEmpty || password.isEmpty || isLoggingIn ? 0.5 : 1)
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color(red: 0.94, green: 0.393, blue: 0.408))
                    .cornerRadius(50)
                    .padding(.top, 50)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                   
                        NavigationLink(destination: matche(login: login),tag: login, selection: $navigationSelection) {
                            EmptyView()
                        }
                   

                   
                  

                }
                Toggle(isOn: $isRobot) {
                    Text("Remember me")
                        .foregroundColor(.pink)
                    }
          
                .toggleStyle(CheckboxToggleStyle(login:login))
                VStack(  spacing: 10){
                    
                    Text("Forgot Password ? ").foregroundColor(Color.black.opacity(0.5))
                        .onTapGesture {
                            print("The text was clicked!")
                            let secondView = matchinii.forget()
                            let hostingController = UIHostingController(rootView: secondView)
                            UIApplication.shared.windows.first?.rootViewController?.present(
                                hostingController, animated: true, completion: nil)
                            
                        }
                    Text("You don't have ann accountt ?").foregroundColor(Color.black.opacity(0.5))
                        .onTapGesture {
                            print("The text was clicked!")
                            let secondView = matchinii.signup()
                            let hostingController = UIHostingController(rootView: secondView)
                            UIApplication.shared.windows.first?.rootViewController?.present(
                                hostingController, animated: true, completion: nil)
                            
                        }
                 

                    
                    
                }
              
                
                
                
            }.padding(.top,100)
            
            
            
        }
    }
    }
        
    }



struct LoginResponse: Decodable {
    let success: Bool
}
struct login_Previews: PreviewProvider {
    static var previews: some View {
        login()
    }
}
