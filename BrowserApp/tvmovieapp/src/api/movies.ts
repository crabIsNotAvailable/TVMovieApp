import { RootFeedResponse } from "../models/feed";
import { MovieDetailResponse } from "../models/movie";

const API_BASE = "http://localhost:5000/api/movies";

export async function fetchMovieFeeds(): Promise<RootFeedResponse> {
  const res = await fetch(`${API_BASE}/feeds`);

  if (!res.ok) {
    throw new Error("Failed to load movie feeds");
  }

  return res.json();
}

export function extractTop10(feeds: RootFeedResponse) {
  return feeds.feeds.find(f => f.styles?.layout?.name === "top10")?.content ?? [];
}

export async function fetchMovieDetail(urlPath: string): Promise<MovieDetailResponse> {
  // urlPath example: /film/the-fantastic-four-first-steps-e7zthsn5

  const encodedPath = encodeURIComponent(urlPath.replace(/^\//, ""));

  const res = await fetch(`${API_BASE}/detail/${encodedPath}`);

  if (!res.ok) {
    throw new Error("Failed to load movie detail");
  }

  return res.json();
}
