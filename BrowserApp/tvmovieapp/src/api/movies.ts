import { RootFeedResponse, Feed } from "../models/feed";
import { MovieDetailResponse } from "../models/movie";

const API_BASE = "http://localhost:5000/api/Movies";

// Fetch all feeds (root list)
export async function fetchMovieFeeds(): Promise<RootFeedResponse> {
  const res = await fetch(`${API_BASE}/feeds`);
  if (!res.ok) {
    throw new Error("Failed to load movie feeds");
  }
  return res.json();
}

// Fetch a single feed by TV2 feedId
export async function fetchFeedById(feedId: string): Promise<Feed> {
  const res = await fetch(`${API_BASE}/feed/id/${feedId}`);
  if (!res.ok) {
    throw new Error(`Failed to load feed ${feedId}`);
  }
  return res.json();
}

// Fetch movie detail
export async function fetchMovieDetail(
  urlPath: string
): Promise<MovieDetailResponse> {

  const encodedPath = encodeURIComponent(urlPath.replace(/^\//, ""));

  const res = await fetch(`${API_BASE}/detail/${encodedPath}`);

  if (!res.ok) {
    throw new Error("Failed to load movie detail");
  }
  return res.json();
}