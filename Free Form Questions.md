# Free-form Questions

Don't copy paste. Answer in your own words. Answer thoughtfully and thoroughly.

## What is a RESTful interface? When do you use it? What are its characteristics?

It's an "software architectural style" that allows you to connect to web/cloud services. You use it to access something like a database to create, modify, or retrieve information, via the application that you would like to use, whether it's a offline-platform-native app or another web service. It has four characteristics, which are GET, POST, PUT, and DELETE. They obtain/retrieve, create/publish, update, and remove records respectively. 

## What is the difference between POST and PUT?

POST allows your to create unique records, and PUT is what's used to update existing records. You technically can't post the same thing twice, they have to vary in some way on some level, usually with a unique identifier. PUT could access the object via that identifier and update its other contents.

## How does the record ID work in Firebase? Why does it take two steps to save a record (first POST then PUT) in our app? Why does the FirebaseItem protocol even exist?

It sets an ID for each record that will be stored. It has to save the object and then update it with a record. The FirebaseItem protocol exists for the recordIdentifier and we use it in other files so that way we avoid accidentally omitting the record ID's. 

## Explain what a generic type is and what advantages it offers.

Generic types allow you to use your own types, as long as you can explain to the compiler what the requirements are. It's similar to type extensions, except that you're not building off an existing type and are creating your own.

[According to the Swift documentation](https://docs.swift.org/swift-book/LanguageGuide/Generics.html), one advantage that it offers is that you can create functions that don't need to be modified or limited to a certain type.

This helps comply with the DRY concept.

## What does a URLRequest do? When do you need one and when can you just use a URL?

URL only allows you to make GET requests, whereas URLRequest allows you to make PUSH, PUT, GET, and DELETE requests.

## What is the role of a URL session? How does it work?

Takes care of threading and queing and managing the data as the application is connected to the API, enabling the application to make changes.

## What are completion handlers? Why use completion handlers? What advantages do they provide?

Completion handlers let you do things after a task is complete, since the Firebase just worries about the database.

The completion handler allows you to wait until something is processed before executing something else.

This way the user isn't confused when the UI updates before actual changes are made 


## Explain at least three strategies that promote code reuse that we used in today's project

We used a Model to handle the data, the standard Firebase file for connecting to Firebase to make all sorts of requests, and the use of generics, as mentioned in the fourth question. Generics help us use many types without having to create multiple functions.