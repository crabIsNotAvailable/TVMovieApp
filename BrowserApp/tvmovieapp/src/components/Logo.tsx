import { Link } from "react-router-dom";
import { useEffect, useState } from "react";

export default function Logo() {
  const [hidden, setHidden] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setHidden(window.scrollY > 400);
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <Link
      to="/"
      style={{
        textDecoration: "none",
        position: "fixed",
        top: "20px",
        left: "2%",
        zIndex: 9999,

        // fade out smoothly
        opacity: hidden ? 0 : 1,
        transition: "opacity 0.4s ease",
        pointerEvents: hidden ? "none" : "auto",
      }}
    >
      <div
        style={{
          fontFamily: "'Crimson Text', serif",
          fontSize: "4rem",
          letterSpacing: "0.25rem",
          color: "#e6b000ff",
          cursor: "pointer",

          filter: `
            drop-shadow(0 0 18px rgba(0, 0, 0, 0.7))
            drop-shadow(0 0 40px rgba(0, 0, 0, 0.3))
            drop-shadow(0 8px 10px rgba(0, 0, 0, 0.8))
          `,

          WebkitFontSmoothing: "antialiased",
          MozOsxFontSmoothing: "grayscale",
        }}
      >
        TVM
      </div>
    </Link>
  );
}
