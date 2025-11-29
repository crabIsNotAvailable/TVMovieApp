import { useEffect, useState } from "react";
import { fetchFeedById } from "../../api/movies";
import { FeedMovie } from "../../models/feed";
import MovieScroller from "./components/movieScroller";
import PosterScroller from "./components/PosterScroller";
import GetStartedSection from "./components/getStartedButton";
import Logo from "../../components/Logo";
import { FeedIds } from "../../models/feedIds";

export default function HomePageView() {
  const [mostSeenFeed, setMostSeen] = useState<FeedMovie[]>([]);
  const [newArrivals, setNewArrivals] = useState<FeedMovie[]>([]);
  const [loaded, setLoaded] = useState(false);
  useEffect(() => {
    async function load() {
      try {
        const mostSeenFeed = await fetchFeedById(FeedIds.MostSeen);
        const newArrivalsFeed = await fetchFeedById(FeedIds.NewArrivals);

        setMostSeen(mostSeenFeed.movies ?? []);
        setNewArrivals(newArrivalsFeed.movies ?? []);
        setTimeout(() => setLoaded(true), 300);
      } catch (err) {
        console.error("Homepage failed:", err);
      }
    }
    load();
  }, []);

  return (
    <div style={{ position: "relative", width: "100%" }}>
      <Logo />
      <div
        style={{
          opacity: loaded ? 1 : 0,
          transition: "opacity 1s ease",
        }}
      >
        <PosterScroller items={mostSeenFeed} />
        <MovieScroller items={newArrivals} />
        <GetStartedSection />
      </div>
    </div>
  );
}
