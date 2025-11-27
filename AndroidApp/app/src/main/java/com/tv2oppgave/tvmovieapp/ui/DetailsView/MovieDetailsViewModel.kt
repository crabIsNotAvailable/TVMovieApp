package com.tv2oppgave.tvmovieapp.ui.details

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.tv2oppgave.tvmovieapp.data.MovieRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class MovieDetailViewModel : ViewModel() {

    private val _state =
        MutableStateFlow<MovieDetailUiState>(MovieDetailUiState.Loading)

    val state: StateFlow<MovieDetailUiState> = _state

    fun loadMovie(urlPath: String) {
        viewModelScope.launch {
            _state.value = MovieDetailUiState.Loading

            val movie = MovieRepository.getMovieDetail(urlPath)
            if (movie != null) {
                _state.value = MovieDetailUiState.Success(movie)
            } else {
                _state.value = MovieDetailUiState.Error
            }
        }
    }
}
