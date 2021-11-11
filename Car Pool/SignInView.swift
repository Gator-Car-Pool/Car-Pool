//
//  SignInView.swift
//  Car Pool
//
//  Created by Brandon Tran on 11/9/21.
//

import SwiftUI
import Firebase

// Singleton obj to allow us to do stuff in the preview
class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    // Singleton obj
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}

struct SignInView: View {
    
    // By default, user will be on sign up page
    @State var isSignedIn = false
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    Picker(selection: $isSignedIn, label: Text("Picker")) {
                        Text("Sign in")
                            // True tag = show this when isSignedIn is true
                            .tag(true)
                        Text("Sign up")
                            // False tag = show this when isSignedIn is false
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    // Only allow users to choose a profile pic if they're signing up
                    if !isSignedIn {
                        // Choose profile pic button
                        Button(action: {
                            shouldShowImagePicker.toggle()
                        }, label: {
                            
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128, alignment: .center)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        // Black if light mode, white if dark mode
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64) .stroke(Color(.label), lineWidth: 3))
                        })
                    }
                    
                    Group {
                        // UF email address
                        TextField("Email", text: $email)
                            // Comes with convenient @ symbol
                            .keyboardType(.emailAddress)
                            // Eww auto correct,
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        SecureField("Password", text:    $password)
                        
                    }
                    .padding(12)
                    .background(Color.white)

                    // Sign in / Sign up button
                    Button(action: {
                       handleAction()
                    }, label: {
                        HStack {
                            Spacer()
                            Text(isSignedIn ? "Sign in" : "Sign up")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                    })
                    
                    Text(self.signInStatusMessage)
                        .foregroundColor(.orange)
                    
                }
                .padding()
            }
            // ? = ternary operator (basically if else), if isSignedIn is true -> Sign in, else Sign up
            .navigationTitle(isSignedIn ? "Sign in" : "Sign up")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
    
    @State var image: UIImage?
    
    // Function that handles the sign in / create new account
    private func handleAction() {
        if isSignedIn {
            signInUser()
        } else {
            signUpUser()
            
        }
    }
    
    // Function for signing in
    private func signInUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to sign in user: ", err)
                self.signInStatusMessage = "Failed to sign in user: \(err)"
                return
            }
            
            print("Successfully signed in as user: \(result?.user.uid ?? "")")
            
            self.signInStatusMessage = "Successfully signed in as user: \(result?.user.uid ?? "")"
        }
    }
    
    @State var signInStatusMessage = ""
    
    // Function for signing up
    private func signUpUser() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user: ", err)
                self.signInStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.signInStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            
            self.storeImage()
        }
    }
    
    private func storeImage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.signInStatusMessage = "Failed to store image: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.signInStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.signInStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString)
                
                // Optional binding
                guard let url = url else { return }
                self.storeUserInfo(profilePicUrl: url)
            }
        }
    }
    
    private func storeUserInfo(profilePicUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profilePicUrl": profilePicUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.signInStatusMessage = "\(err)"
                    return
                }
                
                print("Success")
            }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .preferredColorScheme(.light)
    }
}