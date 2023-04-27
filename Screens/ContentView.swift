//
//  ContentView.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 27/4/2023.
//



import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Image("left_arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        .padding(.bottom, 10)

                    Image("dummy_person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 69)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 7) {
                        Text("username")
                            .font(.italic(.title2)())
                            .frame(width: 160, height: 20, alignment: .leading)
                            .padding(.leading, 8)
                            .padding(.top, 10)

                        Text("Typing........")
                            .font(.system(size: 12))
                            .frame(width: 100, height: 20, alignment: .leading)
                            .padding(.leading, 8)
                            .opacity(0)
                    }
                    .frame(width: 188, height: 78, alignment: .leading)
                    .padding(.trailing, 10)
                }
                .frame(height: 78)
                .background(Color.white)

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<10) { index in
                            Text("Row \(index)")
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.gray.opacity(0.1))
                        }
                    }
                }
                .background(Color.white)
                .padding(.horizontal, 8)
                .padding(.bottom, 14)

                HStack(spacing: 0) {
                    TextField("send message..", text: .constant(""))
                        .frame(width: 347, height: 57)
                        .padding(.leading, 15)
                        .padding(.top, 3)
                        .padding(.trailing, 10)
                        .padding(.bottom, 5)
                        .background(
                            Image("chat_edittext_bg")
                                .resizable()
                                .scaledToFill()
                        )

                    Image("icone_solutions_8")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 46, height: 55)
                        .padding(.trailing, 8)
                        .padding(.bottom, 16)
                }
                .frame(height: 57)
                .background(Color.white)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
