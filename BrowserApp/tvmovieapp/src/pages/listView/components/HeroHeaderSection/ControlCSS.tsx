import { CSSProperties } from "react";

export function control(side: "left" | "right"): CSSProperties {
  return {
    position: "absolute",
    top: "50%",
    transform: "translateY(-50%)",
    fontSize: "1.6rem",
    background: "rgba(0,0,0,0.5)",
    color: "white",
    border: "none",
    padding: "12px 14px",
    cursor: "pointer",
    borderRadius: 8,
    zIndex: 2000,
    [side]: -72,
  };
}
