//
//  ImageModel.swift
//  InterviewPrep
//
//  Created by Raghu, Reshma L on 10/02/21.
//

import Foundation

struct ImageData: Decodable {
    var keywords: [String]
    var title: String
    var date_created: String
    var description: String
    var nasa_id: String
    
    enum CodingKeys: String, CodingKey {
        case keywords, title, date_created, description, nasa_id
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        keywords = try values.decode([String].self, forKey: .keywords)
        title = try values.decode(String.self, forKey: .title)
        date_created = try values.decode(String.self, forKey: .date_created)
        description = try values.decode(String.self, forKey: .description)
        nasa_id = try values.decode(String.self, forKey: .nasa_id)
    }
}

struct ImageLink: Decodable {
    let render: String
    let href: String
    let rel: String
    
    enum CodingKeys: String, CodingKey {
        case render, href, rel
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        render = try values.decode(String.self, forKey: .render)
        href = try values.decode(String.self, forKey: .href)
        rel = try values.decode(String.self, forKey: .rel)
    }
}

struct ImageModel: Decodable, Hashable {

    var id = UUID()
    var data: [ImageData]
    var href: String
    var links: [ImageLink]
    
    enum CodingKeys: String, CodingKey {
        case data, href, links
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decode([ImageData].self, forKey: .data)
        href = try values.decode(String.self, forKey: .href)
        links = try values.decode([ImageLink].self, forKey: .links)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        return lhs.id == rhs.id
    }
}
