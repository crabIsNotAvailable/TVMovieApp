package com.tv2oppgave.tvmovieapp.data

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.tv2oppgave.tvmovieapp.data.models.FeedContentItemEntity

@Database(
    entities = [FeedContentItemEntity::class],
    version = 2,
    exportSchema = false
)
@TypeConverters(Converters::class)
abstract class MovieDatabase : RoomDatabase() {
    abstract fun feedItemDao(): MovieDao
}