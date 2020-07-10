# Leal iOS Technical Test
### By: Juan Felipe Méndez

## Running the app

1. Make sure that the propper versions of Xcode [11.5] and Carthage [0.35] are installed
2. There are two ways to install third-party libraries:
    * Running ```./setup.sh```: 
        - Shell file created to install the libraries if the correct versions of Xcode and Carthage are installed. 
        - Go to the repo's root directory ```leal-ios-technical-test``` and run ```./setup.sh``` in the terminal. 
        - If ```zsh: permission denied: ./setup.sh``` appears, run ```chmod +x ./setup.sh``` and then rerun ```setup.sh```.
    * Runninng ```carthage update```:
        - Go to the repo's root directory ```leal-ios-technical-test``` and run ```carthage update``` in the terminal.
3. Open ```leal-ios-technical-test.xcodeproj``` and execute the app on a simulator or physical device.

**Note:** If running on a physical device, make sure iOS version is above 13.5


## App Workflow

The app is basically embedded in a navigation controller. The first view is a "login" screen, where a user can be selected, or all the users.

After selecting a user, a TableView is displayed with all the relevant transactions. Transactions can be deleted and reloaded. If a transaction is clicked, the transaction information is showned in a new View. The transaction is also read.

Transactions can only be reloaded if one or more are deleted or read.

Finally, if the the menu button is clicked, a sidebar is displayed and the selected user can be changed. In other words, the app takes you back to the "login" view.

Unit tests where made to test the API requests to the server and can be found in the ```leal-ios-UnitTests``` folder`.

## Proposed Architecture

Following Apple Developer Guidelines, the MVC design pattern was used. Within the app, the delegate pattern was also included.

### Models

A ```codable struct``` was created, for each of the relevant schemas in the API. Taking into advantage the ```codable``` protocol to read ```JSON``` .

Besides this, the ```DataManager.swift``` file is in charge of all the API requests. However, the controllers which make API requests must conform to the ```DataDelegate``` protocol. The protocol consists on two functions, which handle the data from the request or possible errors.

### Controllers

Each View has its own controller. They handle the communication between the View and the Model. All controllers make API requests except ```SidebarViewController.swift```, which is in charged of displaying the Sidebar and "logging out".

### Views

Foe this proyect, the UI was designed with Interface Builder in the ```Main.storyboard```. Some additional files are included, like ```TransactionCell.xib``` to build the transaction cells and ```CustomCardView.swift```, which is used a super class to create a card-like effect in the Transaction Information View.

### Other files

In the folder ```Constants and Extensions``` there are 2 files: ```Constants.swift``` and ```Extensions.swift```. The first one stores all the constants used acrossed the app and the second one different extensions to ```Foundation``` classes and ``ÙIKit`` classes.

## Third Party Libraries

As specified in the **Runnning the App** section, the package manager used for the project was Carthage.

The only library used in the project is [Realm](https://realm.io/docs/swift/latest). It was used to handle transactions local storage, as part of the extra points. The benefits of realm over other solutions such as ```CoreData``` is spead and ease of use. The cons is that the library is mantained by someone else and that version control is required.

On the other hand querying is really simple with the use of the right predicates and CRUD operations are easily and organically implmented. However, the use of ```@objc dynamic var``` and structrues such as ```Result<T>``` makes compatibility with the ```codable``` protocol harder.

## Local Storage

Given that local storage was implemented, the strategy to handle it was cache rollback to network. Therefore, if there isn't any data stored locally, the app will fetch from the network. Nevertheless, afterwards, it is always asumed that transactions are stored locally (after loading from network).

If the app rollbacks to network, the transactions are stored locally, otherwise, transactions are always accessed locally.

## Extra points

✅ Cache all transactions

✅ Animations when deleting transactions and loading data in general

✅ Unit tests for the ```DataManager``` and API fetches

❌ Show list of comments related to each transactions

## Doubts or Questions

If there are any doubts or questions, don't hesitate to contact me via e-mail.
