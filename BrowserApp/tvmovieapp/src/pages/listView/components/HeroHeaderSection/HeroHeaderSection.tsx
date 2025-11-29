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
        marginBottom: "4rem",
      }}
    >
      {title && (
        <h2
          style={{
            color: "#cca90d",
            fontSize: "3rem",
            marginBottom: "1rem",
          }}
        >
          {title}
        </h2>
      )}
      <CascadingCarousel items={items} index={index} setIndex={setIndex} />
    </div>
  );
};
