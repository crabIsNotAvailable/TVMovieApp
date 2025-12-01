package com.tv2oppgave.tvmovieapp.data

import com.tv2oppgave.tvmovieapp.data.models.FeedResponse
import com.tv2oppgave.tvmovieapp.data.models.MovieDetailResponse
import retrofit2.http.GET
import retrofit2.http.Path

interface MovieService {

    @GET("api/movies/feed/id/{feedId}")
    suspend fun getMoviesInFeed(@Path("feedId") feedId: String): FeedResponse

    @GET("api/movies/detail/{urlPath}")
    suspend fun getMovieDetail(
        @Path("urlPath", encoded = true) urlPath: String
    ): MovieDetailResponse

}