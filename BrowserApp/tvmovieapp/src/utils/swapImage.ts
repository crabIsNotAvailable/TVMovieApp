export function toMoviePoster(url: string) {
  if (!url) return "";

  const [path, query] = url.split("?");
  const params = new URLSearchParams(query);

  params.set("location", "moviePoster");
  params.set("width", "600");
  params.set("height", "900");

  return `${path}?${params.toString()}`;
}