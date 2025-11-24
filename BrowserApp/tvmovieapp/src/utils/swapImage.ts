export function toMovieImage(
  url: string,
  type: "poster" | "landscape" = "landscape"
) {
  if (!url) return "";

  const [path, query] = url.split("?");
  const params = new URLSearchParams(query);

  // Apply correct TV2-style transformation
  if (type === "poster") {
    params.set("location", "moviePoster");
    params.set("width", "600");
    params.set("height", "900");
  } else {
    // Default landscape (no special aspect)
    params.set("location", "landscape");
    params.set("width", "1920");
    params.set("height", "1080");
  }

  return `${path}?${params.toString()}`;
}
