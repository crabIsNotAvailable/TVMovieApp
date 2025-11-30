import React, { FC, useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { MovieDetail } from "../../models/movie";
import { fetchMovieDetail } from "../../api/movies";
import { Back } from "../../components/icons/Back";
import { PlayIcon } from "../../components/icons/PlayButton";

export const DetailsView: FC = () => {
  const { "*": urlPath } = useParams();
  const navigate = useNavigate();

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
        color: "white",
        fontFamily: "system-ui, sans-serif",
        height: "100vh",
      }}
    >
      <button
        onClick={() => navigate(-1)}
        style={{
          position: "absolute",
          top: 20,
          left: 20,
          zIndex: 10,
          background: "rgba(0,0,0,0.6)",
          color: "white",
          border: "none",
          padding: "8px 14px",
          borderRadius: 6,
          cursor: "pointer",
        }}
      >
        <Back />
      </button>

      <div
        style={{
          position: "relative",
          height: "60vh",
          width: "100vw",
          overflow: "hidden",
          backgroundColor: "black",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        {movie.posterUrl && (
          <img
            src={movie.posterUrl}
            alt={movie.title}
            style={{
              width: "60%",
              objectFit: "cover",
            }}
          />
        )}
        {/* Fake play button */}
        <div
          style={{
            position: "absolute",
            width: 72,
            height: 72,
            borderRadius: "50%",
            background: "rgba(0,0,0,0.6)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            cursor: "default",
          }}
        >
          <PlayIcon />
        </div>

        <div
          style={{
            position: "absolute",
            left: "20vw",
            top: 0,
            bottom: 0,
            width: "2%",
            background:
              "linear-gradient(to right, rgba(0,0,0,1), rgba(0,0,0,0))",
          }}
        />

        <div
          style={{
            position: "absolute",
            right: "20vw",
            top: 0,
            bottom: 0,
            width: "2%",
            background:
              "linear-gradient(to left, rgba(0,0,0,1), rgba(0,0,0,0))",
          }}
        />

        <div
          style={{
            position: "absolute",
            left: 0,
            right: 0,
            bottom: 0,
            height: "30%",
            background: "linear-gradient(to top, rgba(0,0,0,1), rgba(0,0,0,0))",
          }}
        />
      </div>

      <div
        style={{
          padding: "60px 24px",
          height: "0%",
          background: "linear-gradient(to top, rgba(0,0,0,0), rgba(0,0,0,1))",
        }}
      >
        <div style={{ maxWidth: 900, margin: "0 auto" }}>
          <h1 style={{ marginBottom: 12, color: "#cca90d" }}>{movie.title}</h1>

          <div
            style={{
              display: "flex",
              gap: 12,
              color: "#aaa",
              marginBottom: 16,
              flexWrap: "wrap",
            }}
          >
            {movie.year && <span>{movie.year}</span>}
            {movie.ageRating && <span>{movie.ageRating}</span>}
            {movie.durationMinutes && <span>{movie.durationMinutes} min</span>}
          </div>

          {movie.genres.length > 0 && (
            <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
              {movie.genres.map((g) => (
                <span
                  key={g}
                  style={{
                    background: "#222",
                    padding: "6px 10px",
                    borderRadius: 6,
                    fontSize: 14,
                  }}
                >
                  {g}
                </span>
              ))}
            </div>
          )}

          <p
            style={{
              marginTop: 24,
              fontSize: 16,
              lineHeight: 1.6,
              color: "#ddd",
            }}
          >
            {movie.description}
          </p>

          {movie.cast.length > 0 && (
            <div style={{ marginTop: 32 }}>
              <h3 style={{ marginBottom: 8, color: "#cca90d" }}>Cast</h3>
              <ul style={{ paddingLeft: 18, color: "#ccc" }}>
                {movie.cast.map((c) => (
                  <li key={c}>{c}</li>
                ))}
              </ul>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
