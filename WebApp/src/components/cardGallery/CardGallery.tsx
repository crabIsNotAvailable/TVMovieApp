import { FC } from "react";
import { useNavigate } from "react-router-dom";
import { toMovieImage } from "../../utils/swapImage";
import { FeedMovie } from "../../models/feed";
import { styles } from "./styles";
import { useHorizontalDragScroll } from "../../hooks/horizontalDragScroll";

export const HorizontalGallery: FC<{
  items: FeedMovie[];
  variant?: "poster" | "landscape";
}> = ({ items, variant = "poster" }) => {
  const navigate = useNavigate();

  const {
    scrollRef,
    canScrollLeft,
    canScrollRight,
    scrollLeft,
    scrollRight,
    handlers,
  } = useHorizontalDragScroll({
    onClickItem: (card: HTMLElement) => {
      const urlPath = card.dataset.urlpath;
      if (urlPath) navigate(`/movie/${urlPath}`);
    },
  });

  return (
    <div style={{ position: "relative" }}>
      {canScrollLeft && (
        <button style={styles.leftButton} onClick={scrollLeft}>
          ◀
        </button>
      )}

      <div
        ref={scrollRef}
        style={styles.wrapper}
        className="no-scrollbar"
        {...handlers}
      >
        {items.map((item) => {
          const finalImage =
            variant === "poster"
              ? toMovieImage(item.imageUrl, "poster")
              : item.imageUrl;

          return (
            <div key={item.id} data-urlpath={item.urlPath} style={styles.card}>
              <img
                src={finalImage}
                alt={item.title}
                style={variant === "poster" ? styles.poster : styles.landscape}
                draggable={false}
              />
            </div>
          );
        })}
      </div>

      {canScrollRight && (
        <button style={styles.rightButton} onClick={scrollRight}>
          ▶
        </button>
      )}
    </div>
  );
};
