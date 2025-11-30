package com.tv2oppgave.tvmovieapp.ui.listView.components

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.KeyboardArrowDown
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp


@Composable
fun ScrollDownIndicator(
    visible: Boolean
) {
    AnimatedVisibility(
        visible = visible,
        enter = fadeIn(),
        exit = fadeOut()
    ) {
        Box {
            Icon(
                imageVector = Icons.Outlined.KeyboardArrowDown,
                contentDescription = null,
                tint = Color.Black,
                modifier = Modifier
                    .size(32.dp)
                    .offset(y = -2.dp, x = -2.dp)
            )

            Icon(
                imageVector = Icons.Outlined.KeyboardArrowDown,
                contentDescription = "Scroll down",
                tint = Color.White,
                modifier = Modifier.size(28.dp)
            )
        }
    }
}
