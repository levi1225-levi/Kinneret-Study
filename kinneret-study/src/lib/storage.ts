// localStorage persistence layer with versioned schema
// All app data is stored under a single key with version tracking.

import { v4 as uuidv4 } from 'uuid';
import { type CardState, createInitialCardState } from './sm2';

const STORAGE_KEY = 'kinneret_study_v1';

export interface UserSettings {
  dailyCardLimit: number;
  newCardsPerDay: number;
  sessionLength: 'quick' | 'standard' | 'deep';
  showTimer: boolean;
  autoAdvance: boolean;
  autoAdvanceDelay: number;
  darkMode: boolean;
  fontSize: 'small' | 'medium' | 'large';
  hebrewFontSize: 'small' | 'medium' | 'large';
  animationSpeed: 'full' | 'reduced' | 'none';
  showExtendedNotes: boolean;
  showMnemonicHints: boolean;
  testDate: string;
}

export interface StudySession {
  id: string;
  startTime: string;
  endTime: string | null;
  mode: 'flashcard' | 'quiz' | 'speed';
  cardsStudied: string[];
  correctCount: number;
  incorrectCount: number;
  averageTime: number;
  xpEarned: number;
}

export interface AppData {
  version: 1;
  userId: string;
  profile: {
    name: string;
    school: string;
    grade: string;
    testDate: string;
    xp: number;
    level: number;
    streak: number;
    lastStudyDate: string;
    longestStreak: number;
    totalStudyTime: number;
    achievements: string[];
  };
  cardStates: Record<string, CardState>;
  sessions: StudySession[];
  aiCache: Record<string, string>;
  settings: UserSettings;
}

/**
 * Return default user settings.
 */
export function getDefaultSettings(): UserSettings {
  return {
    dailyCardLimit: 20,
    newCardsPerDay: 10,
    sessionLength: 'standard',
    showTimer: true,
    autoAdvance: false,
    autoAdvanceDelay: 2,
    darkMode: false,
    fontSize: 'medium',
    hebrewFontSize: 'medium',
    animationSpeed: 'full',
    showExtendedNotes: true,
    showMnemonicHints: true,
    testDate: '2026-03-20',
  };
}

/**
 * Return default profile data.
 */
export function getDefaultProfile(): AppData['profile'] {
  return {
    name: '',
    school: '',
    grade: '',
    testDate: '2026-03-20',
    xp: 0,
    level: 1,
    streak: 0,
    lastStudyDate: '',
    longestStreak: 0,
    totalStudyTime: 0,
    achievements: [],
  };
}

/**
 * IDs for all 46 cards in the Kinneret study set.
 * These correspond to the card IDs used in the cards data file.
 */
const ALL_CARD_IDS: string[] = Array.from({ length: 46 }, (_, i) =>
  String(i + 1)
);

/**
 * Build the initial card states for all cards.
 */
function buildInitialCardStates(): Record<string, CardState> {
  const states: Record<string, CardState> = {};
  for (const id of ALL_CARD_IDS) {
    states[id] = createInitialCardState(id);
  }
  return states;
}

/**
 * Create a fresh AppData object with defaults.
 */
function createDefaultAppData(): AppData {
  return {
    version: 1,
    userId: uuidv4(),
    profile: getDefaultProfile(),
    cardStates: buildInitialCardStates(),
    sessions: [],
    aiCache: {},
    settings: getDefaultSettings(),
  };
}

/**
 * Load app data from localStorage.
 * If no data exists or it's corrupted, returns fresh defaults.
 */
export function loadAppData(): AppData {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      const defaults = createDefaultAppData();
      saveAppData(defaults);
      return defaults;
    }

    const parsed = JSON.parse(raw) as AppData;

    // Version check — currently only version 1 exists
    if (parsed.version !== 1) {
      console.warn(
        `Unknown storage version ${parsed.version}, resetting to defaults.`
      );
      const defaults = createDefaultAppData();
      saveAppData(defaults);
      return defaults;
    }

    // Ensure all 46 cards have states (in case new cards were added)
    for (const id of ALL_CARD_IDS) {
      if (!parsed.cardStates[id]) {
        parsed.cardStates[id] = createInitialCardState(id);
      }
    }

    // Ensure settings has all fields (backward compat)
    parsed.settings = { ...getDefaultSettings(), ...parsed.settings };
    parsed.profile = { ...getDefaultProfile(), ...parsed.profile };

    return parsed;
  } catch (err) {
    console.error('Failed to load app data, resetting:', err);
    const defaults = createDefaultAppData();
    saveAppData(defaults);
    return defaults;
  }
}

/**
 * Save app data to localStorage.
 */
export function saveAppData(data: AppData): void {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  } catch (err) {
    console.error('Failed to save app data:', err);
    // If quota exceeded, try clearing old sessions to free space
    if (err instanceof DOMException && err.name === 'QuotaExceededError') {
      try {
        // Keep only the last 50 sessions
        const trimmed = {
          ...data,
          sessions: data.sessions.slice(-50),
          aiCache: {}, // clear AI cache to free space
        };
        localStorage.setItem(STORAGE_KEY, JSON.stringify(trimmed));
      } catch (innerErr) {
        console.error('Still cannot save after trimming:', innerErr);
      }
    }
  }
}

/**
 * Export all app data as a JSON string for backup.
 */
export function exportData(): string {
  const data = loadAppData();
  return JSON.stringify(data, null, 2);
}

/**
 * Reset all progress. Generates a new userId and fresh card states.
 * Settings are preserved.
 */
export function resetAllProgress(): void {
  const current = loadAppData();
  const fresh = createDefaultAppData();

  // Preserve user settings and profile name
  fresh.settings = current.settings;
  fresh.profile.name = current.profile.name;
  fresh.profile.school = current.profile.school;
  fresh.profile.grade = current.profile.grade;
  fresh.profile.testDate = current.profile.testDate;

  saveAppData(fresh);
}
