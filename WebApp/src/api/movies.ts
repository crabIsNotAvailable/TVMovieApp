import { RootFeedResponse, Feed } from "../models/feed";
import { MovieDetail } from "../models/movie";

const API_BASE = "http://localhost:8080/api/Movies";

export async function fetchMovieFeeds(): Promise<RootFeedResponse> {
  const res = await fetch(`${API_BASE}/feeds`);
  if (!res.ok) {
    throw new Error("Failed to load movie feeds");
  }
  return res.json();
}

export async function fetchFeedById(feedId: string): Promise<Feed> {
  const res = await fetch(`${API_BASE}/feed/id/${feedId}`);
  if (!res.ok) {
    throw new Error(`Failed to load feed ${feedId}`);
  }
  return res.json();
}

export async function fetchMovieDetail(urlPath: string): Promise<MovieDetail> {
  const normalizedPath = urlPath.replace(/^\//, "");

  const res = await fetch(`${API_BASE}/detail/${normalizedPath}`);

  if (!res.ok) {
    throw new Error("Failed to load movie detail");
  }

  return res.json();
}
