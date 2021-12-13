# GBM Code Challenge

## How to install:

Download the project and open GBMCodeChallenge.xcodeproj file.

If connected, select your iPhone device before run or one of the simulators.

Click on **Run** button


## How it Works:

GBMCodeChallenge is an app developed with **VIPER** architecture. It shows a Login screen that works inly with TouchID or FaceID, devices without one of those features are not supported. After a successful login, the app shows a graph and a row with IPC records.

If you select a record from the list, you can see an indicator line in the graph that shows the position of that record.

All the information is obtained through a web service on Internet, with JSON format and is reloaded every 10 seconds automatically.
The structure of the App includes a **Networking** layer wich works hand to hand with VIPER layers (Interactor, Presenter, Router, Entity and View)


## Unit Test

This App incluides **Test** classes for Network, Interactor and Presenter layers, using only for this purpose a **mocked response** in the Network layer, allowing to realize the test faster, avoiding server response delays.


## Screenshots


 **Login Screen**
 
 ![Simulator Screen Shot - iPhone 12 - 2021-12-13 at 05 00 23](https://user-images.githubusercontent.com/12451529/145801360-d35ba00a-6c40-4f5d-a6d1-cb312b98651a.png)

 **Dashboard Screen**
 
![Simulator Screen Shot - iPhone 12 - 2021-12-13 at 05 01 05](https://user-images.githubusercontent.com/12451529/145801415-c358989e-045b-4fb6-a170-31b39b7112a7.png)


