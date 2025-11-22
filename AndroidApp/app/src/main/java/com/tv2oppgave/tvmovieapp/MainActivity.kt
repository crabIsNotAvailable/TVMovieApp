package com.tv2oppgave.tvmovieapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import androidx.lifecycle.lifecycleScope
import com.tv2oppgave.tvmovieapp.data.MovieRepository
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MovieRepository.initializeDatabase(applicationContext)
        setContentView(R.layout.activity_main)

        lifecycleScope.launch {
            MovieRepository.getFeedMovies("feed_01k2f37n6vf26axgp52a8betek")
                .collectLatest { list ->
                    Log.d("TV2TEST", "Movies received = ${list.size}")

                    list.take(3).forEachIndexed { i, item ->
                        Log.d("TV2TEST", "Movie[$i] = ${item.title}")
                    }
                }
        }
    }
}
