package com.tv2oppgave.tvmovieapp.ui.details

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import coil.compose.AsyncImage
import com.tv2oppgave.tvmovieapp.data.MovieDetailUiModel

@Composable
fun MovieDetailScreen(
    urlPath: String,
    viewModel: MovieDetailViewModel,
    navController: NavController
) {
    LaunchedEffect(urlPath) {
        viewModel.loadMovie(urlPath)
    }

    val state by viewModel.state.collectAsState()

    when (state) {
        is MovieDetailUiState.Loading -> {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                CircularProgressIndicator()
            }
        }

        is MovieDetailUiState.Error -> {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text("Failed to load movie details")
            }
        }

        is MovieDetailUiState.Success -> {
            val success = state as MovieDetailUiState.Success
            MovieDetailContent(
                movie = success.movie,
                onBack = { navController.popBackStack() }
            )
        }
    }
}
