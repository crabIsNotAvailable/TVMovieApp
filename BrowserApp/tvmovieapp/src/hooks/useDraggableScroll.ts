import { useRef } from "react";

export function useDraggableScroll() {
  const isDownRef = useRef(false);
  const startXRef = useRef(0);
  const scrollLeftRef = useRef(0);

  const getHandlers = (ref: React.RefObject<HTMLElement | null>) => ({
    onPointerDown: (e: React.PointerEvent) => {
      const el = ref.current;
      if (!el) return;

      isDownRef.current = true;
      el.setPointerCapture(e.pointerId);

      startXRef.current = e.clientX;
      scrollLeftRef.current = el.scrollLeft;
    },

    onPointerMove: (e: React.PointerEvent) => {
      const el = ref.current;
      if (!el || !isDownRef.current) return;

      const dx = e.clientX - startXRef.current;
      el.scrollLeft = scrollLeftRef.current - dx;
    },

    onPointerUp: (e: React.PointerEvent) => {
      const el = ref.current;
      if (!el) return;

      isDownRef.current = false;
      el.releasePointerCapture(e.pointerId);
    },
  });

  return { getHandlers };
}
