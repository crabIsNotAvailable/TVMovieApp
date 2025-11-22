package com.tv2oppgave.tvmovieapp.data

import com.tv2oppgave.tvmovieapp.data.models.FeedContentItem
import com.tv2oppgave.tvmovieapp.data.models.FeedResponse
import com.tv2oppgave.tvmovieapp.data.models.MovieDetailResponse
import com.tv2oppgave.tvmovieapp.data.models.RootFeedResponse
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Path

interface MovieService {
    //Gets movies from tv2 api
    @GET("movies/feeds")
    suspend fun getAllFeeds(): RootFeedResponse

    @GET("api/movies/feed/id/{feedId}")
    suspend fun getMoviesInFeed(@Path("feedId") feedId: String): FeedResponse

    @GET("api/movies/detail/{urlPath}")
    suspend fun getMovieDetail(
        @Path("urlPath", encoded = true) urlPath: String
    ): MovieDetailResponse

}