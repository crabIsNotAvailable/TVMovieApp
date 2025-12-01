import { FC, useEffect, useState } from "react";
import { fetchFeedById } from "../../../../api/movies";
import { FeedMovie } from "../../../../models/feed";
import { CascadingCarousel } from "./CascadingCarousel";

interface HeroHeaderSectionProps {
  feedId: string;
  title?: string;
}

export const HeroHeaderSection: FC<HeroHeaderSectionProps> = ({
  feedId,
  title,
}) => {
  const [items, setItems] = useState<FeedMovie[]>([]);
  const [index, setIndex] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    async function load() {
      try {
        setLoading(true);
        const feed = await fetchFeedById(feedId);
        if (mounted) {
          setItems(feed.movies || []);
          setIndex(0);
        }
      } finally {
        if (mounted) setLoading(false);
      }
    }

    load();
    return () => {
      mounted = false;
    };
  }, [feedId]);

  if (loading) return <div>Loading…</div>;
  if (!items.length) return <div>No items found.</div>;

  return (
    <div
      style={{
        marginLeft: "5rem",
        marginRight: "5rem",
      }}
    >
      <CascadingCarousel items={items} index={index} setIndex={setIndex} />
      <div
        style={{
          width: "90vw",
          display: "flex",
          justifyContent: "center",
          transform: "translateY(-3rem)",
        }}
      >
        <h2
          key={index}
          style={{
            textAlign: "center",
            opacity: 1,
            animation: "fadeInOut 0.5s ease-in-out",
            fontFamily: "fantasy",
            fontSize: "2.5rem",

            willChange: "filter",

            filter: `
              drop-shadow(0 0 80px rgba(218, 170, 0, 0.82))
              drop-shadow(0 0 0px rgba(210,170,20,0.5))
              drop-shadow(0 0 20px rgba(0,0,0,0.9))
            `,
          }}
        >
          {items[index]?.title?.toUpperCase()}
        </h2>
        <style>
          {`
            @keyframes fadeInOut {
              0% { opacity: 0; }
              100% { opacity: 1; }
            }
          `}
        </style>
      </div>
    </div>
  );
};
