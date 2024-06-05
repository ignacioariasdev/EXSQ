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
    func updateList(page: Int) async throws
//    func didDisplayedLastItem(item: SpecificType) async throws
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

    init(api: ProtocolType) {
        self.api = api
        Task {
            try await updateList()
        }
    }

    func fetchData(page: Int) async throws -> [Model] {
        return try await api.decodeFromAPI(page: page)
    }

    @MainActor
    func updateList(page: Int = 1) async throws {
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
            do {
                print("waiting for updatedList \(currentPage)")
                try await updateList(page: currentPage)
            } catch {
                print("error UpdateList Error: \(error.localizedDescription)")
            }
        }
    }

    func getImageUrl(from urlString: String) throws -> URL {
        guard let url = URL(string: urlString), ["http", "https"].contains(url.scheme) else {
            throw ViewModelError.invalidUrl
        }
        return url
    }




}
