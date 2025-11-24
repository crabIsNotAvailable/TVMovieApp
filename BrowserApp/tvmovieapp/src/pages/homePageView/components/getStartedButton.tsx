import { Link } from "react-router-dom";

export default function GetStartedOverlay() {
  return (
    <div
      style={{
        position: "absolute",
        top: 0,
        left: 0,
        width: "100%",
        height: "100vh",
        zIndex: 10,

        isolation: "isolate",
        transform: "translateZ(0)",

        background: `
          linear-gradient(
            to bottom,
            rgba(78, 78, 78, 0.4) 0%,
            rgba(7, 31, 1, 0.4) 40%,
            rgba(1, 39, 19, 1) 59%,
            rgba(10, 36, 10, 1) 65%, 
            rgba(10, 36, 10, 0.5) 75%,
            rgba(0, 0, 0, 0.4) 100%
          )
        `,
      }}
    >
      <Link
        to="/explore"
        style={{ textDecoration: "none" }} // prevent underline
      >
        <button
          style={{
            position: "absolute",
            top: "58vh",
            left: "50%",
            transform: "translateX(-50%)",
            fontSize: "5rem",
            letterSpacing: "2rem",
            fontWeight: 700,
            background: "none",
            color: "#e6b000ff",
            border: "none",
            cursor: "pointer",
            zIndex: 20,

            willChange: "filter",

            filter: `
              drop-shadow(0 0 40px rgba(218, 170, 0, 0.82))
              drop-shadow(0 0 0px rgba(210,170,20,0.5))
              drop-shadow(0 0 40px rgba(0,0,0,0.9))
            `,

            WebkitFontSmoothing: "antialiased",
            MozOsxFontSmoothing: "grayscale",
          }}
        >
          UTFORSK
        </button>
      </Link>
    </div>
  );
}
