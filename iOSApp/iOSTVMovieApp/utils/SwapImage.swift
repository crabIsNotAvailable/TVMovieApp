import Foundation

func toMovieImage(_ url: String, type: String = "landscape") -> String {
    var base = url
    var params: [String: String] = [:]

    // If URL has ?, split normally
    if let idx = url.firstIndex(of: "?") {
        base = String(url[..<idx])
        let query = String(url[url.index(after: idx)...])
        for part in query.split(separator: "&") {
            let kv = part.split(separator: "=")
            if kv.count == 2 {
                params[String(kv[0])] = String(kv[1])
            }
        }
    }

    // Apply Android logic exactly
    if type == "poster" {
        params["location"] = "moviePoster"
        params["width"] = "600"
        params["height"] = "900"
    } else {
        params["location"] = "list"
        params["width"] = "1920"
        params["height"] = "1080"
    }

    // Build query
    let query = params
        .map { "\($0)=\($1)" }
        .joined(separator: "&")

    return "\(base)?\(query)"
}
