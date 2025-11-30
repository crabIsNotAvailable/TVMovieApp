package com.tv2oppgave.tvmovieapp.ui.details

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.tv2oppgave.tvmovieapp.data.MovieDetailUiModel
import com.tv2oppgave.tvmovieapp.data.MovieRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class MovieDetailViewModel : ViewModel() {

    private val _movie = MutableStateFlow<MovieDetailUiModel?>(null)
    val movie: StateFlow<MovieDetailUiModel?> = _movie

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _isError = MutableStateFlow(false)
    val isError: StateFlow<Boolean> = _isError

    fun loadMovie(urlPath: String) {
        viewModelScope.launch {
            _isLoading.value = true
            _isError.value = false

            val result = MovieRepository.getMovieDetail(urlPath)

            if (result != null) {
                _movie.value = result
            } else {
                _isError.value = true
            }

            _isLoading.value = false
        }
    }
}
