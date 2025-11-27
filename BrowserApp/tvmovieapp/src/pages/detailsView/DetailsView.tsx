import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { MovieDetail } from "../../models/movie";
import { fetchMovieDetail } from "../../api/movies";

export const DetailsView: React.FC = () => {
  const { "*": urlPath } = useParams();
  const [movie, setMovie] = useState<MovieDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!urlPath) {
      setLoading(false);
      setError("Invalid movie path");
      return;
    }

    const load = async () => {
      try {
        setLoading(true);
        setError(null);

        const data = await fetchMovieDetail(urlPath);
        setMovie(data);
      } catch {
        setError("Could not load movie details");
      } finally {
        setLoading(false);
      }
    };

    load();
  }, [urlPath]);

  if (loading) {
    return <div style={{ padding: 24 }}>Loading…</div>;
  }

  if (error || !movie) {
    return <div style={{ padding: 24 }}>{error ?? "Not found"}</div>;
  }

  return (
    <div
      style={{
        maxWidth: 900,
        margin: "0 auto",
        padding: 24,
        fontFamily: "system-ui, sans-serif",
      }}
    >
      <div style={{ display: "flex", gap: 24, marginBottom: 24 }}>
        {movie.posterUrl && (
          <img
            src={movie.posterUrl}
            alt={movie.title}
            style={{ width: 220, borderRadius: 8 }}
          />
        )}

        <div>
          <h1 style={{ margin: "0 0 8px 0" }}>{movie.title}</h1>

          <div style={{ display: "flex", gap: 12, color: "#666" }}>
            {movie.year && <span>{movie.year}</span>}
            {movie.ageRating && <span>{movie.ageRating}</span>}
            {movie.durationMinutes && <span>{movie.durationMinutes} min</span>}
          </div>

          {movie.genres.length > 0 && (
            <div style={{ marginTop: 8, display: "flex", gap: 6 }}>
              {movie.genres.map((g) => (
                <span
                  key={g}
                  style={{
                    background: "#eee",
                    padding: "4px 8px",
                    borderRadius: 4,
                    fontSize: 14,
                  }}
                >
                  {g}
                </span>
              ))}
            </div>
          )}
        </div>
      </div>

      <p style={{ fontSize: 16, lineHeight: 1.6 }}>{movie.description}</p>

      {movie.cast.length > 0 && (
        <div style={{ marginTop: 24 }}>
          <h3>Cast</h3>
          <ul style={{ paddingLeft: 18 }}>
            {movie.cast.map((c) => (
              <li key={c}>{c}</li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};
