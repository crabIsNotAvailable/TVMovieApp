package com.tv2oppgave.tvmovieapp.ui.details

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.navigation.NavController

@Composable
fun MovieDetailScreen(
    urlPath: String,
    viewModel: MovieDetailViewModel,
    navController: NavController
) {
    LaunchedEffect(urlPath) {
        viewModel.loadMovie(urlPath)
    }

    val movie by viewModel.movie.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val isError by viewModel.isError.collectAsState()

    when {
        isLoading -> {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                CircularProgressIndicator()
            }
        }

        isError -> {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text("Failed to load movie details")
            }
        }

        movie != null -> {
            MovieDetailContent(
                movie = movie!!,
                onBack = { navController.popBackStack() }
            )
        }
    }
}
