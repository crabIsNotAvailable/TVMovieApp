package com.tv2oppgave.tvmovieapp.data.models

data class MovieDetailResponse(
    val id: String? = null,
    val title: String? = null,
    val description: String? = null,
    val durationMinutes: Int? = null,
    val posterUrl: String? = null,
    val year: Int? = null,
    val ageRating: String? = null,
    val genres: List<String> = emptyList(),
    val cast: List<String> = emptyList()
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