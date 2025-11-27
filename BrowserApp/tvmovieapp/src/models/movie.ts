import { Label } from "./feed";

export interface MovieDetail {
  id: string;
  title: string;
  description: string;
  durationMinutes: number | null;
  posterUrl: string | null;
  year: number | null;
  ageRating: string | null;
  genres: string[];
  cast: string[];
}
