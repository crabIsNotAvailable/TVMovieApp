import React, { useEffect, useState } from "react";
import { fetchFeedById } from "../../../api/movies";
import { FeedMovie } from "../../../models/feed";
import { HorizontalGallery } from "../../../components/CardGallery";

interface FeedGalleryProps {
  feedId: string;
  variant?: "poster" | "landscape";
  title?: string;
}

export const FeedGallerySection: React.FC<FeedGalleryProps> = ({
  feedId,
  variant = "poster",
  title,
}) => {
  const [items, setItems] = useState<FeedMovie[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function load() {
      try {
        setLoading(true);
        const feed = await fetchFeedById(feedId);
        setItems(feed.movies);
      } catch (err) {
        console.error(`Feed ${feedId} error:`, err);
        setError(`Failed to load content`);
      } finally {
        setLoading(false);
      }
    }

    load();
  }, [feedId]);

  if (loading) return <div>Loading…</div>;
  if (error) return <div style={{ color: "red" }}>{error}</div>;

  return (
    <div style={{ marginBottom: "2rem", marginLeft: "5rem" }}>
      {title && (
        <h2
          style={{ color: "#cca90d", fontSize: "3rem", marginBottom: "0.5rem" }}
        >
          {title}
        </h2>
      )}
      <HorizontalGallery items={items} variant={variant} />
    </div>
  );
};
