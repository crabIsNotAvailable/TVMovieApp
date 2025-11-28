package com.tv2oppgave.tvmovieapp.data
import android.content.Context
import android.util.Log
import androidx.room.Room
import com.tv2oppgave.tvmovieapp.data.models.FeedResponse
import com.tv2oppgave.tvmovieapp.data.models.MovieListItem
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

/**
 * MovieRepository
 * - Fetches feed lists and movie details from your .NET backend API
 * - Caches list items in Room
 * - Returns flows for reactive UI updates
 */
object MovieRepository {

    // ---------------------------
    // HTTP CLIENT + RETROFIT
    // ---------------------------

    private val httpClient =
        OkHttpClient.Builder()
            .addInterceptor(
                HttpLoggingInterceptor()
                    .setLevel(HttpLoggingInterceptor.Level.BODY)
            )
            .build()

    private val retrofit =
        Retrofit.Builder()
            .client(httpClient)
            .baseUrl("http://10.0.2.2:8080/") // Android → Windows backend
            .addConverterFactory(GsonConverterFactory.create())
            .build()

    private val movieApi = retrofit.create(MovieService::class.java)

    // ---------------------------
    // ROOM DATABASE
    // ---------------------------

    private lateinit var movieDatabase: MovieDatabase
    private val movieDao by lazy { movieDatabase.feedItemDao() }

    fun initializeDatabase(context: Context) {
        movieDatabase = Room.databaseBuilder(
            context,
            MovieDatabase::class.java,
            "movie-database"
        ).fallbackToDestructiveMigration().build()
    }


    fun getFeedMovies(feedId: String): Flow<List<MovieListItem>> = flow {

        // 1. Emit cached immediately
        val cached = movieDao.getByFeedId(feedId).map { it.toDomain() }
        emit(cached)

        try {
            // 2. Fetch from server (returns FeedResponse)
            val response = movieApi.getMoviesInFeed(feedId)

            // 3. Convert movies → Room entities
            val entities = response.movies.map { it.toEntity(feedId) }

            // 4. Store in DB
            movieDao.insertAll(entities)

            // 5. Emit fresh data
            emit(entities.map { it.toDomain() })

        } catch (e: Exception) {
            Log.e("MovieRepository", "Network error", e)
            // Keep showing cached version
        }

    }.flowOn(Dispatchers.IO)



    suspend fun getMovieDetail(urlPath: String): MovieDetailUiModel? {
        return try {
            movieApi.getMovieDetail(urlPath).toDomain()
        } catch (e: Exception) {
            Log.e("MovieRepository", "Failed to fetch movie", e)
            null
        }
    }
}
