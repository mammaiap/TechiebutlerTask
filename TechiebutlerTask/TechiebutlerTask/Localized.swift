//
//  Localized.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation

final class Localized {
    static var bundle: Bundle {
        Bundle(for: Localized.self)
    }
}

extension Localized {
    enum Post {
        static var table: String { "Post" }

        static var listViewtitle: String {
            NSLocalizedString(
                "text.postlistview.title",
                tableName: table,
                bundle: bundle,
                comment: "Title for the Post List view")
        }

        static var loadError: String {
            NSLocalizedString(
                "text.post.connection.error",
                tableName: table,
                bundle: bundle,
                comment: "Error message displayed when we can't load the post from the server")
        }
        
        static var detailViewTitle: String {
            NSLocalizedString(
                "text.postdetailview.title",
                tableName: table,
                bundle: bundle,
                comment: "Title for the Post Detail view")
        }
        
    }
}
