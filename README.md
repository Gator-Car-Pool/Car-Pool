Original App Design Project - README
===

# Gator Carpool

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)

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

* User can sign up/sign in
* User can see nearby drivers/riders on mapview and tableview
* Tableview will update depending on if the user designates themself as a rider or driver
    * Users will see table view cells with profile pictures, username, and the chat button
* Users can tap on the chat button and sort out the details like destination, how many riders, etc.
* Buttons above keyboard to request(for riders), accept(for drivers) and cancel
* After acceptance, drivers will be transferred to a map app and be shown a route to the rider
* Basic profile page with profile picture (that can be changed), username, and UF email used to sign up
* Work with at least one map app

**Optional Nice-to-have Stories**

* Work with user's preferred map app
* User profiles can be fully fleshed out with a short bio/interests/etc.

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
