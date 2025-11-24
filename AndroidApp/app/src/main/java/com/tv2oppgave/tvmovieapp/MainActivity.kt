package com.tv2oppgave.tvmovieapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.tv2oppgave.tvmovieapp.data.MovieRepository
import com.tv2oppgave.tvmovieapp.data.models.FeedIds
import com.tv2oppgave.tvmovieapp.ui.ListView.ListView

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MovieRepository.initializeDatabase(applicationContext)

        setContent {
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(24.dp),
                modifier = Modifier.padding(16.dp)
            ) {
                item { ListView(FeedIds.Recommended, "For deg", "landscape") }
                item { ListView(FeedIds.Festival, "Vist på festival", "poster") }
                item { ListView(FeedIds.Focus, "Alltid film", "landscape") }
                item { ListView(FeedIds.NewArrivals, "Nyeankommede", "landscape") }
                item { ListView(FeedIds.BuyRent, "Kjøp eller lei", "poster") }
            }
        }
    }
}
