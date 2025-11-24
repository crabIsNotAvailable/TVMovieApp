import React, { useRef, useEffect } from "react";
import { FeedMovie } from "../../../models/feed";
import { toMovieImage } from "../../../utils/swapImage";

interface Props {
  items: FeedMovie[];
}

export default function PosterScroller({ items }: Props) {
  const containerRef = useRef<HTMLDivElement>(null);

  const validItems = items.filter((item) => item.imageUrl);

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    let position = 0;

    const loop = () => {
      position += 0.2;
      el.style.transform = `translateX(-${position}px)`;

      if (position >= el.scrollWidth / 2) {
        position = 0;
      }

      requestAnimationFrame(loop);
    };

    loop();
  }, [validItems]);

  return (
    <div
      style={{
        height: "65vh",
        width: "100%",
        overflow: "hidden",
        whiteSpace: "nowrap",
      }}
    >
      <div ref={containerRef} style={{ display: "inline-flex" }}>
        {[...validItems, ...validItems].map((item, i) => {
          const poster = toMovieImage(item.imageUrl, "poster");

          return (
            <img
              key={i}
              src={poster}
              alt={item.title}
              style={{
                height: "65vh",
                marginRight: "1rem",
                borderRadius: "8px",
              }}
            />
          );
        })}
      </div>
    </div>
  );
}
