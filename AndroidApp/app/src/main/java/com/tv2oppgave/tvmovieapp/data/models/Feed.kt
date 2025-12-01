package com.tv2oppgave.tvmovieapp.data.models

data class FeedContentItem(
    val id: String,
    val title: String,
    val imageUrl: String?,
    val urlPath: String
)

data class FeedResponse(
    val id: String,
    val title: String,
    val section_title: String,
    val movies: List<FeedContentItem>
)
