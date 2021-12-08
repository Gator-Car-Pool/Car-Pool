import SwiftUI
import Firebase

// By default, user will be on sign up page
struct SignInView: View {
    @State var isSignedIn = false
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    @State var pushActive = false
    @StateObject var user = User()
    @State var display = true;
    @State var auth = false
    
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

                        if auth == true {
                            NavigationLink(destination:
                                            FloatingTabBar().environmentObject(user),
                                           isActive: self.$pushActive) {
                                Loader()
                            }.hidden()

                        }
                    }
                    .padding()
                    .navigationBarHidden(true)
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationViewStyle(StackNavigationViewStyle())
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                }
                .overlay(
                    HStack {
                        Text(!isSignedIn ? "Already have an account? Tap" : "New user? Tap")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        Text(!isSignedIn ? "Sign back in" : "Create an account")
                            .fontWeight(.bold)
                            .foregroundColor(Color("Color"))
                    }
                    ,alignment: .bottom
                )
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    @State var image: UIImage?
    
    // Function that handles the sign in / create new account
    private func handleAction() {
        if isSignedIn {
            signInUser()
        } else {
            signUpUser()
            signInUser()
        }
    }
    
    // Function for signing in
    private func signInUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to sign in user: ", err)
                return
            }
            
            // getdata
            self.pushActive = true
            print("Successfully signed in as user: \(result?.user.uid ?? "")")
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
                        print("Good")
                    }
                }
                else {
                    print("Not Good")
                }
            }
        }
    }
    
    // Function for signing up
    private func signUpUser() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, err in
            
            if let err = err {
                print("Failed to create user: ", err)
                return
            }
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.storeImage()
        }
    }
    
    private func storeImage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
                    return
                }
                
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
                    return
                }
                print("Success")
            }
    }
    
    private func sendResetPasswordEmail() {
        FirebaseManager.shared.auth.sendPasswordReset(withEmail: email) { err in
            if let err = err {
                print(err)
                return
            } else {
                print("Success")
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .preferredColorScheme(.dark)
    }
}
