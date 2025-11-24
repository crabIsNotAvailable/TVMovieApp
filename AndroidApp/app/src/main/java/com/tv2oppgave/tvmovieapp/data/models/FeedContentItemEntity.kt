package com.tv2oppgave.tvmovieapp.data.models

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;
import androidx.room.TypeConverters;
import com.tv2oppgave.tvmovieapp.data.Converters

@Entity(tableName = "feed_items")
data class FeedContentItemEntity(
    @PrimaryKey
    @ColumnInfo(name = "content_id")
    val id: String,
    val title: String,
    val imageSrc: String?,
    val urlPath: String?,
    val feedId: String?,
    val rawJson: String?
)

data class MovieListItem(
    val id: String,
    val title: String,
    val imageUrl: String?,
    val urlPath: String?
)