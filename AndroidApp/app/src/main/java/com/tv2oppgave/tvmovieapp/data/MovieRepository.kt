package com.tv2oppgave.tvmovieapp.data
import android.content.Context
import android.util.Log
import androidx.room.Room
import com.tv2oppgave.tvmovieapp.data.models.MovieListItem
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object MovieRepository {

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
            .baseUrl("http://10.0.2.2:8080/")
            .addConverterFactory(GsonConverterFactory.create())
            .build()

    private val movieApi = retrofit.create(MovieService::class.java)


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

        val cached = movieDao.getByFeedId(feedId).map { it.toDomain() }
        emit(cached)

        try {
            val response = movieApi.getMoviesInFeed(feedId)

            val entities = response.movies.map { it.toEntity(feedId) }

            movieDao.insertAll(entities)

            emit(entities.map { it.toDomain() })

        } catch (e: Exception) {
            Log.e("MovieRepository", "Network error", e)
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
