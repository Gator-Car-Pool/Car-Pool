//
//  SignInView.swift
//  Car Pool
//
//  Created by Brandon Tran on 11/9/21.
//

import SwiftUI
import Firebase

<<<<<<< Updated upstream
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

=======
>>>>>>> Stashed changes
struct SignInView: View {
    
    // By default, user will be on sign up page
    @State var isSignedIn = false
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    
<<<<<<< Updated upstream
=======
    @State var auth = false
        
>>>>>>> Stashed changes
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    
                    Picker(selection: $isSignedIn, label: Text("Picker")) {
                        Text("Sign back in")
                        // True tag = show this when isSignedIn is true
                            .tag(true)
                        Text("Create an account")
                        // False tag = show this when isSignedIn is false
                            .tag(false)
<<<<<<< Updated upstream
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
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .font(.system(size: 80))
                                        .padding()
                                        // Black if light mode, white if dark mode
                                        .foregroundColor(Color(.label))
                                }
                            }
                            //.overlay(RoundedRectangle(cornerRadius: 64) .stroke(Color(.label), lineWidth: 3))
                        })
=======
>>>>>>> Stashed changes
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    
                    Text(isSignedIn ? "Sign in" : "Sign up")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.textColor)
                    
                    // Letter spacing
                        .kerning(1.9)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 3)
                    
                    Text(isSignedIn ? "Welcome back! Sign back in with the email and password you used to create your account." : "Welcome! Create your account to get started.")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                        .padding(.bottom, 15)
                    
                    
                    VStack {
                        
                        /*Picker placement*/
                        
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
                                            .frame(width: 96, height: 96, alignment: .center)
                                            .cornerRadius(64)
                                    } else {
                                        // Image(systemName: "🐊")
                                        let gradient = RadialGradient(gradient: Gradient(colors: [.orange, .purple]), center: UnitPoint(x: 0.25, y: 0.25), startRadius: 0.2, endRadius: 200)
                                        Text("🐊")
                                            .font(.system(size: 75))
                                            .frame(width: 100, height: 100)
                                            .background(Circle()
                                                            .fill(gradient)
                                                            .frame(width: 140, height: 140, alignment: .center)
                                                        
                                                        //.overlay(Circle() .fill(Color.orange))
                                                        // Black if light mode, white if dark mode
                                                            .foregroundColor(Color(.label))
                                                        
                                            )
                                            .padding(.bottom, 23)
                                    }
                                    
                                    Text("Choose your profile picture")
                                        .foregroundColor(Color.gray)
                                    
                                }
                            })
                        }
                        
                        
                        
                        // Email and password
                        VStack(alignment: .leading, spacing: 8, content: {
                            Text("Email")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            TextField("Email", text: $email)
                            // Comes with convenient @ symbol
                                .keyboardType(.emailAddress)
                            // Eww auto correct,
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Theme.textColor)
                                .padding(.top, 5)
                            
                            Divider()
                            
                            Text(!isSignedIn ? "• Use UF email (@ufl.edu)" : "")
                                .foregroundColor(.gray)
                            
                        })
                            .padding(.top, 25)
                        
<<<<<<< Updated upstream
                        SecureField("Password", text:    $password)
                
                        
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(10)
            

                    // Sign in / Sign up button
                    Button(action: {
                       handleAction()
                    }, label: {
                        HStack {
                            Spacer()
                            Text(isSignedIn ? "Sign in" : "Sign up")
                                .foregroundColor(Color.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                            .cornerRadius(50)
                    })
                    
                    Text(self.signInStatusMessage)
                        .foregroundColor(.orange)
                        .font(.system(size: 18))
=======
                        VStack(alignment: .leading, spacing: 8, content: {
                            Text("Password")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            SecureField("Password", text: $password)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Theme.textColor)
                                .padding(.top, 5)
                            
                            Divider()
                            
                            Text(!isSignedIn ? "• Create a secure password" : "")
                                .foregroundColor(.gray)
                            
                        })
                            .padding(.top, 20)
                        
                        // Forgot password?
                        if isSignedIn {
                            Button(action:{ sendResetPasswordEmail() }, label: {
                                Text("Forgot password?")
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            })
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.top, 10)
                        }
                        
                        // Sign in/Sign up button
                        Button(action: {handleAction()}, label: {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("Color"))
                                .clipShape(Circle())
                            // Shadow
                                .shadow(color: .black.opacity(0.6), radius: 5, x: 0, y: 0)
                        })
                            .padding(.top, 10)
                        
                        
                        
                        //                    Group {
                        //                        // UF email address
                        //                        TextField("Email", text: $email)
                        //                            // Comes with convenient @ symbol
                        //                            .keyboardType(.emailAddress)
                        //                            // Eww auto correct,
                        //                            .autocapitalization(.none)
                        //                            .disableAutocorrection(true)
                        //
                        //                        SecureField("Password", text:    $password)
                        //                    }
                        //                    .padding(12)
                        //                    .background(Color.white)
                        //                    .cornerRadius(10)
                        //                    .foregroundColor(Color(.black))
                        
                        // Sign in / Sign up button
                        //                    Button(action: {
                        //                       handleAction()
                        //                    }, label: {
                        //                        HStack {
                        //                            Spacer()
                        //                            Text(isSignedIn ? "Sign in" : "Sign up")
                        //                                .foregroundColor(Color.white)
                        //                                .padding(.vertical, 10)
                        //                                .font(.system(size: 18, weight: .semibold))
                        //                            Spacer()
                        //                        }.background(Color.blue)
                        //                            .cornerRadius(50)
                        //                    })
                        //
                        //                    // Password reset button
                        //                    if isSignedIn {
                        //                        Button(action: {
                        //                           sendResetPasswordEmail()
                        //                        }, label: {
                        //                            HStack {
                        //                                Spacer()
                        //                                Text("Reset password")
                        //                                    .foregroundColor(Color.white)
                        //                                    .padding(.vertical, 10)
                        //                                    .font(.system(size: 18, weight: .semibold))
                        //                                Spacer()
                        //                            }.background(Color.blue)
                        //                                .cornerRadius(50)
                        //                        })
                        //                    }
                        
                        
                        Text(self.signInStatusMessage)
                            .foregroundColor(.orange)
                            .font(.system(size: 18))
                        if auth == true {
                            NavigationLink(destination:
                                            FloatingTabBar().environmentObject(user),
                                           isActive: self.$pushActive) {
                                Loader()
                            }.hidden()
                            
                        }
                    }
                    .padding()
>>>>>>> Stashed changes
                    
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationViewStyle(StackNavigationViewStyle())
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                }
                // FIXME: not signing in
                .overlay(
                    HStack {
                        Text(!isSignedIn ? "Already have an account? Tap" : "New user? Tap")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        //                Button(action: {}, label: {
                        Text(!isSignedIn ? "Sign back in" : "Create an account")
                            .fontWeight(.bold)
                            .foregroundColor(Color("Color"))
                        
                        //                })
                    }
                    ,alignment: .bottom
                )
                //        .padding()
                //        .padding(.top)
                //        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                //            ImagePicker(image: $image)
                //        }
            }
<<<<<<< Updated upstream
            // ? = ternary operator (basically if else), if isSignedIn is true -> Sign in, else Sign up
            .navigationTitle(isSignedIn ? "Sign in" : "Sign up")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
=======
            .navigationBarTitleDisplayMode(.inline)
            
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
            
            auth = true;
            let db = Firestore.firestore()


            db.collection("shares").getDocuments() { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot {
                        for doc in snapshot.documents{

                            
                            if doc.data()["uid"] as? String == result?.user.uid {
                                user.email = doc.data()["email"] as! String
                         
                            }

                        }
                        print("good")
                    }
                }
                else {

                }
            }
>>>>>>> Stashed changes

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
