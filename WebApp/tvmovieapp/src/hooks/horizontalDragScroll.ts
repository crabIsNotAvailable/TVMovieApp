import { useEffect, useRef, useState } from "react";
import { PointerEvent } from "react";

interface UseHorizontalDragScrollOptions {
  dragThreshold?: number;
  scrollAmount?: number;
  onClickItem?: (target: HTMLElement) => void;
}

export function useHorizontalDragScroll({
  dragThreshold = 6,
  scrollAmount = 300,
  onClickItem,
}: UseHorizontalDragScrollOptions = {}) {
  const scrollRef = useRef<HTMLDivElement>(null);

  const isDragging = useRef(false);
  const startX = useRef(0);
  const lastX = useRef(0);

  const [canScrollLeft, setCanScrollLeft] = useState(false);
  const [canScrollRight, setCanScrollRight] = useState(false);

  const updateScrollButtons = () => {
    const el = scrollRef.current;
    if (!el) return;

    setCanScrollLeft(el.scrollLeft > 0);
    setCanScrollRight(el.scrollLeft + el.clientWidth < el.scrollWidth);
  };

  useEffect(() => {
    updateScrollButtons();
    window.addEventListener("resize", updateScrollButtons);
    return () => window.removeEventListener("resize", updateScrollButtons);
  }, []);

  const scrollByAmount = (direction: "left" | "right") => {
    const amount = direction === "left" ? -scrollAmount : scrollAmount;
    scrollRef.current?.scrollBy({ left: amount, behavior: "smooth" });
    setTimeout(updateScrollButtons, 300);
  };

  const handlePointerDown = (e: PointerEvent<HTMLDivElement>) => {
    isDragging.current = false;
    startX.current = e.clientX;
    lastX.current = e.clientX;

    scrollRef.current?.setPointerCapture(e.pointerId);
  };

  const handlePointerMove = (e: PointerEvent<HTMLDivElement>) => {
    if (!scrollRef.current || e.buttons !== 1) return;

    const dxFromStart = e.clientX - startX.current;

    if (!isDragging.current && Math.abs(dxFromStart) > dragThreshold) {
      isDragging.current = true;
    }

    if (!isDragging.current) return;

    const dx = e.clientX - lastX.current;
    scrollRef.current.scrollLeft -= dx;
    lastX.current = e.clientX;

    updateScrollButtons();
  };

  const handlePointerUp = (e: PointerEvent<HTMLDivElement>) => {
    scrollRef.current?.releasePointerCapture(e.pointerId);

    if (!isDragging.current && onClickItem) {
      const el = document.elementFromPoint(e.clientX, e.clientY);
      const card = el?.closest<HTMLElement>("[data-urlpath]");
      if (card) onClickItem(card);
    }
  };

  return {
    scrollRef,
    canScrollLeft,
    canScrollRight,
    scrollLeft: () => scrollByAmount("left"),
    scrollRight: () => scrollByAmount("right"),
    handlers: {
      onPointerDown: handlePointerDown,
      onPointerMove: handlePointerMove,
      onPointerUp: handlePointerUp,
      onScroll: updateScrollButtons,
    },
  };
}
