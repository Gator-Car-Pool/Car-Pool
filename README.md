Original App Design Project - README
===

# Gator Carpool

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
1. [Video Walkthrough](#Video-Walkthrough)

## Overview
### Description
Allows University of Florida students to carpool with each other. After chatting, riders can request rides from drivers, and drivers can accept them.

### App Evaluation
- **Category:** Travel
- **Mobile:** This app will be developed for mobile (iOS first, maybe Android later)
- **Story:** After signing up, the user can see nearby users. If they designate themself as a driver, they will be shown riders and can accept ride requests. If they designate themself as a rider, they will be shown drivers and can request rides. After acceptance, the route to the rider will automatically be opened up in the driver's map app.
- **Market:** University of Florida students
- **Habit:** This app can be used as often or unoften as the user wants.
- **Scope:** We will implement the most essential features to make our app functional for University of Florida students.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [X] User can sign up/sign in
- [ ] UF emails only
- [X] Users can reset their passwords
- [ ] User can see nearby drivers/riders on mapview and tableview
- [ ] Tableview will update depending on if the user designates themself as a rider or driver
- [ ] Users will see table view cells with profile pictures, username, and the chat button
- [ ] Users can tap on the chat button and sort out the details like destination, how many riders, etc.
- [ ] Buttons above keyboard to request(for riders), accept(for drivers) and cancel
- [ ] After acceptance, drivers will be transferred to a map app and be shown a route to the rider
- [ ] Basic profile page with profile picture (that can be changed), username, and UF email used to sign up
- [ ] Work with at least one map app

**Optional Nice-to-have Stories**

- [ ] Work with user's preferred map app
- [ ] User profiles can be fully fleshed out with a short bio/interests/etc.

### 2. Screen Archetypes

* Login/Sign up screen
   * Upon opening, user can sign up with UF email, set up their username and change profile picture
* User will be shown the home screen
   * Map view showing their current location, a switch to designate if they're a driver/rider, tableview that shows riders/drivers in order by distance
   * Tableview will have cells with profile picture, username, and chat button
   * Once details are sorted in chat, rider can request/cancel, and drivers can accept/cancel
       * Drivers will be redirected to map app with route to rider if they accept
* Profile screen
    * Where users can change their profile picture
* Chat screen
    * Where users can chat and request/accept rides, keyboard will have two buttons above it to do so

### 3. Navigation

**Flow Navigation** (Screen to Screen)

* Login/Sign up screen
   * Editable profile screen (fill in username, UF email, and profile picture)
* Home screen
    * Profile button that will lead to profile screen so users can view/edit their profiles
* Chat screen
    * If driver -> Redirects to map app with route to rider

## Wireframes
Just a prototype :)
![](https://i.imgur.com/YGxPBew.jpg)


## Schema 
### Models
#### Post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | UserID      | String   | unique id for the user post (default field) |
   | profilePic        | File| image author |
   | profile Name         | String     | user name |
   | Phone       | String   | user phone number |
   | likesCount    | Number   | number of likes for user rides |
   | Car  Location   | String |  car location via gps|
   |  Model     | String | date when post is last updated (default field) |
   | Make     | String | date when post is last updated (default field) |


### Networking
#### List of network requests by screen
   - Sending request
      - (Read/GET) Query all posts where user is author
         ```swift
         let query = PFQuery(className:"Request")
         query.whereKey("userid", equalTo: currentUser)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let requests = requests {
               print("Successfully retrieved \(approval) request.")
           // TODO: Do something with requst...
            }
         }
         ```
      - (Create/POST) Create a new ride
         ```swift
         let car = PFQuery(className:"location")
         query.whereKey("car", equalTo: currentUserL:ocation)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let locations = locations {
               print("Successfully arrived \(approval).")
            }
         }
         ```
         
      - (Delete) Delete existing ride

         
      - (Create/POST) Create a new request

         ```swift
         let car = PFQuery(className:"requesting")
         query.whereKey("requests", equalTo: currentUserL:ocation)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let requesting = reuests {
               print("Successfully  \(approved).")
            }
         }
         ```
         
      - (Delete) Reject existing request


         ```swift
         let car = PFQuery(className:"reject")
         query.whereKey("car", equalTo: currentUserL:ocation)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let request_status = requests {
               print("Request \(rejection).")
            }
         }
         ```
         
   - Create Ride Stop Screen
      - (Create/POST) Create a new rating

         ```swift
         let car = PF[OST(className:"rating")
         POST.whereKey("car", equalTo: currentUserL:ocation)
         POST.order(byDescending: "createdAt")
         POST.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let locations = locations {
               print("rating  \(done).")
            }
         }
         ```
         
   - Profile Screen
      - (Read/GET) Query logged in user object

         ```swift
         let car = PFQuery(className:"location")
         query.whereKey("car", equalTo: currentUserL:ocation)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let locations = locations {
               print("Successfully arrived \(approval).")
            }
         }
         ```
         
      - (Update/PUT) Update user profile image


         
      -  (Read/GET) Query if user on app.
          ```swift
         let car = PFQuery(className:"location")
         query.whereKey("car", equalTo: currentUserL:ocation)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let locations = locations {
               print("Successfully arrived \(approval).")
            }
         }
         ```
         
      - (Update/PUT) Update user activity.
        
## Video Walkthrough

Sign up / Sign in

<img src='https://github.com/Gator-Car-Pool/Car-Pool/blob/master/Sign%20in%20:%20Sign%20up.gif?raw=true' title='Video Walkthrough' width='320px' alt='Video Walkthrough' />

         
         
         
