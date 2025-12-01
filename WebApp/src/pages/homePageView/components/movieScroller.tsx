import { useEffect, useRef } from "react";
import { FeedMovie } from "../../../models/feed";

interface Props {
  items: FeedMovie[];
}

export default function MovieScroller({ items }: Props) {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    requestAnimationFrame(() => {
      let position = -el.scrollWidth / 2;

      const loop = () => {
        position += 0.2;
        el.style.transform = `translateX(${position}px)`;

        if (position >= 0) {
          position = -el.scrollWidth / 2;
        }

        requestAnimationFrame(loop);
      };

      loop();
    });
  }, []);

  return (
    <div
      style={{
        height: "35vh",
        width: "100%",
        overflow: "hidden",
        whiteSpace: "nowrap",
      }}
    >
      <div ref={containerRef} style={{ display: "inline-flex" }}>
        {[...items, ...items].map((item, i) => {
          const src = item.imageUrl
            ? item.imageUrl
            : "https://via.placeholder.com/400x225?text=No+Image";

          return (
            <img
              key={i}
              src={src}
              alt={item.title}
              style={{
                height: "35vh",
                minWidth: "250px",
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
