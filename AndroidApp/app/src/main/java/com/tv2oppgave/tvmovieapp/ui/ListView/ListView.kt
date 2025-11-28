package com.tv2oppgave.tvmovieapp.ui.ListView

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.tv2oppgave.tvmovieapp.data.models.FeedIds

@Composable
fun ListView(
    navController: NavController
) {
    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(24.dp),
    ) {
        item {
            HighlightHero(
                navController = navController,
                feedId = FeedIds.MostSeen,
            )
        }
        item { FeedView(navController = navController, FeedIds.Recommended, "For deg", "landscape") }
        item { FeedView(navController = navController, FeedIds.Festival, "Vist på festival", "poster") }
        item { FeedView(navController = navController, FeedIds.Focus, "Alltid film", "landscape") }
        item { FeedView(navController = navController, FeedIds.NewArrivals, "Nyeankommede", "landscape") }
        item { FeedView(navController = navController, FeedIds.BuyRent, "Kjøp eller lei", "poster") }
    }
}