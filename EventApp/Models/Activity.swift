//
//  Activity.swift
//  EventApp
//
//  Created by Daniel Xu on 1/3/25.
//

import Foundation
import FirebaseFirestore

struct Activity: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var location: String
    var date: String
    var description: String
}
