import { useEffect, useRef } from 'react';
import { useMotionValue, useSpring, animate } from 'framer-motion';

interface AnimatedNumberProps {
  value: number;
  duration?: number;
  prefix?: string;
  suffix?: string;
  className?: string;
  decimals?: number;
}

export default function AnimatedNumber({
  value,
  duration = 1000,
  prefix = '',
  suffix = '',
  className = '',
  decimals = 0,
}: AnimatedNumberProps) {
  const motionValue = useMotionValue(0);
  const springValue = useSpring(motionValue, {
    stiffness: 100,
    damping: 30,
    mass: 1,
  });
  const ref = useRef<HTMLSpanElement>(null);
  const prevValue = useRef(0);

  useEffect(() => {
    const node = ref.current;
    if (!node) return;

    const controls = animate(prevValue.current, value, {
      duration: duration / 1000,
      ease: 'easeOut',
      onUpdate(latest) {
        node.textContent = `${prefix}${latest.toFixed(decimals)}${suffix}`;
      },
    });

    prevValue.current = value;

    return () => controls.stop();
  }, [value, duration, prefix, suffix, decimals]);

  // Keep spring in sync for potential external consumers
  useEffect(() => {
    motionValue.set(value);
  }, [value, motionValue]);

  return (
    <span
      ref={ref}
      className={className}
      style={{ fontFamily: "'DM Sans', sans-serif" }}
      aria-label={`${prefix}${value.toFixed(decimals)}${suffix}`}
    >
      {prefix}
      {(0).toFixed(decimals)}
      {suffix}
    </span>
  );
}
