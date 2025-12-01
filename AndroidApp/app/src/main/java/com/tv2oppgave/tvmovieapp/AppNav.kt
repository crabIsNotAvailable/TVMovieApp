package com.tv2oppgave.tvmovieapp

import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.NavType
import androidx.navigation.navArgument
import com.tv2oppgave.tvmovieapp.ui.details.MovieDetailScreen
import androidx.lifecycle.viewmodel.compose.viewModel
import com.tv2oppgave.tvmovieapp.ui.listView.ListView

@Composable
fun AppNav() {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = "list"
    ) {

        composable("list") {
            ListView(navController = navController)
        }

        composable(
            route = "movie/{urlPath}",
            arguments = listOf(
                navArgument("urlPath") { type = NavType.StringType }
            )
        ) { backStackEntry ->
            val encodedPath = backStackEntry.arguments!!.getString("urlPath")!!
            val urlPath = Uri.decode(encodedPath)
            backStackEntry.arguments!!.getString("urlPath")!!

            MovieDetailScreen(
                urlPath = urlPath,
                viewModel = viewModel(),
                navController = navController
            )
        }

    }
}
