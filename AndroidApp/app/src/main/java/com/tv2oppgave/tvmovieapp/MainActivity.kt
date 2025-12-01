package com.tv2oppgave.tvmovieapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.tv2oppgave.tvmovieapp.data.MovieRepository

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MovieRepository.initializeDatabase(applicationContext)

        setContent {
            AppNav()
        }
    }
}
