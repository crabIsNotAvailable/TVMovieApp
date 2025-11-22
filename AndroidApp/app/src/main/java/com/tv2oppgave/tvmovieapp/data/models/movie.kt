package com.tv2oppgave.tvmovieapp.data.models


data class MovieDetailResponse(
    val title: String? = null,
    val description: String? = null,
    val duration: Int? = null, // seconds
    val url: String? = null,
    val images: MovieImages? = null,
    val metadata: Map<String, Any>? = null
)

data class MovieImages(
    val poster: MovieImageVariant? = null,
    val cover: MovieImageVariant? = null,
    val thumbs: List<MovieImageVariant>? = null
)

data class MovieImageVariant(
    val src: String? = null,
    val width: Int? = null,
    val height: Int? = null
)
