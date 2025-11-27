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
import coil.compose.AsyncImage
import com.tv2oppgave.tvmovieapp.data.MovieDetailUiModel

@Composable
fun MovieDetailScreen(
    urlPath: String,
    viewModel: MovieDetailViewModel
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
            MovieDetailContent((state as MovieDetailUiState.Success).movie)
        }
    }
}

@Composable
private fun MovieDetailContent(movie: MovieDetailUiModel) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
    ) {

        movie.posterUrl?.let {
            AsyncImage(
                model = it,
                contentDescription = movie.title,
                modifier = Modifier
                    .fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(16.dp))
        }

        Text(
            text = movie.title,
            style = MaterialTheme.typography.headlineSmall,
            fontWeight = FontWeight.Bold,
            color = Color(0xFFCCA90D),
        )

        Spacer(modifier = Modifier.height(8.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            movie.year?.let { Text("$it",
                color = Color(0xFFCCA90D)) }
            movie.ageRating?.let { Text(it,
                color = Color(0xFFCCA90D)) }
            movie.durationMinutes?.let { Text("${it} min",
                color = Color(0xFFCCA90D)) }
        }

        if (movie.genres.isNotEmpty()) {
            Spacer(modifier = Modifier.height(8.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                movie.genres.forEach { genre ->
                    AssistChip(
                        onClick = {},
                        label = { Text(genre) },
                        colors = AssistChipDefaults.assistChipColors(
                            containerColor = Color(0xFFCCA90D),
                            labelColor = Color.Black
                        )
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = movie.description,
            style = MaterialTheme.typography.bodyLarge,
            color = Color(0xFFCCA90D),
        )

        if (movie.cast.isNotEmpty()) {
            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = "Cast",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
                color = Color(0xFFCCA90D),
            )
            Spacer(modifier = Modifier.height(8.dp))
            Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                movie.cast.forEach { person ->
                    Text(person,
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color(0xFFCCA90D),)
                }
            }
        }
    }
}
