export interface RootFeedResponse {
  layout: string;
  feeds: Feed[];
}

export interface Feed {
  id: string;
  title: string;
  section_title?: string;
  type: string;
  size: number;
  start: number;
  total: number;

  styles?: {
    layout?: {
      name: string;
      text?: string;
      aspect?: string;
    };
    theme?: {
      name: string;
    };
  };

  movies: FeedMovie[];
}

export interface FeedContentItem {
  content_id: string;
  title: string;
  description?: string;
  image: {
    src: string;
  };
  url: string;
}

export interface FeedMovie {
  id: string;
  title: string;
  imageUrl: string;
  urlPath: string;
}

export interface Label {
  text: string;
  type: string;
}

