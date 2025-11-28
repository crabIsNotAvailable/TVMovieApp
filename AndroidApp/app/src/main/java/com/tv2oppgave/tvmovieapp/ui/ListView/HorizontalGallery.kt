package com.tv2oppgave.tvmovieapp.ui.ListView

import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.gestures.scrollBy
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.tv2oppgave.tvmovieapp.data.models.MovieListItem
import com.tv2oppgave.tvmovieapp.utility.SwapImage
import kotlinx.coroutines.launch

@Composable
fun HorizontalGallery(
    items: List<MovieListItem>,
    variant: String,
    onSelect: (MovieListItem) -> Unit = {}
) {
    val listState = rememberLazyListState()

    val scope = rememberCoroutineScope()


    Box(modifier = Modifier.fillMaxWidth()) {

        LazyRow(
            state = listState,
            modifier = Modifier
                .fillMaxWidth()
                .pointerInput(Unit) {
                    detectDragGestures { change, dragAmount ->
                        change.consume()
                        scope.launch {
                            listState.scrollBy(-dragAmount.x)
                        }
                    }
                }
        ) {
            items(items) { item ->
                val width = if (variant == "poster") 160.dp else 220.dp
                val aspect = if (variant == "poster") (2f / 3f) else (16f / 9f)
                val height = (width.value / aspect).dp
                AsyncImage(
                    model = SwapImage(item.imageUrl, variant),
                    contentDescription = item.title,
                    modifier = Modifier
                        .padding(end = 5.dp)
                        .size(width, height)
                        .clip(RoundedCornerShape(5.dp))
                        .clickable { onSelect(item)
                        }
                )
            }
        }
    }
}

