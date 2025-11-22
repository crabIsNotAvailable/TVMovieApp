package com.tv2oppgave.tvmovieapp.data

import com.google.gson.Gson
import com.tv2oppgave.tvmovieapp.data.models.FeedContentItem
import com.tv2oppgave.tvmovieapp.data.models.FeedContentItemEntity
import com.tv2oppgave.tvmovieapp.data.models.MovieDetailResponse
import com.tv2oppgave.tvmovieapp.data.models.MovieListItem

fun FeedContentItem.toEntity(feedId: String): FeedContentItemEntity {
    return FeedContentItemEntity(
        id = this.id,
        title = this.title,
        imageSrc = this.imageUrl,
        urlPath = this.urlPath,
        feedId = feedId,
        rawJson = null
    )
}

fun FeedContentItemEntity.toDomain(): MovieListItem =
    MovieListItem(
        id = this.id,
        title = this.title,
        imageUrl = this.imageSrc,
        urlPath = this.urlPath
    )

fun MovieDetailResponse.toDomain(): MovieDetailUiModel =
    MovieDetailUiModel(
        title = this.title,
        description = this.description,
        durationSeconds = this.duration ?: 0,
        posterSrc = this.images?.poster?.src,
        coverSrc = this.images?.cover?.src
    )

data class MovieDetailUiModel(
    val title: String?,
    val description: String?,
    val durationSeconds: Int,
    val posterSrc: String?,
    val coverSrc: String?
)