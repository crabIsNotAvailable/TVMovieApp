import React, { useRef, useEffect } from "react";
import { FeedContentItem } from "../../../models/feed";
import { toMoviePoster } from "../../../utils/swapImage";

export default function PosterScroller({ items }: { items: FeedContentItem[] }) {
  const containerRef = useRef<HTMLDivElement>(null);

  const validItems = items.filter((item) => item.image?.src);
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
          const poster = toMoviePoster(item.image!.src);

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
