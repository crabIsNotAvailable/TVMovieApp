import React, { useRef, useState, useEffect, FC } from "react";
import { toMovieImage } from "../utils/swapImage";
import { FeedMovie } from "../models/feed";
import { useNavigate } from "react-router-dom";

interface HorizontalGalleryProps {
  items: FeedMovie[];
  variant?: "poster" | "landscape";
}

export const HorizontalGallery: FC<HorizontalGalleryProps> = ({
  items,
  variant = "poster",
}) => {
  const scrollRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();

  const isDragging = useRef(false);
  const startX = useRef(0);
  const lastX = useRef(0);

  const [canScrollLeft, setCanScrollLeft] = useState(false);
  const [canScrollRight, setCanScrollRight] = useState(false);

  const DRAG_THRESHOLD_PX = 6;

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

  const handlePointerDown = (e: React.PointerEvent<HTMLDivElement>) => {
    isDragging.current = false;
    startX.current = e.clientX;
    lastX.current = e.clientX;

    scrollRef.current?.setPointerCapture(e.pointerId);
  };

  const handlePointerMove = (e: React.PointerEvent<HTMLDivElement>) => {
    if (!scrollRef.current) return;

    if (e.buttons !== 1) return;

    const dxFromStart = e.clientX - startX.current;

    if (!isDragging.current && Math.abs(dxFromStart) > DRAG_THRESHOLD_PX) {
      isDragging.current = true;
    }

    if (!isDragging.current) return;

    const dx = e.clientX - lastX.current;
    scrollRef.current.scrollLeft -= dx;
    lastX.current = e.clientX;

    updateScrollButtons();
  };

  const handlePointerUp = (e: React.PointerEvent<HTMLDivElement>) => {
    scrollRef.current?.releasePointerCapture(e.pointerId);

    if (isDragging.current) return;

    const el = document.elementFromPoint(e.clientX, e.clientY);
    const card = el?.closest<HTMLDivElement>("[data-urlpath]");
    if (!card) return;

    const urlPath = card.dataset.urlpath;
    if (!urlPath) return;

    navigate(`/movie/${urlPath}`);
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
        className="no-scrollbar"
        onScroll={updateScrollButtons}
        onPointerDown={handlePointerDown}
        onPointerMove={handlePointerMove}
        onPointerUp={handlePointerUp}
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
    touchAction: "pan-y",
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
