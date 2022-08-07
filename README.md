# Marvel

## The Task
Create an app using an API that you find interesting.
If you're having difficulties finding an API, take a look at https://github.com/public-apis/
public-apis/blob/master/README.md.
Use the best engineering practices wherever you can. You should be looking to demonstrate
the following values:
• performance
• readability
• maintainability
• testability
• scalability
• simplicity
Keep a clear separation of concerns within your app - use your preferred pattern for this.
Or...
If you already have an open-sourced app or library that you think sufficiently demonstrates
the
values above, you can share that with us instead.


## The Approach
This follows the MVVM-C approach making very light use of combine for view model bindings.

### Application
- AppAssembly holds common app system services which are injected into classes which require them.

### Business Logic
- The JSON Rest API is implemented using Codable.
- The data services provide concrete data providers which can be substituted out for unit tests and UI Tests. By using app environment variables this config can be changed at XCUITest launch application. 
- The MarvelAPI encapsulates the requests and build up which is required to make a url request
- MarvelContentService provides a clean content fetch API. This class handles data decoding.

### UI
- Contains the bare bones of which could grow into a design library

### Module - The only feature module in this example project
- XXXViewModel - Binds a viewstate to the UIViewController which indicates which order to present the data.  
- XXXViewController - This file and it's accompanying views need little explanation. 
- XXXFlow - A simple protocol a screens and be reused and tested.
- Coordinator - It's job is a tie screens together and orchestrate navigation.

### Tests
- Unit test suites are written to show how one would complete the unit testing of a service.
- XXXViewModelTests, highlights the benefit of the architecture to show how easy it is to unit test the viewmodel logic. 

### Other
I used  [Swift Lint](https://github.com/realm/SwiftLint/) to make the code more consistent:
