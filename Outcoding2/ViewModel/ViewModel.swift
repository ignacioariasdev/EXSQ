//
//  ViewModel.swift
//  Outcoding2
//
//  Created by Ignacio Arias on 2024-06-03.
//

import Foundation

protocol FetchablePagination: ObservableObject {
    associatedtype GeneralType
    associatedtype SpecificType
    associatedtype ProtocolType

    var currentPage: Int { get set }
    var listMain: [GeneralType] { get set }
    var api: ProtocolType { get }

    func fetchData(page: Int) async throws -> [GeneralType]
    func updateList(page: Int) async
    func didDisplayedLastItem(item: GeneralType) async throws

    func getImageUrl(from urlString: String) throws -> URL
}

enum ViewModelError: Error {
    case invalidUrl
}

class ViewModel: FetchablePagination {
    typealias GeneralType = Model
    typealias SpecificType = ModelResults
    typealias ProtocolType = APIProtocol

    var currentPage: Int = 1
    @Published var listMain: [GeneralType] = []
    var api: ProtocolType
    @Published var anyError: String = ""
    @Published var httpStatusCode: Int = 0  // To store the HTTP status code

    init(api: ProtocolType) {
        self.api = api
        Task {
            await updateList()
        }
    }

    func fetchData(page: Int) async throws -> [Model] {
        do {
            return try await api.decodeFromAPI(page: page)
        } catch let apiError as APIError {
            switch apiError {
            case .invalidDecoding(let statusCode, let error):
                DispatchQueue.main.async {
                    self.httpStatusCode = statusCode
                    self.anyError = "Error \(statusCode): \(error.localizedDescription)"
                }
            default:
                DispatchQueue.main.async {
                    self.anyError = apiError.localizedDescription
                }
            }
            throw apiError
        } catch {
            DispatchQueue.main.async {
                self.anyError = error.localizedDescription
            }
            throw error
        }
    }

    @MainActor
    func updateList(page: Int = 1) async {
        print("page: \(page)")
        do {
            let seq = try await fetchData(page: page)
            print(seq.count)
            return listMain.append(contentsOf: seq)
        } catch {
            print("error UpdateList Error: \(error.localizedDescription)")
        }
    }

    func didDisplayedLastItem(item: GeneralType) async throws {
        print("is it the last item?")

        if listMain.last == item {
            print("Page incremented")
            currentPage += 1
            print("waiting for updatedList \(currentPage)")
            await updateList(page: currentPage)
        }
    }

    func getImageUrl(from urlString: String) throws -> URL {
        guard let url = URL(string: urlString), ["http", "https"].contains(url.scheme) else {
            throw ViewModelError.invalidUrl
        }
        return url
    }
}
