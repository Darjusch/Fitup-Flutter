# Fitup

Make yourself accountable by betting on your habits.

## Screenshots


### Authentication

https://user-images.githubusercontent.com/32839416/165077750-08b800e8-74c6-49b8-8762-b838b123df9b.mov

### Create Bet

https://user-images.githubusercontent.com/32839416/165076554-b696cd1b-bd2b-4919-bf35-c50268d551d7.mov

### Profile

https://user-images.githubusercontent.com/32839416/165077113-cb5042d7-1f52-4336-95c5-59e2d7e96958.mov





## Features

## Getting started

For the firebase connection you need to request the API Key from me.
Alternativly you can setup your own: https://firebase.google.com/docs/flutter/setup?platform=android

Requirements:
Flutter, Dart

Clone the repository

``` git clone https://github.com/Darjusch/Fitup-Flutter.git ```

In the root folder of the repository:

``` flutter pub get ```

then connect your device and you are ready to go.

## Architecture
![Screenshot 2022-04-30 at 22 10 25](https://user-images.githubusercontent.com/32839416/166121142-df79390d-c4b6-4c94-badc-9b9d719ded26.png)


![Screenshot 2022-04-25 at 10 55 12](https://user-images.githubusercontent.com/32839416/165055488-7e8b652f-8e41-4e51-93fb-54363ab1e473.png)
- assets/ -> images and icons used by the app
- test/ -> unit tests
- integration_tests -> integration tests

![Screenshot 2022-04-25 at 10 55 33](https://user-images.githubusercontent.com/32839416/165055556-b6d4d8a0-813a-40ce-8b4a-f5e41d6c4bcb.png)

### In the Lib folder:
- apis -> firebase api
- controller -> reusable logic in helper files
- models -> data models
- providers -> statemanagement files
- screens -> UI of the screens
- widgets -> reusable widgets
- unused -> code that will be used in the future


