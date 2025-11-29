package com.tv2oppgave.tvmovieapp.ui.ListView.components

import androidx.compose.runtime.Composable
import android.net.Uri
import androidx.compose.runtime.*
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.lifecycle.viewmodel.compose.viewModel

import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.NavController

@Composable
fun FeedView(
    navController: NavController,
    feedId: String,
    title: String,
    variant: String,
    viewModel: FeedViewModel = viewModel()
) {
    val movies by viewModel.feedMovies(feedId)
        .collectAsStateWithLifecycle()

    Column(modifier = Modifier.padding(start = 16.dp)) {
        Text(
            text = title,
            fontSize = 25.sp,
            color = Color(0xFFCCA90D),
            fontWeight = FontWeight(500)
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


