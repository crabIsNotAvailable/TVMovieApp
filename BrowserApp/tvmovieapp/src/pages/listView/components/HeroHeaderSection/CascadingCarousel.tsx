import React, {
  CSSProperties,
  Dispatch,
  FC,
  SetStateAction,
  useEffect,
  useRef,
} from "react";
import { FeedMovie } from "../../../../models/feed";
import { clamp, signedDistanceFor } from "../../../../utils/mathHelpers";
import { useNavigate } from "react-router-dom";
import { control } from "./ControlCSS";

interface Props {
  items: FeedMovie[];
  index: number;
  setIndex: Dispatch<SetStateAction<number>>;
  neighborRadius?: number;
}

export const CascadingCarousel: FC<Props> = ({
  items,
  index,
  setIndex,
  neighborRadius = 3,
}) => {
  const navigate = useNavigate();
  const autoplayRef = useRef<number | null>(null);

  const n = items.length;
  const clampIndex = (i: number) => ((i % n) + n) % n;

  const stopAutoplay = () => {
    if (autoplayRef.current !== null) {
      clearInterval(autoplayRef.current);
      autoplayRef.current = null;
    }
  };

  const startAutoplay = () => {
    stopAutoplay();
    autoplayRef.current = window.setInterval(() => {
      setIndex((prev) => clampIndex(prev + 1));
    }, 5000);
  };

  const next = () => {
    stopAutoplay();
    setIndex(clampIndex(index + 1));
    startAutoplay();
  };

  const prev = () => {
    stopAutoplay();
    setIndex(clampIndex(index - 1));
    startAutoplay();
  };

  useEffect(() => {
    if (items.length > 1) {
      startAutoplay();
    }
    return stopAutoplay;
  }, [items.length]);

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
              onClick={() => {
                stopAutoplay();
                if (d === 0) {
                  navigate(`/movie/${item.urlPath}`);
                } else {
                  setIndex(clampIndex(i));
                }
                startAutoplay();
              }}
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
              }}
            >
              <img
                src={item.imageUrl}
                alt={item.title}
                style={{ width: "100%", height: "100%", objectFit: "cover" }}
                draggable={false}
              />
            </div>
          );
        })}
      </div>
    </div>
  );
};
