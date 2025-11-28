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
import androidx.navigation.NavController
import com.tv2oppgave.tvmovieapp.ui.ListView.ListView

@Composable
fun AppNav() {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = "categories"
    ) {

        // ✅ Main list page
        composable("categories") {
            ListView(navController = navController)
        }

        // ✅ Movie details page (urlPath can contain slashes)
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
