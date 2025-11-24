import Logo from "../../components/Logo";
import { FeedIds } from "../../models/feedIds";
import { FeedGallerySection } from "./components/FeedGallerySection";
import { HighlightedSection } from "./components/HighlightedSection";

export default function ListView() {
  return (
    <div style={{ position: "relative", width: "100%" }}>
      <Logo />
      <HighlightedSection feedId={FeedIds.MostSeen} />
      <FeedGallerySection
        feedId={FeedIds.Recommended}
        title="For deg"
        variant="landscape"
      />
      <FeedGallerySection
        feedId={FeedIds.Festival}
        title="Vist på festival"
        variant="poster"
      />
      <FeedGallerySection
        feedId={FeedIds.Focus}
        title="Alltid film"
        variant="landscape"
      />
      <FeedGallerySection
        feedId={FeedIds.NewArrivals}
        title="Nyeankommede"
        variant="landscape"
      />
      <FeedGallerySection
        feedId={FeedIds.BuyRent}
        title="Kjøp eller lei"
        variant="poster"
      />
    </div>
  );
}
