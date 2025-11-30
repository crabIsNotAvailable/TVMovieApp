import CoreData

extension CDMovie {

    // Core Data → UI model
    func toDomain() -> MovieListItem {
        MovieListItem(
            id: remoteId ?? "",
            title: title ?? "",
            imageUrl: imageUrl ?? "",
            feedId: feedId ?? "",
            urlPath: urlPath ?? ""
        )
    }
}
