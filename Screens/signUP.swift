//
//  ContentView.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 9/3/2023.
//

import SwiftUI
import CoreData

struct signup: View {
    @State var login : String = ""
    @State private var password: String =  ""
    @State private var confirmpassword:String =  ""
    @State private var age: String =  ""
    @State private var wrongemail: Float = 0
    @State private var wrongpassword: Float  = 0
    @State private var wrongage: Float  = 0
    @State private var showingLoginScreen = false
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isLoading = false
    @State private var passwordsMatch = true
    @State private var errorMessage: String? =  ""
    
    func test() {
        let url = URL(string: "http://localhost:9090/user/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        let lineBreak = "\r\n"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var bodyData = Data()
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"login\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(login.data(using: .utf8)! )
        bodyData.append(lineBreak.data(using: .utf8)!)
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"password\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(password.data(using: .utf8)!)
        bodyData.append(lineBreak.data(using: .utf8)!)
        
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"Age\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(age.data(using: .utf8)!)
        bodyData.append(lineBreak.data(using: .utf8)!)
        
        if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.5) {
            bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"Image\"; filename=\"image.jpg\"\(lineBreak)".data(using: .utf8)!)
            bodyData.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
            bodyData.append(imageData)
            bodyData.append(lineBreak.data(using: .utf8)!)
        }
        
        bodyData.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if response.statusCode == 200 {
                print("User signed up successfully")
            } else {
                print("Error: \(response.statusCode)")
            }
        }
        task.resume()
        
        
    }
    var body: some View {
        NavigationView {
        ZStack(alignment:.center) {
            Text("").font(.largeTitle)
                .padding(.bottom,380.0)
                .foregroundColor(.red)
                .font(.largeTitle)
                .fontWeight(.bold)
                .bold()
                .background(Image("login").padding(.bottom,180.0))
            
            VStack {
                
                Button(action: {
                    self.isShowingImagePicker = true
                }) {
                    Image(uiImage: selectedImage ?? UIImage(named: "user")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 290, height: 190)
                        .clipShape(Circle())
                        .padding(.bottom, 750)
                }
                .foregroundColor(.clear)
                .background(Color.clear)
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(image: self.$selectedImage)
                }
            }
            
            VStack(){
                
                TextField(" Email", text:  $login)
                    .padding(.leading)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.09))
                    .keyboardType(.emailAddress)
                    .cornerRadius(50)
                    .border(.red, width: CGFloat(wrongemail))
                Text(errorMessage ?? "")
                    .padding(.horizontal,-130)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
                //                     var loginerror=Text("")
                //                        .padding(.horizontal,-130)
                //                        .font(.system(size: 10))
                //                        .foregroundColor(Color.red)
                //                    loginerror
                SecureField("Password", text: $password)
                    .padding(.leading)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.09))
                    .cornerRadius(50)
                Text(errorMessage ?? "")
                    .padding(.horizontal,-130)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
                //                     var passworderror=Text("")
                //                        .padding(.horizontal,-130)
                //                        .font(.system(size: 10))
                //                        .foregroundColor(Color.red)
                //                    passworderror
                SecureField("Confirm Password", text: $confirmpassword)
                    .padding(.leading)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.09))
                    .cornerRadius(50)
                
                Text(errorMessage ?? "")
                    .padding(.horizontal,-130)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
                
                
                TextField("Age", text: $age)
                    .padding(.leading)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.09))
                    .cornerRadius(50)
                    .keyboardType(.numberPad)
                    .border(.red, width: CGFloat(wrongage))
                Text(errorMessage ?? "")
                    .padding(.horizontal,-130)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
                //                     var ageerror=Text("")
                //                        .padding(.horizontal,-130)
                //                        .font(.system(size: 20))
                //                        .foregroundColor(Color.red)
                //                    ageerror
                Button(action: {
                    if login.isEmpty || password.isEmpty || confirmpassword.isEmpty || age.isEmpty || password != confirmpassword {
                        errorMessage = "Please check again !!"
                    } else {
                        test()
                        
                       
                        
                    }
                }, label: {
                    Text("Sign Up")
                    
                })
                
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color(red: 0.94, green: 0.393, blue: 0.408))
                .cornerRadius(50)
                .padding(.top,100)
                
                
            }
            VStack(spacing: 10) {
                Text("Already have an account?").foregroundColor(Color.black.opacity(0.5))
                    .padding(.top, 200)
                    .onTapGesture {
                        print("The text was clicked!")
                        if let presentingViewController = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
                            presentingViewController.dismiss(animated: true) {
                                let secondView = matchinii.login()
                                let hostingController = UIHostingController(rootView: secondView)
                                UIApplication.shared.windows.first?.rootViewController?.present(hostingController, animated: true, completion: nil)
                            }
                        }
//                        else {
//                            let secondView = matchinii.login()
//                            let hostingController = UIHostingController(rootView: secondView)
//                            UIApplication.shared.windows.first?.rootViewController?.present(hostingController, animated: true, completion: nil)
//                        }
                    }
            }
        }.padding(.top,200)
        
    }
    }
}
struct signup_Previews: PreviewProvider {
    static var previews: some View {
        signup();
    }
}

