package com.tv2oppgave.tvmovieapp.data

import androidx.room.TypeConverter
import com.google.gson.Gson
import com.tv2oppgave.tvmovieapp.data.models.MovieImages

class Converters {
    private val gson = Gson()

    @TypeConverter
    fun fromMovieImages(value: MovieImages?): String? = value?.let { gson.toJson(it) }

    @TypeConverter
    fun toMovieImages(value: String?): MovieImages? =
        value?.let { gson.fromJson(it, MovieImages::class.java) }

    @TypeConverter
    fun fromMap(value: Map<String, Any>?): String? = value?.let { gson.toJson(it) }

    @TypeConverter
    fun toMap(value: String?): Map<String, Any>? =
        value?.let { gson.fromJson(it, Map::class.java) as? Map<String, Any> }
}