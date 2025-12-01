package com.tv2oppgave.tvmovieapp.ui.listView.components

import android.net.Uri
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.tv2oppgave.tvmovieapp.data.models.MovieListItem
import kotlinx.coroutines.delay
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Shadow
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith

import com.tv2oppgave.tvmovieapp.data.MovieRepository

@Composable
fun HighlightHero(
    navController: NavController,
    feedId: String
) {
    var movies by remember { mutableStateOf<List<MovieListItem>>(emptyList()) }
    var index by remember { mutableStateOf(0) }

    LaunchedEffect(feedId) {
        MovieRepository.getFeedMovies(feedId).collect { list ->
            movies = list
            index = 0
        }
    }

    // Auto-advance every 5s
    LaunchedEffect(index, movies) {
        if (movies.isNotEmpty()) {
            delay(5000)
            index = (index + 1) % movies.size
        }
    }

    if (movies.isEmpty()) return

    // Fades when hero changes
    AnimatedContent(
        targetState = index,
        transitionSpec = {
            fadeIn(animationSpec = tween(500)) togetherWith
                    fadeOut(animationSpec = tween(500))
        },
        label = "HeroFade"
    ) { animatedIndex ->

        val movie = movies[animatedIndex]

        Column(modifier = Modifier.padding(bottom = 16.dp)) {

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(16f / 9f)
            ) {

                AsyncImage(
                    model = movie.imageUrl,
                    contentDescription = movie.title,
                    contentScale = ContentScale.Crop,
                    modifier = Modifier
                        .fillMaxSize()
                        .clickable {
                            navController.navigate(
                                "movie/${Uri.encode(movie.urlPath.removePrefix("/"))}"
                            )
                        }
                )

                Box(
                    modifier = Modifier
                        .padding(start = 8.dp)
                        .size(40.dp)
                        .clip(RoundedCornerShape(20.dp))
                        .background(Color.Black.copy(alpha = 0.6f))
                        .clickable {
                            index = (index - 1 + movies.size) % movies.size
                        }
                        .align(Alignment.CenterStart),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                        contentDescription = "Previous",
                        tint = Color.White
                    )
                }

                Box(
                    modifier = Modifier
                        .padding(end = 8.dp)
                        .size(40.dp)
                        .clip(RoundedCornerShape(20.dp))
                        .background(Color.Black.copy(alpha = 0.6f))
                        .clickable {
                            index = (index + 1) % movies.size
                        }
                        .align(Alignment.CenterEnd),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                        contentDescription = "Next",
                        modifier = Modifier.rotate(180f),
                        tint = Color.White
                    )
                }
            }

            Text(
                text = movie.title.uppercase(),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 12.dp),
                color = Color(0xFFD4AF37),
                textAlign = TextAlign.Center,
                style = TextStyle(
                    fontSize = 18.sp,
                    fontFamily = FontFamily.Default,
                    shadow = Shadow(
                        color = Color(0xFFD4AF37),
                        offset = Offset.Zero,
                        blurRadius = 80f
                    )
                )
            )
        }
    }

}
