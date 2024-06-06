# Ignacio Arias - 2024,Jun 5.

- *thecatapi endpoint was used
- here's a short public video on youtube about it: https://youtube.com/shorts/yD92e3y4N3M
- original link of the thecatapi: https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t

## Application Architecture Overview:

The application follows the **MVVM (Model-View-ViewModel)** architecture pattern:

- **Views:** Handle the UI and user interactions. Observe changes in the ViewModel.
- **ViewModels:** Manage data logic and interact with Models.
- **Models:** Represent domain-specific data and business logic.
- **API Services:** Perform network operations, following protocol-based design.

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

## Code Review and Recommendations:

### Code Organization:

- **API Key Exposure:** The API key would be moved to a mid point proxy from a regular server so is not exposed to the repo, is hardcoded for ease of the interview avoding the set up of the server.
 
- **Error Handling:** Add more robust error handling for network calls and data decoding.
- **Pagination Logic:** Refactor for improved clarity and efficiency.

### Performance Considerations:

- **Image Loading:** Is optimized with Kingfisher's image caching.
- **Concurrency:**  `@MainActor`  is used for safe MainThread updates.

## Unit Testing Strategy:

### ViewModel Testing:

- Mock `APIProtocol` for testing.
- Test pagination logic and data loading.

### API Service Testing:

- Test URL construction and response handling.

### View Testing:

- Test loading states, error views, and navigation in `ContentView`.
