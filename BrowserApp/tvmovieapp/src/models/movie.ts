import { Label } from "./feed";

export interface MovieDetailResponse {
  id: string;
  title: string;
  original_title?: string;
  description: string;
  duration?: number;
  year?: number;
  images?: MovieDetailImages;
  gpid: string;
  labels?: Label[];
}

export interface MovieDetailImages {
  hero?: { src: string };
  poster?: { src: string };
  background?: { src: string };
}