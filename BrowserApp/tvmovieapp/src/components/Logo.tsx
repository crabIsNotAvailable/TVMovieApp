export default function Logo() {
  return (
    <div
      style={{
        position: "absolute",
        left: "2%",
        zIndex: 9999,   // on top of absolutely everything
        fontFamily: "'Crimson Text', serif",
        fontSize: "4rem",
        letterSpacing: "0.25rem",
        color: "#e6b000ff",  // rich gold
        pointerEvents: "none", // so it doesn’t block clicks
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
  );
}