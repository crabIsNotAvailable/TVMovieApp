package com.tv2oppgave.tvmovieapp.data.models
import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.TypeConverters
import com.google.gson.annotations.SerializedName
data class RootFeedResponse(
    val layout: String?,
    val feeds: List<Feed> = emptyList()
)

data class Feed(
    val id: String,
    val title: String,
    val section_title: String?,
    val type: String?,
    val styles: FeedStyles? = null,
    val content: List<FeedContentItem> = emptyList()
)

data class FeedStyles(
    val layout: FeedLayout? = null,
    val theme: FeedTheme? = null
)

data class FeedLayout(
    val name: String? = null,
    val text: String? = null
)

data class FeedTheme(
    val name: String? = null
)

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
