import React, { useEffect, useState } from "react";
import { fetchMovieFeeds } from "../../api/movies";
import { FeedContentItem } from "../../models/feed";
import { extractTop10, extractRandomMovies } from "../../utils/feedHelpers"
import MovieScroller from "./components/movieScroller";
import PosterScroller from "./components/PosterScroller";
import GetStartedSection from "./components/getStartedButton";
import Logo from "../../components/Logo";

export default function HomePageView() {
  const [top10, setTop10] = useState<FeedContentItem[]>([]);
  const [random10, setRandom10] = useState<FeedContentItem[]>([]);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    fetchMovieFeeds().then(data => {
      setTop10(extractTop10(data));
      setRandom10(extractRandomMovies(data));

      setTimeout(() => setLoaded(true), 300);
    });
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
        <PosterScroller items={random10} />
        <MovieScroller items={top10} />
        <GetStartedSection />
      </div>

    </div>
  );



}