import React from "react";
import { FeedMovie } from "../../../models/feed";
import { clamp, signedDistanceFor } from "../../../utils/mathHelpers";

interface Props {
  items: FeedMovie[];
  index: number;
  setIndex: (i: number) => void;
  neighborRadius?: number;
}

export const CascadingCarousel: React.FC<Props> = ({
  items,
  index,
  setIndex,
  neighborRadius = 3,
}) => {
  const n = items.length;

  const clampIndex = (i: number) => ((i % n) + n) % n;

  const next = () => setIndex(clampIndex(index + 1));
  const prev = () => setIndex(clampIndex(index - 1));

  return (
    <div
      style={{
        position: "relative",
        height: "32vw",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        perspective: "1400px",
        marginRight: "5rem",
        marginLeft: "5rem",
      }}
    >
      <button onClick={prev} style={control("left")}>
        ◀
      </button>
      <button onClick={next} style={control("right")}>
        ▶
      </button>
      <div>
        {items.map((item, i) => {
          const d = signedDistanceFor(i, index, n);
          const absD = Math.abs(d);

          if (absD > neighborRadius) return null;

          const scale = clamp(1 - absD * 0.14, 0.6, 1.0);
          const translateX = d * 260;
          const rotateY = clamp(-d * 10, -30, 30);
          const zIndex = 1000 - Math.round(absD * 10);
          const opacity = clamp(1 - absD * 0.15, 0.25, 1);

          return (
            <div
              key={item.id}
              onClick={() => setIndex(clampIndex(i))}
              style={{
                position: "absolute",
                left: "50%",
                top: "50%",
                transform: `translate3d(calc(-50% + ${translateX}px), -50%, 0) scale(${scale}) rotateY(${rotateY}deg)`,
                width: "42vw",
                height: "24vw",
                transition: "all 420ms cubic-bezier(.2,.9,.25,1)",
                borderRadius: 12,
                overflow: "hidden",
                zIndex,
                opacity,
                cursor: "pointer",
                boxShadow:
                  d === 0
                    ? "0 18px 50px rgba(0,0,0,0.65)"
                    : "0 10px 30px rgba(0,0,0,0.45)",

                // ⭐ THIS IS THE FADE YOU WANT
              }}
            >
              <img
                src={item.imageUrl}
                alt={item.title}
                style={{ width: "100%", height: "100%", objectFit: "cover" }}
                draggable={false}
              />

              {d === 0 && (
                <div
                  style={{
                    position: "absolute",
                    bottom: 14,
                    left: 20,
                    color: "white",
                    fontSize: 20,
                    textShadow: "0 0 8px rgba(0,0,0,0.8)",
                  }}
                ></div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
};

function control(side: "left" | "right"): React.CSSProperties {
  return {
    position: "absolute",
    top: "50%",
    transform: "translateY(-50%)",
    fontSize: "1.6rem",
    background: "rgba(0,0,0,0.5)",
    color: "white",
    border: "none",
    padding: "12px 14px",
    cursor: "pointer",
    borderRadius: 8,
    zIndex: 2000,
    [side]: -72,
  };
}
