import CoreData

extension CDMovie {

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
