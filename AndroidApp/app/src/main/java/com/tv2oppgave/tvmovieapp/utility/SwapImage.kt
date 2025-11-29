package com.tv2oppgave.tvmovieapp.utility


fun SwapImage(url: String?, type: String = "landscape"): String {
    if (url.isNullOrBlank()) return ""

    val split = url.split("?")
    val base = split[0]
    val query = split.getOrNull(1).orEmpty()

    val params = mutableMapOf<String, String>()

    query.split("&").forEach { part ->
        val kv = part.split("=")
        if (kv.size == 2) {
            val key = kv[0]
            val value = kv[1]
            params[key] = value
        }
    }

    if (type == "poster") {
        params["location"] = "moviePoster"
        params["width"] = "600"
        params["height"] = "900"
    } else {
        params["location"] = "list"
        params["width"] = "960"
        params["height"] = "540"
    }

    val newQuery = params.entries.joinToString("&") { "${it.key}=${it.value}" }

    return "$base?$newQuery"
}
