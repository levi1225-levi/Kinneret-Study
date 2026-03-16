import { create } from 'zustand';
import type { CardState, SM2Grade } from '../lib/sm2';
import {
  processGrade,
  createInitialCardState,
  getStudyQueue,
  isCardDue,
} from '../lib/sm2';
import type { AppData, StudySession, UserSettings } from '../lib/storage';
import {
  loadAppData,
  saveAppData,
  getDefaultSettings,
} from '../lib/storage';
import {
  calculateXPForReview,
  calculateSessionBonusXP,
  getLevelInfo,
} from '../lib/xp';
import { checkAchievements, ACHIEVEMENTS } from '../lib/achievements';
import { CARDS } from '../data/cards';

interface AppStore {
  // Data
  data: AppData;
  initialized: boolean;

  // Current session state
  currentSession: StudySession | null;
  currentCardIndex: number;
  studyQueue: string[];
  isFlipped: boolean;
  sessionStartTime: number;
  cardStartTime: number;

  // Quiz state
  quizAnswers: Record<string, { selectedIndex: number; correct: boolean; timeMs: number }>;

  // Speed round state
  speedScore: number;
  speedCombo: number;
  speedHighScore: number;

  // AI state
  aiTutorMessages: { role: 'user' | 'assistant'; content: string }[];
  aiTutorLoading: boolean;
  aiInsight: string | null;

  // UI state
  activeTab: 'home' | 'study' | 'analytics' | 'sources' | 'settings';
  studyMode: 'flashcard' | 'quiz' | 'speed' | null;
  showSessionComplete: boolean;
  toasts: { id: string; message: string; type: 'success' | 'error' | 'achievement' | 'xp'; icon?: string }[];
  showAITutor: boolean;
  showLevelUp: boolean;
  newLevel: number | null;

  // Actions
  initialize: () => void;
  setActiveTab: (tab: AppStore['activeTab']) => void;
  setStudyMode: (mode: AppStore['studyMode']) => void;

  // Flashcard actions
  startFlashcardSession: () => void;
  flipCard: () => void;
  gradeCard: (grade: SM2Grade) => void;
  nextCard: () => void;
  endSession: () => void;

  // Quiz actions
  startQuizSession: () => void;
  answerQuiz: (questionIndex: number, selectedIndex: number, correct: boolean, timeMs: number) => void;
  endQuizSession: () => void;

  // Speed round actions
  startSpeedRound: () => void;
  speedAnswer: (correct: boolean) => void;
  endSpeedRound: () => void;

  // Settings
  updateSettings: (settings: Partial<UserSettings>) => void;
  updateProfile: (profile: Partial<AppData['profile']>) => void;
  resetProgress: () => void;
  exportData: () => string;

  // AI
  toggleAITutor: () => void;
  sendAITutorMessage: (message: string) => void;
  setAIInsight: (insight: string) => void;

  // Toast/notifications
  addToast: (toast: Omit<AppStore['toasts'][0], 'id'>) => void;
  removeToast: (id: string) => void;
  dismissLevelUp: () => void;

  // Streak
  updateStreak: () => void;

  // Helpers
  getDueCardCount: () => number;
  getMasteredCount: () => number;
  getCardState: (cardId: string) => CardState;
  getTodayXP: () => number;
}

function generateId(): string {
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    return crypto.randomUUID();
  }
  return Date.now().toString(36) + Math.random().toString(36).slice(2);
}

function isSameDay(a: number, b: number): boolean {
  const da = new Date(a);
  const db = new Date(b);
  return (
    da.getFullYear() === db.getFullYear() &&
    da.getMonth() === db.getMonth() &&
    da.getDate() === db.getDate()
  );
}

function isYesterday(timestamp: number): boolean {
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  const d = new Date(timestamp);
  return (
    d.getFullYear() === yesterday.getFullYear() &&
    d.getMonth() === yesterday.getMonth() &&
    d.getDate() === yesterday.getDate()
  );
}

function startOfToday(): number {
  const now = new Date();
  now.setHours(0, 0, 0, 0);
  return now.getTime();
}

const defaultData: AppData = {
  cardStates: {},
  sessions: [],
  settings: getDefaultSettings(),
  profile: {
    totalXP: 0,
    streak: 0,
    longestStreak: 0,
    lastStudyDate: 0,
    achievements: [],
  },
};

export const useAppStore = create<AppStore>((set, get) => ({
  // Data
  data: defaultData,
  initialized: false,

  // Current session state
  currentSession: null,
  currentCardIndex: 0,
  studyQueue: [],
  isFlipped: false,
  sessionStartTime: 0,
  cardStartTime: 0,

  // Quiz state
  quizAnswers: {},

  // Speed round state
  speedScore: 0,
  speedCombo: 1,
  speedHighScore: 0,

  // AI state
  aiTutorMessages: [],
  aiTutorLoading: false,
  aiInsight: null,

  // UI state
  activeTab: 'home',
  studyMode: null,
  showSessionComplete: false,
  toasts: [],
  showAITutor: false,
  showLevelUp: false,
  newLevel: null,

  // Actions
  initialize: () => {
    const data = loadAppData();
    set({ data, initialized: true });
    get().updateStreak();
  },

  setActiveTab: (tab) => {
    set({ activeTab: tab });
  },

  setStudyMode: (mode) => {
    set({ studyMode: mode });
  },

  // Flashcard actions
  startFlashcardSession: () => {
    const { data } = get();
    const queue = getStudyQueue(data.cardStates, CARDS);
    const limited = queue.slice(0, data.settings.dailyCardLimit);

    const session: StudySession = {
      id: generateId(),
      mode: 'flashcard',
      startTime: Date.now(),
      endTime: 0,
      cardsStudied: 0,
      correctCount: 0,
      incorrectCount: 0,
      xpEarned: 0,
    };

    set({
      currentSession: session,
      studyQueue: limited,
      currentCardIndex: 0,
      isFlipped: false,
      sessionStartTime: Date.now(),
      cardStartTime: Date.now(),
      showSessionComplete: false,
    });
  },

  flipCard: () => {
    set({ isFlipped: true });
  },

  gradeCard: (grade: SM2Grade) => {
    const state = get();
    const { data, studyQueue, currentCardIndex, currentSession } = state;

    if (!currentSession || currentCardIndex >= studyQueue.length) return;

    const cardId = studyQueue[currentCardIndex];
    const currentCardState =
      data.cardStates[cardId] || createInitialCardState(cardId);

    const oldLevel = getLevelInfo(data.profile.totalXP).level;

    // Process the grade through SM2
    const updatedCardState = processGrade(currentCardState, grade);

    // Calculate XP
    const xpEarned = calculateXPForReview(grade, updatedCardState);

    // Update data
    const newCardStates = {
      ...data.cardStates,
      [cardId]: updatedCardState,
    };

    const newProfile = {
      ...data.profile,
      totalXP: data.profile.totalXP + xpEarned,
      lastStudyDate: Date.now(),
    };

    const newData: AppData = {
      ...data,
      cardStates: newCardStates,
      profile: newProfile,
    };

    // Check for level up
    const newLevelInfo = getLevelInfo(newProfile.totalXP);
    let showLevelUp = false;
    let newLevel: number | null = null;
    if (newLevelInfo.level > oldLevel) {
      showLevelUp = true;
      newLevel = newLevelInfo.level;
    }

    // Check achievements
    const newAchievements = checkAchievements(newData);
    const unlockedAchievements = newAchievements.filter(
      (a) => !data.profile.achievements.includes(a)
    );
    newData.profile.achievements = [
      ...new Set([...data.profile.achievements, ...newAchievements]),
    ];

    // Update session
    const isCorrect = grade >= 3;
    const updatedSession: StudySession = {
      ...currentSession,
      cardsStudied: currentSession.cardsStudied + 1,
      correctCount: currentSession.correctCount + (isCorrect ? 1 : 0),
      incorrectCount: currentSession.incorrectCount + (isCorrect ? 0 : 1),
      xpEarned: currentSession.xpEarned + xpEarned,
    };

    // Save to localStorage
    saveAppData(newData);

    // Show XP toast
    if (xpEarned > 0) {
      get().addToast({ message: `+${xpEarned} XP`, type: 'xp' });
    }

    // Show achievement toasts
    for (const achievementId of unlockedAchievements) {
      const achievement = ACHIEVEMENTS.find((a) => a.id === achievementId);
      if (achievement) {
        get().addToast({
          message: `Achievement: ${achievement.name}`,
          type: 'achievement',
          icon: achievement.icon,
        });
      }
    }

    const isLastCard = currentCardIndex >= studyQueue.length - 1;

    set({
      data: newData,
      currentSession: updatedSession,
      showLevelUp,
      newLevel,
    });

    if (isLastCard) {
      get().endSession();
    } else {
      get().nextCard();
    }
  },

  nextCard: () => {
    set((state) => ({
      currentCardIndex: state.currentCardIndex + 1,
      isFlipped: false,
      cardStartTime: Date.now(),
    }));
  },

  endSession: () => {
    const { currentSession, data } = get();
    if (!currentSession) return;

    const finalizedSession: StudySession = {
      ...currentSession,
      endTime: Date.now(),
    };

    // Calculate session bonus XP
    const bonusXP = calculateSessionBonusXP(finalizedSession);
    finalizedSession.xpEarned += bonusXP;

    // Add session to history (keep last 90)
    const sessions = [...data.sessions, finalizedSession].slice(-90);

    const newProfile = {
      ...data.profile,
      totalXP: data.profile.totalXP + bonusXP,
      lastStudyDate: Date.now(),
    };

    // Update streak
    if (!isSameDay(data.profile.lastStudyDate, Date.now())) {
      newProfile.streak = (newProfile.streak || 0) + 1;
      if (newProfile.streak > newProfile.longestStreak) {
        newProfile.longestStreak = newProfile.streak;
      }
    }

    const newData: AppData = {
      ...data,
      sessions,
      profile: newProfile,
    };

    saveAppData(newData);

    if (bonusXP > 0) {
      get().addToast({ message: `Session bonus: +${bonusXP} XP`, type: 'xp' });
    }

    set({
      data: newData,
      currentSession: finalizedSession,
      showSessionComplete: true,
      studyMode: null,
    });
  },

  // Quiz actions
  startQuizSession: () => {
    const session: StudySession = {
      id: generateId(),
      mode: 'quiz',
      startTime: Date.now(),
      endTime: 0,
      cardsStudied: 0,
      correctCount: 0,
      incorrectCount: 0,
      xpEarned: 0,
    };

    set({
      currentSession: session,
      quizAnswers: {},
      sessionStartTime: Date.now(),
      showSessionComplete: false,
    });
  },

  answerQuiz: (questionIndex, selectedIndex, correct, timeMs) => {
    const { data, currentSession } = get();
    if (!currentSession) return;

    const questionKey = questionIndex.toString();

    // Find the related card for this question
    const card = CARDS[questionIndex];
    if (card) {
      const cardState =
        data.cardStates[card.id] || createInitialCardState(card.id);
      const grade: SM2Grade = correct ? 3 : 0;
      const updatedCardState = processGrade(cardState, grade);
      const xpEarned = calculateXPForReview(grade, updatedCardState);

      const newCardStates = {
        ...data.cardStates,
        [card.id]: updatedCardState,
      };

      const newProfile = {
        ...data.profile,
        totalXP: data.profile.totalXP + xpEarned,
        lastStudyDate: Date.now(),
      };

      const newData: AppData = {
        ...data,
        cardStates: newCardStates,
        profile: newProfile,
      };

      // Check achievements
      const newAchievements = checkAchievements(newData);
      newData.profile.achievements = [
        ...new Set([...data.profile.achievements, ...newAchievements]),
      ];

      saveAppData(newData);

      const updatedSession: StudySession = {
        ...currentSession,
        cardsStudied: currentSession.cardsStudied + 1,
        correctCount: currentSession.correctCount + (correct ? 1 : 0),
        incorrectCount: currentSession.incorrectCount + (correct ? 0 : 1),
        xpEarned: currentSession.xpEarned + xpEarned,
      };

      set({
        data: newData,
        currentSession: updatedSession,
        quizAnswers: {
          ...get().quizAnswers,
          [questionKey]: { selectedIndex, correct, timeMs },
        },
      });

      if (xpEarned > 0) {
        get().addToast({ message: `+${xpEarned} XP`, type: 'xp' });
      }
    } else {
      set({
        quizAnswers: {
          ...get().quizAnswers,
          [questionKey]: { selectedIndex, correct, timeMs },
        },
      });
    }
  },

  endQuizSession: () => {
    get().endSession();
  },

  // Speed round actions
  startSpeedRound: () => {
    const session: StudySession = {
      id: generateId(),
      mode: 'speed',
      startTime: Date.now(),
      endTime: 0,
      cardsStudied: 0,
      correctCount: 0,
      incorrectCount: 0,
      xpEarned: 0,
    };

    set({
      currentSession: session,
      speedScore: 0,
      speedCombo: 1,
      sessionStartTime: Date.now(),
      showSessionComplete: false,
    });
  },

  speedAnswer: (correct) => {
    const { speedScore, speedCombo, speedHighScore, currentSession } = get();
    if (!currentSession) return;

    let newScore = speedScore;
    let newCombo = speedCombo;

    if (correct) {
      newScore += 1 * speedCombo;
      newCombo = Math.min(speedCombo + 1, 3);
    } else {
      newCombo = 1;
    }

    const newHighScore = Math.max(speedHighScore, newScore);

    const updatedSession: StudySession = {
      ...currentSession,
      cardsStudied: currentSession.cardsStudied + 1,
      correctCount: currentSession.correctCount + (correct ? 1 : 0),
      incorrectCount: currentSession.incorrectCount + (correct ? 0 : 1),
    };

    set({
      speedScore: newScore,
      speedCombo: newCombo,
      speedHighScore: newHighScore,
      currentSession: updatedSession,
    });
  },

  endSpeedRound: () => {
    get().endSession();
  },

  // Settings
  updateSettings: (settings) => {
    const { data } = get();
    const newSettings = { ...data.settings, ...settings };
    const newData: AppData = { ...data, settings: newSettings };

    // Apply dark mode
    if (settings.darkMode !== undefined) {
      if (settings.darkMode) {
        document.documentElement.classList.remove('light');
      } else {
        document.documentElement.classList.add('light');
      }
    }

    saveAppData(newData);
    set({ data: newData });
  },

  updateProfile: (profile) => {
    const { data } = get();
    const newProfile = { ...data.profile, ...profile };
    const newData: AppData = { ...data, profile: newProfile };
    saveAppData(newData);
    set({ data: newData });
  },

  resetProgress: () => {
    const { data } = get();
    const newData: AppData = {
      ...data,
      cardStates: {},
      sessions: [],
      profile: {
        totalXP: 0,
        streak: 0,
        longestStreak: 0,
        lastStudyDate: 0,
        achievements: [],
      },
    };
    saveAppData(newData);
    set({ data: newData });
    get().addToast({ message: 'Progress has been reset', type: 'success' });
  },

  exportData: () => {
    const { data } = get();
    return JSON.stringify(data, null, 2);
  },

  // AI
  toggleAITutor: () => {
    set((state) => ({ showAITutor: !state.showAITutor }));
  },

  sendAITutorMessage: (message) => {
    const { aiTutorMessages } = get();
    const newMessages = [
      ...aiTutorMessages,
      { role: 'user' as const, content: message },
    ];
    set({ aiTutorMessages: newMessages, aiTutorLoading: true });

    // AI response will be handled by the component/service that calls this
    // This just updates the message state
  },

  setAIInsight: (insight) => {
    set({ aiInsight: insight });
  },

  // Toast/notifications
  addToast: (toast) => {
    const id = generateId();
    const fullToast = { ...toast, id };
    set((state) => ({ toasts: [...state.toasts, fullToast] }));

    // Auto-remove after 3 seconds
    setTimeout(() => {
      get().removeToast(id);
    }, 3000);
  },

  removeToast: (id) => {
    set((state) => ({
      toasts: state.toasts.filter((t) => t.id !== id),
    }));
  },

  dismissLevelUp: () => {
    set({ showLevelUp: false, newLevel: null });
  },

  // Streak
  updateStreak: () => {
    const { data } = get();
    const now = Date.now();
    const { lastStudyDate, streak, longestStreak } = data.profile;

    if (!lastStudyDate) {
      // Never studied before, no changes needed
      return;
    }

    if (isSameDay(lastStudyDate, now)) {
      // Already studied today, no streak change
      return;
    }

    let newStreak = streak;

    if (isYesterday(lastStudyDate)) {
      // Studied yesterday, streak continues (will increment when they study today)
      // No change needed here
      return;
    }

    // Last study was more than a day ago, reset streak
    newStreak = 0;

    const newProfile = {
      ...data.profile,
      streak: newStreak,
      longestStreak: Math.max(longestStreak, newStreak),
    };

    const newData: AppData = { ...data, profile: newProfile };
    saveAppData(newData);
    set({ data: newData });
  },

  // Helpers
  getDueCardCount: () => {
    const { data } = get();
    return CARDS.filter((card) => {
      const cardState = data.cardStates[card.id];
      if (!cardState) return true; // New cards are due
      return isCardDue(cardState);
    }).length;
  },

  getMasteredCount: () => {
    const { data } = get();
    return Object.values(data.cardStates).filter(
      (cs) => (cs as CardState).interval >= 21
    ).length;
  },

  getCardState: (cardId: string) => {
    const { data } = get();
    return data.cardStates[cardId] || createInitialCardState(cardId);
  },

  getTodayXP: () => {
    const { data } = get();
    const todayStart = startOfToday();
    return data.sessions
      .filter((s) => s.startTime >= todayStart)
      .reduce((sum, s) => sum + s.xpEarned, 0);
  },
}));
