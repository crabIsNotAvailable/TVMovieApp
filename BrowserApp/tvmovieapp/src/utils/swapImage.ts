// Switches images to list or poster

export function toMovieImage(
  url: string,
  type: "poster" | "landscape" = "landscape"
) {
  if (!url) return "";

  const [path, query] = url.split("?");
  const params = new URLSearchParams(query);

  if (type === "poster") {
    params.set("location", "moviePoster");
    params.set("width", "600");
    params.set("height", "900");
  } else {
    params.set("location", "landscape");
    params.set("width", "1920");
    params.set("height", "1080");
  }

  return `${path}?${params.toString()}`;
}
