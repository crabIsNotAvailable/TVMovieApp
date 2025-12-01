package com.tv2oppgave.tvmovieapp.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.tv2oppgave.tvmovieapp.data.models.FeedItemEntity

@Dao
interface MovieDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(items: List<FeedItemEntity>)

    @Query("SELECT * FROM feed_items WHERE feedId = :feedId")
    suspend fun getByFeedId(feedId: String): List<FeedItemEntity>

    @Query("SELECT * FROM feed_items WHERE content_id = :id LIMIT 1")
    suspend fun getById(id: String): FeedItemEntity?

    @Query("DELETE FROM feed_items")
    suspend fun clearAll()
}