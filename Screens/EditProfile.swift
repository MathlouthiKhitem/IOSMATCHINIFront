//
//  EditProfile.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 29/3/2023.
//

import SwiftUI



struct EditProfile: View {
    let login: String

    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var age: String = ""
    @State var numero: String = ""
    @State var sexe: String = ""
    @State var aboutYou: String = ""
    @State var job: String = ""
    @State var school: String = ""
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var showAdditionalFields = false
   


    var body: some View {
        ZStack(alignment:.center) {
          
            Text("").font(.largeTitle)
                .padding(.bottom,450.0)
                .foregroundColor(.red)
                .font(.largeTitle)
                .fontWeight(.bold)
                .bold()
                .background(Image("login").padding(.top,20.0))
            
            Spacer()
           
            VStack() {
                
                    
                  
                if !showAdditionalFields{
                   
                    Button(action: {
                        self.isShowingImagePicker = true
                    }) {
                        Image(uiImage: selectedImage ?? UIImage(named: "user")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 290, height: 190)
                            .clipShape(Circle())
                            .padding(.top, -130)
                            
                    }
                    .foregroundColor(.clear)
                    .background(Color.clear)
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(image: self.$selectedImage)
                    }
                
                    TextField("firstName", text: $firstName)
                        .padding(.leading)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.09))
                        .cornerRadius(50)
                        .padding(.top, 70)
                    
                    TextField("lastName", text: $lastName)
                        .padding(.leading)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.09))
                        .cornerRadius(50)
                    
                    TextField("numero", text: $numero)
                        .padding(.leading)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.09))
                        .cornerRadius(50)
                        .keyboardType(.numberPad)
                    TextField("Age", text: $age)
                        .padding(.leading)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.09))
                        .cornerRadius(50)
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        showAdditionalFields.toggle()
                    }) {
                        Text("Next")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color(red: 0.94, green: 0.393, blue: 0.408))
                            .cornerRadius(50)
                            .padding(.top, 40)
                    }
                }
                     else   if showAdditionalFields {
                       
                         Text("Edit Profile").font(.largeTitle)
                             //.padding(.bottom,450.0)
                             .foregroundColor(.red)
                             .font(.largeTitle)
                             .fontWeight(.bold)
                             .bold()
                            TextField("Sexe", text: $sexe)
                                .padding(.leading)
                                .frame(width: 300, height: 50)
                                .background(Color.black.opacity(0.09))
                                .cornerRadius(50)

                            TextField("About You", text: $aboutYou)
                                .padding(.leading)
                                .frame(width: 300, height: 50)
                                .background(Color.black.opacity(0.09))
                                .cornerRadius(50)

                            TextField("Job", text: $job)
                                .padding(.leading)
                                .frame(width: 300, height: 50)
                                .background(Color.black.opacity(0.09))
                                .cornerRadius(50)

                            TextField("School", text: $school)
                                .padding(.leading)
                                .frame(width: 300, height: 50)
                                .background(Color.black.opacity(0.09))
                                .cornerRadius(50)

                            Button(action: {
                                updateUserProfile()
                            }) {
                                Text("Edit")
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 50)
                                    .background(Color(red: 0.94, green: 0.393, blue: 0.408))
                                    .cornerRadius(50)
                                    .padding(.top, 40)
                            }
                        } else {
                            
                        }
                    }
            }
        
            .padding()
            .navigationTitle("Edit Profile")
        }
    func updateUserProfile() {
        let url = URL(string: "http://localhost:9090/user/modifier/\(login)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        let lineBreak = "\r\n"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var bodyData = Data()
//        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
//        bodyData.append("Content-Disposition: form-data; name=\"login\"\(lineBreak + lineBreak)".data(using: .utf8)!);
//        bodyData.append(login.data(using: .utf8)! )
//        bodyData.append(lineBreak.data(using: .utf8)!)
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"FirstName\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(firstName.data(using: .utf8)!)
        bodyData.append(lineBreak.data(using: .utf8)!)
        
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"LasteName\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(lastName.data(using: .utf8)!)
        bodyData.append(lineBreak.data(using: .utf8)!)
        
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"Age\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(age.data(using: .utf8)!)
        bodyData.append(lineBreak.data(using: .utf8)!)
        
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"Numero\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(numero.data(using: .utf8)!)
        bodyData.append(lineBreak.data(using: .utf8)!)
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"Sexe\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(sexe.data(using: .utf8)!)
        bodyData.append(lineBreak.data(using: .utf8)!)
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"AboutYou\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(aboutYou.data(using: .utf8)!)
        bodyData.append(lineBreak.data(using: .utf8)!)
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"Job\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(job.data(using: .utf8)!)
        bodyData.append(lineBreak.data(using: .utf8)!)
        bodyData.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"School\"\(lineBreak + lineBreak)".data(using: .utf8)!);
        bodyData.append(school.data(using: .utf8)!)
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
    
//    func updateUserProfile(firstName:String,LasteName:String,Age:String,Numero:String,Sexe:String,AboutYou:String,Job:String,School:String) {
//        let url = URL(string: "http://localhost:9090/user/modifier")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: Any] = [
//            "login" :login.self,
//            "FirstName": firstName,
//            "LasteName":lastName,
//            "Age": age,
//            "Numero": numero,
//            "Sexe":  sexe,
//            "AboutYou": aboutYou,
//            "Job": job,
//            "School": school
//        ]
//        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "Unknown error")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode == 200 {
//                    print("Password reset successfully")
//                } else {
//                    print("Password reset failed with status code \(httpResponse.statusCode)")
//                }
//            }
//
//        }.resume()
//     }
}
       
struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile(login: "");
    }
}
