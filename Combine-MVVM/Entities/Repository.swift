//
//  Repo.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 09/07/2021.
//
import UIKit

struct User: Decodable {
    var id: Int64?
    var login: String?
    var avatarUrl: URL?
}

struct Repository: Decodable {
    var id: Int?
    var updatedAt: Date?
    var createdAt: Date?
    var name: String?
    var description: String?
    var fullName: String?
    var htmlUrl: String?
    var stargazersCount: Int?
    var forks: Int?
    var language: String?
    var owner: User?
}

extension Repository: Equatable, Identifiable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Repository: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(fullName)
    }
}
