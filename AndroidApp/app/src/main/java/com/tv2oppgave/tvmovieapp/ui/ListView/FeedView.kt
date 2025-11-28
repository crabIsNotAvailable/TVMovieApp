package com.tv2oppgave.tvmovieapp.ui.ListView

import androidx.compose.runtime.Composable
import android.net.Uri
import androidx.compose.runtime.*
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.tv2oppgave.tvmovieapp.data.MovieRepository
import com.tv2oppgave.tvmovieapp.data.models.MovieListItem
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController

@Composable
fun FeedView(
    navController: NavController,
    feedId: String,
    title: String,
    variant: String,
    onSelect: (MovieListItem) -> Unit = {}
) {
    var movies by remember { mutableStateOf<List<MovieListItem>>(emptyList()) }

    LaunchedEffect(feedId) {
        MovieRepository.getFeedMovies(feedId).collect { list ->
            movies = list
        }
    }
    Column(
        modifier = Modifier.padding( start = 16.dp)
    ) {
        Text(text = title,
            fontFamily = FontFamily.SansSerif,
            fontSize = 25.sp,
            color = Color(0xFFCCA90D),
            fontWeight = FontWeight(500),
            modifier = Modifier.padding(bottom = 5.dp)
            )
        HorizontalGallery(
            items = movies,
            variant = variant,
            onSelect = { movie ->
                navController.navigate(
                    "movie/${Uri.encode(movie.urlPath.removePrefix("/"))}"
                )
            }
        )
    }

}

