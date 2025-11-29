import { CSSProperties } from "react";

export const styles: Record<string, CSSProperties> = {
  wrapper: {
    display: "flex",
    overflowX: "auto",
    gap: "12px",
    padding: "16px 0",
    scrollbarWidth: "none",
    msOverflowStyle: "none",
    touchAction: "pan-y",
  },

  card: {
    cursor: "pointer",
    display: "flex",
    flexDirection: "column",
  },

  poster: {
    width: "15vw",
    minWidth: "300px",
    borderRadius: "6px",
    objectFit: "cover",
  },

  landscape: {
    width: "12vw",
    minWidth: "400px",
    borderRadius: "6px",
    objectFit: "cover",
  },

  leftButton: {
    position: "absolute",
    left: "3rem",
    top: "50%",
    transform: "translateY(-50%)",
    padding: "10px 14px",
    cursor: "pointer",
    background: "rgba(0,0,0,0.7)",
    color: "white",
    border: "none",
    borderRadius: "50%",
    zIndex: 10,
  },

  rightButton: {
    position: "absolute",
    right: "8rem",
    top: "50%",
    transform: "translateY(-50%)",
    padding: "10px 14px",
    cursor: "pointer",
    background: "rgba(0,0,0,0.7)",
    color: "white",
    border: "none",
    borderRadius: "50%",
    zIndex: 10,
  },
};
