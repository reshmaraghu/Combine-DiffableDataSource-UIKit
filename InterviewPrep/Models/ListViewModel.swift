//
//  ListViewModel.swift
//  InterviewPrep
//
//  Created by Raghu, Reshma L on 11/02/21.
//
import UIKit
import Combine

struct Metadata: Decodable {
    let total_hits: Int
    
    enum CodingKeys: String, CodingKey {
        case total_hits
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_hits = try values.decode(Int.self, forKey: .total_hits)
    }
}

struct Link: Decodable {
    let rel: String
    let prompt: String
    let href: String
    
    enum CodingKeys: String, CodingKey {
        case rel
        case prompt
        case href
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rel = try values.decode(String.self, forKey: .rel)
        prompt = try values.decode(String.self, forKey: .prompt)
        href = try values.decode(String.self, forKey: .href)
    }
}

struct Collection: Decodable {
    let metadata: Metadata
    let version: String
    let href: String
    let links: [Link]
    let items: [ImageModel]
    
    enum CodingKeys: String, CodingKey {
        case metadata
        case version
        case href
        case links
        case items
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        metadata = try values.decode(Metadata.self, forKey: .metadata)
        version = try values.decode(String.self, forKey: .version)
        href = try values.decode(String.self, forKey: .href)
        links = try values.decode([Link].self, forKey: .links)
        items = try values.decode([ImageModel].self, forKey: .items)
    }
}

struct Response: Decodable {
    let collection: Collection
    
    enum CodingKeys: String, CodingKey {
        case collection
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        collection = try values.decode(Collection.self, forKey: .collection)
    }
}

class ListViewModel {
    var cancellables: Set<AnyCancellable> = []
    @Published var keyWordSearch: String = ""
    let serviceProvider = Service.sharedInstance
    var diffableDataSource: TableViewDiffableDataSource!
    var snapshot = NSDiffableDataSourceSnapshot<String?, ImageModel>()
    
    init() {
        $keyWordSearch
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { (_) in
                self.fetchImages()
            }.store(in: &cancellables)
    }
        
    func fetchImages() {
        serviceProvider.fetchImages(for: keyWordSearch) { (results) in
            guard self.diffableDataSource != nil else { return }
                        
            self.snapshot.deleteAllItems()
            self.snapshot.appendSections([""])
                        
            if results.isEmpty {
                self.diffableDataSource.apply(self.snapshot, animatingDifferences: true)
                return
            }
                    
            self.snapshot.appendItems(results, toSection: "")
            self.diffableDataSource.apply(self.snapshot, animatingDifferences: true)
        }
    }
}
