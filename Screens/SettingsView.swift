import SwiftUI

struct SettingsView: View {
    @State private var showMen: Bool = false
    @State private var showWomen: Bool = true
    @State private var agePreference: ClosedRange<Float> = 14...70
    @State private var receiveNewMatches: Bool = true
    @State private var receiveMessages: Bool = true
    @State private var receiveMessageLikes: Bool = true

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    CardView {
                        VStack(spacing: 10) {
                            Text("Show Me")
                                .font(.headline)
                                .foregroundColor(Color.red)

                            HStack {
                                Text("Men")
                                Spacer()
                                Toggle(isOn: $showMen) {
                                    Text("Switch")
                                }
                                .toggleStyle(CustomSwitchStyle())
                            }

                            HStack {
                                Text("Women")
                                Spacer()
                                Toggle(isOn: $showWomen) {
                                    Text("Switch")
                                }
                                .toggleStyle(CustomSwitchStyle())
                            }
                        }
                    }

                    CardView {
                        VStack(spacing: 10) {
                            Text("Age Preference")
                                .font(.headline)
                                .foregroundColor(Color.red)

                            Text("\(Int(agePreference.lowerBound)) - \(Int(agePreference.upperBound))")
                                .foregroundColor(Color.black)

                            Slider(value: $agePreference, in: 14...70, step: 1)
                        }
                    }

                    Text("App Setting")
                        .font(.headline)
                        .foregroundColor(Color.black)

                    CardView {
                        VStack(spacing: 10) {
                            Text("New matches")
                                .foregroundColor(Color.black)
                                .font(.headline)

                            Toggle("", isOn: $receiveNewMatches)
                                .labelsHidden()
                        }
                    }

                    CardView {
                        VStack(spacing: 10) {
                            Text("Message")
                                .foregroundColor(Color.black)
                                .font(.headline)

                            Toggle("", isOn: $receiveMessages)
                                .labelsHidden()
                        }
                    }

                    CardView {
                        VStack(spacing: 10) {
                            Text("Message Likes")
                                .foregroundColor(Color.black)
                                .font(.headline)

                            Toggle("", isOn: $receiveMessageLikes)
                                .labelsHidden()
                        }
                    }

                    Button(action: {
                        // Save button action
                    }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)
                    }

                    Button(action: {
                        // Delete account button action
                    }) {
                        Text("Delete Account")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)
                    }
                }
                .padding(10)
            }

            Button(action: {
                // Logout button action
            }) {
                Text("Logout")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(4)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
        }
    }
}

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 4)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            SettingsView()
                .navigationBarTitle("Settings")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomSwitchStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "ic_switch_select" : "ic_switch_unselect")
            .renderingMode(.template)
            .foregroundColor(configuration.isOn ? .green : .red)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}
