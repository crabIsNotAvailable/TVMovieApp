// Helper math functions for Carousel

export function clamp(v: number, min: number, max: number) {
  return Math.max(min, Math.min(max, v));
}

export function signedDistanceFor(i: number, index: number, n: number) {
  let raw = i - index;
  if (raw > n / 2) raw -= n;
  if (raw < -n / 2) raw += n;
  return raw;
}
