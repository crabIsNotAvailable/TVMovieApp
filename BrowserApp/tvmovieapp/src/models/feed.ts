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

  content: FeedContentItem[];
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

export interface Label {
  text: string;
  type: string;
}