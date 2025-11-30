package com.tv2oppgave.tvmovieapp.ui.listView.components

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.tv2oppgave.tvmovieapp.data.MovieRepository
import com.tv2oppgave.tvmovieapp.data.models.MovieListItem
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn

class FeedViewModel : ViewModel() {

    private val feedFlows = mutableMapOf<String, StateFlow<List<MovieListItem>>>()

    fun feedMovies(feedId: String): StateFlow<List<MovieListItem>> {
        return feedFlows.getOrPut(feedId) {
            MovieRepository.getFeedMovies(feedId)
                .stateIn(
                    scope = viewModelScope,
                    started = SharingStarted.WhileSubscribed(5_000),
                    initialValue = emptyList()
                )
        }
    }
}

