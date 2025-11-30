package com.tv2oppgave.tvmovieapp.ui.listView

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.tv2oppgave.tvmovieapp.data.models.FeedIds
import com.tv2oppgave.tvmovieapp.ui.listView.components.FeedView
import com.tv2oppgave.tvmovieapp.ui.listView.components.HighlightHero
import androidx.compose.runtime.getValue
import com.tv2oppgave.tvmovieapp.ui.listView.components.ScrollDownIndicator

@Composable
fun ListView(
    navController: NavController
) {
    val listState = rememberLazyListState()

    val configuration = androidx.compose.ui.platform.LocalConfiguration.current
    val isLandscape =
        configuration.orientation == android.content.res.Configuration.ORIENTATION_LANDSCAPE

    val showIndicator by remember {
        derivedStateOf {
            isLandscape &&
                    listState.firstVisibleItemIndex == 0 &&
                    listState.firstVisibleItemScrollOffset < 200
        }
    }

    Box(modifier = Modifier.fillMaxSize()) { // ✅ IMPORTANT
        LazyColumn(
            state = listState,
            verticalArrangement = Arrangement.spacedBy(24.dp),
        ) {
            item {
                HighlightHero(
                    navController = navController,
                    feedId = FeedIds.MostSeen,
                )
            }
            item { FeedView(navController, FeedIds.Recommended, "For deg", "landscape") }
            item { FeedView(navController, FeedIds.Festival, "Vist på festival", "poster") }
            item { FeedView(navController, FeedIds.Focus, "Alltid film", "landscape") }
            item { FeedView(navController, FeedIds.NewArrivals, "Nyeankommede", "landscape") }
            item { FeedView(navController, FeedIds.BuyRent, "Kjøp eller lei", "poster") }
        }

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.BottomCenter)
                .padding(bottom = 24.dp),
            contentAlignment = Alignment.Center
        ) {
            ScrollDownIndicator(visible = showIndicator)
        }
    }
}

