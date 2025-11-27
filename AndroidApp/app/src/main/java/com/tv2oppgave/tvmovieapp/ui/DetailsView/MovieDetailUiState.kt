package com.tv2oppgave.tvmovieapp.ui.details

import com.tv2oppgave.tvmovieapp.data.MovieDetailUiModel

sealed interface MovieDetailUiState {
    data object Loading : MovieDetailUiState
    data object Error : MovieDetailUiState
    data class Success(val movie: MovieDetailUiModel) : MovieDetailUiState
}
