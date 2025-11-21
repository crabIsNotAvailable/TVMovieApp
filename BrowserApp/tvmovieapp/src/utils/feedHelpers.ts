import { RootFeedResponse } from "../models/feed";

export function extractTop10(data: RootFeedResponse) {
  return data.feeds.find(f => f.styles?.layout?.name === "top10")?.content ?? [];
}

export function extractRandomMovies(data: RootFeedResponse) {
  const all = data.feeds.flatMap(f => f.content);
  return all.sort(() => Math.random() - 0.5).slice(0, 10);
}