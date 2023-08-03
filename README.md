
![Simulator Screen Recording - iPhone 14 Pro - 2023-08-03 at 18 33 12](https://github.com/dkeso611/OmadaHealthAssessment/assets/10858068/bc3a52ec-2f3e-4cc2-9c46-8f5b0a1d8b1f)

# Movie Search App

Please build project as normal.
 - OR - 
See `ListView` preview for live, mock and failing states.

No 3rd party libraries were used.
Tests are included.


## Architectural Approach

I took the architectural approach of using Model-View-ViewModel (MVVM) architecture combined with a style of Protocol-Oriented Programming (POP) using Protocol witnesses for flexibility and simplification. MVVM  promotes a clear separation of concerns and facilitates a more organized codebase. It helps in decoupling the user interface/view logic from the data and business logic, and the underlying data and models. Structuring the code this way makes it easier to maintain and extend the application. Additionally, MVVM aligns very well with SwiftUI's data-binding capabilities, making it a great fit for handling UI state changes

I leveraged the power of Swift's POP by utilizing protocol witnesses. Instead of explicitly defining protocols, I use protocol witnesses to provide concrete implementations for the required methods and properties, making them more flexible, reusable and easier to test. 

For example, The factory methods `mock` and `failing` have been implemented as protocol witnesses for the MoviesAPIService. They provide an efficient and flexible way to create different variations of the MoviesAPIService, enabling testing for a wide range of scenarios, including success cases, edge cases, and error handling without relying on actual network requests. The mock method simulates the behavior of the actual service, while the failing method allows testing error handling and resilience by throwing simulated errors. This also allows for the app to be tested completely offline.

I incorporated dependency injection to achieve more flexibility and modularity in the codebase. By using dependency injection, I am able to decouple components and manage their dependencies from outside the class, making it easier to swap implementations and improve testability.

## Trade offs

1.  The MVVM architecture combined with Protocol witnesses, introduces additional layers of abstraction and increased complexity. However, this approach offers the benefit of a well-organized codebase with clear separation of concerns.

2.  Protocol witnesses can make code more concise and flexible, but it may relatively reduce readability if engineers are not familiar with this paradigm
    
3.  Protocol witnesses can present a learning curve for developers who are not familiar with this approach or Swift's advanced features.
    
4.  Though protocol witnesses enhances flexibility by using dynamic dispatch to select the appropriate method implementation at runtime, it might introduce a slight performance overhead compared to statically dispatched code. In certain scenarios, explicit protocols may be a better choice for performance

5.  Dividing the UI into `ListViewContainer` and `ListView` decouples the list view from the list view model. This makes testing the UI much easier. The `ListView` can be tested with mock TMDBItemViewModel data without having to provide a ListViewModel or creating mock `Movie` objects. However, this increases complexity by adding another UI layer.

6.  I have chosen to inject ItemService directly into the SearchListViewModel, this would allow reuse of the view model for other service such as TV Series instead of Movies. It adds an additional layer of abstraction to promote code modularity and reusability.

    
Despite these trade-offs, I believe that adopting the MVVM architecture and protocol witness approach in this project provides a solid foundation for creating a scalable, maintainable, and testable iOS application. It allows for clear separation of concerns and provides a systematic way to handle user interface interactions and data flow. Additionally, the use of protocol witnesses enhances reusability and modularity in the codebase.
