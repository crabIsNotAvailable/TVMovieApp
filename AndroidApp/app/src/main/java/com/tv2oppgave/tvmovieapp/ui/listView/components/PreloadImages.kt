package com.tv2oppgave.tvmovieapp.ui.listView.components

import androidx.compose.runtime.*
import androidx.compose.ui.platform.LocalContext
import coil.request.ImageRequest
import coil.imageLoader

@Composable
fun PreloadImages(
    imageUrls: List<String?>
) {
    val context = LocalContext.current
    val imageLoader = context.imageLoader

    LaunchedEffect(imageUrls) {
        imageUrls
            .filterNotNull()
            .distinct()
            .forEach { url ->
                val request = ImageRequest.Builder(context)
                    .data(url)
                    .size(coil.size.Size.ORIGINAL)
                    .build()

                imageLoader.enqueue(request)
            }
    }
}


