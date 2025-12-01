import { useEffect, useState } from "react";
import Logo from "../../components/Logo";
import { FeedIds } from "../../models/feedIds";
import { FeedGallerySection } from "./components/FeedGallerySection";
import { HeroHeaderSection } from "./components/HeroHeaderSection/HeroHeaderSection";

export default function ListView() {
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    const timeout = setTimeout(() => setLoaded(true), 700);
    return () => clearTimeout(timeout);
  }, []);

  return (
    <div style={{ position: "relative", width: "100%" }}>
      <Logo />
      <div
        style={{
          opacity: loaded ? 1 : 0,
          transition: "opacity 1s ease",
        }}
      >
        <HeroHeaderSection feedId={FeedIds.MostSeen} />
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
    </div>
  );
}
