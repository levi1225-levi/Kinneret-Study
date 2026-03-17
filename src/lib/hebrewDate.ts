// Hebrew date display utility
// Provides a nicely formatted date string with a Hebrew decorative element.
// Uses a simplified approximation since full Hebrew calendar calculations
// are complex and would require a dedicated library.

import { format } from 'date-fns';

/**
 * Hebrew month names for decorative display.
 * This is a simplified approximation mapping Gregorian months
 * to roughly corresponding Hebrew months for the 5786 year (2025-2026).
 */
const HEBREW_MONTHS_APPROX: Record<number, string> = {
  0: 'Tevet / Shevat',       // January
  1: 'Shevat / Adar I',      // February
  2: 'Adar II',              // March (in a leap year like 5786)
  3: 'Nisan',                // April
  4: 'Iyyar',                // May
  5: 'Sivan',                // June
  6: 'Tammuz',               // July
  7: 'Av',                   // August
  8: 'Elul',                 // September
  9: 'Tishrei',              // October
  10: 'Cheshvan',            // November
  11: 'Kislev / Tevet',      // December
};

/**
 * Get the approximate Hebrew year for a given Gregorian date.
 * The Hebrew new year (Rosh Hashanah) falls in September/October.
 */
function getHebrewYear(date: Date): number {
  const gregorianYear = date.getFullYear();
  const month = date.getMonth();
  // Before Rosh Hashanah (approx September), we're in the Hebrew year
  // that started the previous fall
  if (month < 8) {
    // Jan-Aug: Hebrew year = Gregorian year + 3760
    return gregorianYear + 3760;
  }
  // Sep-Dec: Hebrew year = Gregorian year + 3761
  return gregorianYear + 3761;
}

/**
 * Returns a nicely formatted date display with an approximate Hebrew date.
 *
 * Example output: "16 Adar II 5786 -- March 16, 2026"
 *
 * Note: The Hebrew date is an approximation. Hebrew calendar days
 * don't align exactly with Gregorian days, so this is decorative
 * rather than halachically precise.
 */
export function getHebrewDateDisplay(): string {
  const now = new Date();
  const day = now.getDate();
  const hebrewMonth = HEBREW_MONTHS_APPROX[now.getMonth()] || 'Unknown';
  const hebrewYear = getHebrewYear(now);
  const gregorianFormatted = format(now, 'MMMM d, yyyy');

  return `${day} ${hebrewMonth} ${hebrewYear} \u2014 ${gregorianFormatted}`;
}
