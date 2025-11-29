package com.tv2oppgave.tvmovieapp.data.models

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity(tableName = "feed_items")
data class FeedItemEntity(
    @PrimaryKey
    @ColumnInfo(name = "content_id")
    val id: String,
    val title: String,
    val imageSrc: String?,
    val urlPath: String,
    val feedId: String?,
    val rawJson: String?
)
