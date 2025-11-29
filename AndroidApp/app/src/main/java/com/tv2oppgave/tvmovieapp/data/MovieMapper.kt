package com.tv2oppgave.tvmovieapp.data

import com.tv2oppgave.tvmovieapp.data.models.FeedContentItem
import com.tv2oppgave.tvmovieapp.data.models.FeedItemEntity
import com.tv2oppgave.tvmovieapp.data.models.MovieDetailResponse
import com.tv2oppgave.tvmovieapp.data.models.MovieListItem

fun FeedContentItem.toEntity(feedId: String): FeedItemEntity {
    return FeedItemEntity(
        id = this.id,
        title = this.title,
        imageSrc = this.imageUrl,
        urlPath = this.urlPath,
        feedId = feedId,
        rawJson = null
    )
}

fun FeedItemEntity.toDomain(): MovieListItem =
    MovieListItem(
        id = this.id,
        title = this.title,
        imageUrl = this.imageSrc,
        urlPath = this.urlPath
    )

fun MovieDetailResponse.toDomain(): MovieDetailUiModel =
    MovieDetailUiModel(
        id = this.id ?: "",
        title = this.title ?: "",
        description = this.description ?: "",
        durationMinutes = this.durationMinutes,
        posterUrl = this.posterUrl,
        year = this.year,
        ageRating = this.ageRating,
        genres = this.genres,
        cast = this.cast
    )

data class MovieDetailUiModel(
    val id: String,
    val title: String,
    val description: String,
    val durationMinutes: Int?,
    val posterUrl: String?,
    val year: Int?,
    val ageRating: String?,
    val genres: List<String>,
    val cast: List<String>
)