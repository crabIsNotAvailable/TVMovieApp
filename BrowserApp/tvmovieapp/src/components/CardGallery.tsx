import React, { useRef, useState, useEffect } from "react";
import { toMovieImage } from "../utils/swapImage";
import { FeedMovie } from "../models/feed";
import { useDraggableScroll } from "../hooks/useDraggableScroll";

interface HorizontalGalleryProps {
  items: FeedMovie[];
  variant?: "poster" | "landscape";
  onSelect?: (id: string) => void;
}

export const HorizontalGallery: React.FC<HorizontalGalleryProps> = ({
  items,
  variant = "poster",
  onSelect,
}) => {
  const scrollRef = useRef<HTMLDivElement>(null);

  // Drag hook
  const { getHandlers } = useDraggableScroll();

  const [canScrollLeft, setCanScrollLeft] = useState(false);
  const [canScrollRight, setCanScrollRight] = useState(false);

  const updateScrollButtons = () => {
    const el = scrollRef.current;
    if (!el) return;

    setCanScrollLeft(el.scrollLeft > 0);
    setCanScrollRight(el.scrollLeft + el.clientWidth < el.scrollWidth);
  };

  useEffect(() => {
    updateScrollButtons();
    window.addEventListener("resize", updateScrollButtons);
    return () => window.removeEventListener("resize", updateScrollButtons);
  }, []);

  const scrollByAmount = (amount: number) => {
    scrollRef.current?.scrollBy({ left: amount, behavior: "smooth" });
    setTimeout(updateScrollButtons, 300);
  };

  return (
    <div style={{ position: "relative" }}>
      {canScrollLeft && (
        <button style={styles.leftButton} onClick={() => scrollByAmount(-300)}>
          ◀
        </button>
      )}

      <div
        ref={scrollRef}
        style={styles.wrapper}
        {...getHandlers(scrollRef)} // 👈 pointer drag hook
        onScroll={updateScrollButtons}
        className="no-scrollbar"
      >
        {items.map((item) => {
          const finalImage =
            variant === "poster"
              ? toMovieImage(item.imageUrl, "poster")
              : item.imageUrl;

          return (
            <div
              key={item.id}
              style={styles.card}
              onClick={() => onSelect?.(item.id)}
            >
              <img
                src={finalImage}
                alt={item.title}
                style={variant === "poster" ? styles.poster : styles.landscape}
                draggable={false}
                onDragStart={(e) => e.preventDefault()}
              />
            </div>
          );
        })}
      </div>

      {canScrollRight && (
        <button style={styles.rightButton} onClick={() => scrollByAmount(300)}>
          ▶
        </button>
      )}
    </div>
  );
};

const styles: Record<string, React.CSSProperties> = {
  wrapper: {
    display: "flex",
    overflowX: "auto",
    gap: "12px",
    padding: "16px 0",
    scrollbarWidth: "none",
    msOverflowStyle: "none",
  },

  card: {
    cursor: "pointer",
    display: "flex",
    flexDirection: "column",
  },

  poster: {
    width: "15vw",
    minWidth: "300px",
    borderRadius: "6px",
    objectFit: "cover",
  },

  landscape: {
    width: "12vw",
    minWidth: "400px",
    borderRadius: "6px",
    objectFit: "cover",
  },

  leftButton: {
    position: "absolute",
    left: 0,
    top: "50%",
    transform: "translateY(-50%)",
    padding: "10px 14px",
    cursor: "pointer",
    background: "rgba(0,0,0,0.5)",
    color: "white",
    border: "none",
    borderRadius: "4px",
    zIndex: 10,
  },

  rightButton: {
    position: "absolute",
    right: 0,
    top: "50%",
    transform: "translateY(-50%)",
    padding: "10px 14px",
    cursor: "pointer",
    background: "rgba(0,0,0,0.5)",
    color: "white",
    border: "none",
    borderRadius: "4px",
    zIndex: 10,
  },
};
