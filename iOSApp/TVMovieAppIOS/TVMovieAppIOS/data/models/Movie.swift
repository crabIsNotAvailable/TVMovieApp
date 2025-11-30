import Foundation

struct MovieListItem: Identifiable, Hashable {
    let id: String          // use remoteId as identity
    let title: String
    let imageUrl: String
    let feedId: String
    let urlPath: String

    init(
        id: String,
        title: String,
        imageUrl: String,
        feedId: String,
        urlPath: String
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.feedId = feedId
        self.urlPath = urlPath
    }
}
