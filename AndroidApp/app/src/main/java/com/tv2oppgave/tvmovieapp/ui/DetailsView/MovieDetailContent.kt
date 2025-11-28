package com.tv2oppgave.tvmovieapp.ui.details

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.ChipColors
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.LineHeightStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import com.tv2oppgave.tvmovieapp.data.MovieDetailUiModel

@Composable
fun MovieDetailContent(
    movie: MovieDetailUiModel,
    onBack: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .background(Color.Black)
    ) {

        /* ---------- HERO ---------- */
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(320.dp)
        ) {

            movie.posterUrl?.let {
                AsyncImage(
                    model = it,
                    contentDescription = movie.title,
                    contentScale = ContentScale.Fit,
                    modifier = Modifier.fillMaxSize()
                )

            }

            // Bottom gradient
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(120.dp)
                    .align(Alignment.BottomCenter)
                    .background(
                        Brush.verticalGradient(
                            colors = listOf(
                                Color.Transparent,
                                Color.Black
                            )
                        )
                    )
            )

            // ✅ Back button (INSIDE hero)
            Box(
                modifier = Modifier
                    .padding(16.dp)
                    .size(40.dp)
                    .clip(RoundedCornerShape(20.dp))
                    .background(Color.Black.copy(alpha = 0.6f))
                    .clickable { onBack() }
                    .align(Alignment.TopStart),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                    contentDescription = "Back",
                    tint = Color.White
                )
            }
        }

        /* ---------- CONTENT ---------- */
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 24.dp)
        ) {

            Text(
                text = movie.title,
                style = MaterialTheme.typography.headlineSmall,
                fontWeight = FontWeight.Bold,
                color = Color(0xFFCCA90D)
            )

            Spacer(modifier = Modifier.height(8.dp))

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                movie.year?.let { MetaText(it.toString()) }
                movie.ageRating?.let { MetaText(it) }
                movie.durationMinutes?.let { MetaText("${it} min") }
            }

            if (movie.genres.isNotEmpty()) {
                Spacer(modifier = Modifier.height(12.dp))
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    movie.genres.chunked(3).forEach { row ->
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            row.forEach { genre ->
                                AssistChip(
                                    onClick = {},
                                    label = { Text(genre) },
                                    colors = AssistChipDefaults.assistChipColors(
                                        labelColor = Color(0xFFCCA90D)
                                    )
                                )
                            }
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            Text(
                text = movie.description,
                style = MaterialTheme.typography.bodyLarge,
                color = Color(0xFFDDDDDD),
                lineHeight = 22.sp
            )

            if (movie.cast.isNotEmpty()) {
                Spacer(modifier = Modifier.height(28.dp))

                Text(
                    text = "Cast",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFFCCA90D)
                )

                Spacer(modifier = Modifier.height(8.dp))

                movie.cast.forEach { person ->
                    Text(
                        text = person,
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color(0xFFCCCCCC)
                    )
                }
            }
        }
    }
}

@Composable
private fun MetaText(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.bodyMedium,
        color = Color(0xFFCCA90D)
    )
}