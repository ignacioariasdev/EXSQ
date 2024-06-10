# Cat Breeds App – MVVM Architecture with Protocol-Oriented Networking

By Ignacio Arias – June 5, 2024

[YouTube Overview of the App](https://youtube.com/shorts/yD92e3y4N3M) | [API Documentation](https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t)

## Project Overview

This iOS application showcases a curated list of cat breeds, fetched from a remote API and presented with smooth pagination and detailed views. The project emphasizes a clean **MVVM** architecture, protocol-oriented network interactions, and performance optimizations for a seamless user experience.

## Key Features & Technologies

- **Architecture**:
  - **MVVM (Model-View-ViewModel)**: Decouples UI (Views), data logic (ViewModels), and data models (Models).
  - **Protocol-Oriented Networking**: Uses protocols to define API contracts, enhancing testability and flexibility.
  
- **UI**:
  - **SwiftUI**: Modern declarative UI framework.
  - **NavigationStack**: Hierarchical navigation for smooth transitions.
  - **Kingfisher**: High-performance image loading and caching.

- **Network**:
  - **URLSession**: Foundation's networking framework.
  - **JSONDecoder**: Swift's built-in JSON parsing.

- **Data**:
  - **Pagination**: Efficiently loads data in chunks to optimize performance.
  - **Concurrency**: `@MainActor` annotation ensures safe UI updates on the main thread.

## Application Architecture

+--------------------+      +--------------------+       +-------------+
|       View        | ---> |     ViewModel      | ----> |    Model    |
+--------------------+      +--------------------+       +-------------+
     (ContentView)             (ObservableObject)           (CatBreed)
          ^                           |
          |                           |
          |                      +-------------+
          |                      |   API       |
          +----------------------+ (Protocol)  |
                                 +-------------+ 
                                 
                                 


- **Views:** SwiftUI views (`ContentView`, `Dashboard`, `DetailsView`) responsible for rendering UI elements and handling user interactions.
- **ViewModel:** An `ObservableObject` that fetches, manages, and provides data to the views. It implements the `FetchablePagination` protocol for pagination logic.
- **Model:** Represents a single cat breed (`CatBreed` struct) with its properties (name, description, images, etc.).
- **API:** Protocol (`APIProtocol`) defining the interface for network requests. The concrete implementation (`API`) handles URLSession interactions and JSON decoding.

## Detailed Component Description: 
### `ContentView`:

- Root view displaying a list of cat breeds.
- Uses `NavigationStack` for hierarchical navigation.
- Dynamically loads images and data with pagination.

### `Dashboard`:

- Subview of `ContentView`, displaying a single cat breed.
- Loads images with `KFImage` from the Kingfisher library with cache optimization.

### `DetailsView`:

- Shows detailed information about a cat breed.

### `ViewModel`:

- Implements `FetchablePagination` protocol for data fetching.
- Holds an array of `Model` objects (`listMain`).
- Communicates with the API service.

### `API`:

- Implements `APIProtocol` for network logic.
- Handles URL construction and network responses.


## Interaction Flow:

1. App initializes API and ViewModel.
2. `ContentView` loads with the injected `ViewModel`.
3. Scrolling fetches and displays more data dynamically.
4. Selecting a breed navigates to `DetailsView`.


## Flow Diagram

```mermaid
graph TD;
  A[App Launch] --> B[ContentView Load]
  B --> C[ViewModel Init]
  C --> D[API Fetch Initial Data]
  D --> |Success| E[Display Breeds]
  D --> |Error| F[Display Error]
  E --> G[User Scrolls]
  G --> H[Reach Pagination Threshold]
  H --> D
  E --> I[User Taps Breed]
  I --> J[DetailsView Load]

