# Questions:

### What is a RESTful interface? When do you use it? What are its characteristics?
It's a software architectural pattern that is used for designing client to server communications. A RESTful interface is used when a client (computer) needs to request or post information to a webserver. The main methods a client can send to a webserver are GET/PUT/POST/DELETE. These methods correspond with "CRUD" methods for traditional databases. Create-POST, GET-Read, Update-PUT, Delete-DELETE.

### What is the difference between POST and PUT?
POST: Create (each time creates a new record). Post ALWAYS creates a new item.
PUT: Update (Don’t confuse this with POST), to a specific record id, replacing the data for that record.

### How does the record ID work in Firebase? Why does it take two steps to save a record (first POST then PUT) in our app? Why does the FirebaseItem protocol even exist?
The record ID is randomly generated when a POST request is made. It takes two steps to save a record (first POST then PUT) in our app because when we send the POST initially, we do not know the record ID ahead of time. Firebase will send the record ID back to us after the POST request, which we handle with another PUT request, saving the record ID locally and putting it back to Firebase.

### Explain what a generic type is and what advantages it offers.
A generic type allows you to specify all of the requirement of a type without needing to explicitly state it. It's like a placeholder. It promotes code reusability.

### What does a URLRequest do? When do you need one and when can you just use a URL?
 Definition via Apple: A URL load request that is independent of protocol or URL scheme. URLRequest encapsulates two basic data elements of a load request: the URL to load, and the policy to use when consulting the URL content cache made available by the implementation. This type serves only to encapsulate information about a URL request. You must use other classes such as URLSession to send these requests to a server.

 I think you can use URL when you are making simple GET requests. For more complicated RESTful requests, I think it is standard to use URLRequest.

### What is the role of a URL session? How does it work?
Definition via Apple: It provides an API for downloading content. An object that coordinates a group of related network data transfer tasks. With the URLSession API, your app creates one or more sessions, each of which coordinates a group of related data transfer tasks. For example, if you’re creating a web browser, your app might create one session per tab or window, or one session for interactive use and another for background downloads. Within each session, your app adds a series of tasks, each of which represents a request for a specific URL (following HTTP redirects, if necessary).

URLSession has a singleton shared session (which has no configuration object) for basic requests. It’s not as customizable as sessions you create, but it serves as a good starting point if you have very limited requirements. You access this session by calling the shared class method. For other kinds of sessions, you instantiate a URLSession with one of three kinds of configurations:

### What are completion handlers? Why use completion handlers? What advantages do they provide?
 You use completion handlers when you don't know how long a data task is going to take. They allow you to specify what to do when you get a request finishes. The advantage is the data request can take a significantly variable amount of time and yet the completion closure will still work.

### Explain at least three strategies that promote code reuse that we used in today's project
1. We used code reuse in the Firebase network controller class. That class has everything we need to make network calls no matter what the specific.
2. We also used a generic type, that would potentially allow us to use the network class with multiple data types.
3. We used the PUT method as a completion handler to the POST method, allowing us to not have to rewrite the PUT method within the POST method.
