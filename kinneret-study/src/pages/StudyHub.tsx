import { motion, AnimatePresence } from 'framer-motion';
import {
  ArrowLeft,
  Layers,
  HelpCircle,
  Zap,
  BookOpen,
} from 'lucide-react';
import { useAppStore } from '../store/appStore';
import { FlashcardSession } from '../components/flashcard/FlashcardSession';
import QuizSession from '../components/quiz/QuizSession';
import SpeedRound from '../components/speed/SpeedRound';

type StudyModeId = 'flashcard' | 'quiz' | 'speed';

const MODES: {
  id: StudyModeId;
  label: string;
  description: string;
  icon: typeof Layers;
  gradient: string;
  accentColor: string;
}[] = [
  {
    id: 'flashcard',
    label: 'Flashcards',
    description: 'Review cards with spaced repetition',
    icon: Layers,
    gradient:
      'linear-gradient(135deg, rgba(79,142,247,0.15), rgba(79,142,247,0.05))',
    accentColor: 'var(--accent-blue)',
  },
  {
    id: 'quiz',
    label: 'Quiz',
    description: 'Test your knowledge with multiple choice',
    icon: HelpCircle,
    gradient:
      'linear-gradient(135deg, rgba(52,199,89,0.15), rgba(52,199,89,0.05))',
    accentColor: 'var(--accent-green)',
  },
  {
    id: 'speed',
    label: 'Speed Round',
    description: 'Fast-paced true or false challenge',
    icon: Zap,
    gradient:
      'linear-gradient(135deg, rgba(255,159,10,0.15), rgba(255,159,10,0.05))',
    accentColor: 'var(--accent-orange)',
  },
];

const pageVariants = {
  initial: { opacity: 0, y: 16 },
  animate: { opacity: 1, y: 0 },
  exit: { opacity: 0, y: -8 },
};

export default function StudyHub() {
  const { studyMode, setStudyMode } = useAppStore();

  return (
    <motion.div
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -8 }}
      transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] }}
      className="flex flex-col gap-6 pb-8"
    >
      <AnimatePresence mode="wait">
        {!studyMode ? (
          <motion.div
            key="selector"
            variants={pageVariants}
            initial="initial"
            animate="animate"
            exit="exit"
            transition={{ duration: 0.35, ease: [0.22, 1, 0.36, 1] }}
            className="flex flex-col gap-6"
          >
            {/* Page header */}
            <div className="flex items-center gap-3">
              <div
                className="flex items-center justify-center"
                style={{
                  width: '40px',
                  height: '40px',
                  borderRadius: '12px',
                  background:
                    'linear-gradient(135deg, rgba(79,142,247,0.15), rgba(191,90,242,0.15))',
                }}
              >
                <BookOpen
                  size={20}
                  style={{ color: 'var(--accent-blue)' }}
                />
              </div>
              <div>
                <h1
                  className="text-xl font-bold"
                  style={{ color: 'var(--text-primary)' }}
                >
                  Study Hub
                </h1>
                <p
                  className="text-sm"
                  style={{ color: 'var(--text-tertiary)' }}
                >
                  Choose your study mode
                </p>
              </div>
            </div>

            {/* Horizontal pill selector */}
            <div
              className="flex p-1"
              style={{
                backgroundColor: 'var(--bg-elevated)',
                borderRadius: '14px',
                border: '1px solid var(--bg-border)',
              }}
            >
              {MODES.map((mode) => {
                const Icon = mode.icon;
                return (
                  <button
                    key={mode.id}
                    onClick={() => setStudyMode(mode.id)}
                    className="flex-1 flex items-center justify-center gap-1.5 py-3 px-2 text-sm font-medium transition-all duration-200"
                    style={{
                      borderRadius: '11px',
                      background: 'none',
                      border: 'none',
                      cursor: 'pointer',
                      color: 'var(--text-secondary)',
                    }}
                    onMouseEnter={(e) => {
                      (e.currentTarget as HTMLElement).style.background =
                        'var(--bg-overlay)';
                    }}
                    onMouseLeave={(e) => {
                      (e.currentTarget as HTMLElement).style.background =
                        'none';
                    }}
                  >
                    <Icon size={16} />
                    <span>{mode.label}</span>
                  </button>
                );
              })}
            </div>

            {/* Mode cards */}
            <div className="flex flex-col gap-4">
              {MODES.map((mode, i) => {
                const Icon = mode.icon;
                return (
                  <motion.button
                    key={mode.id}
                    initial={{ opacity: 0, y: 16 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{
                      delay: i * 0.08,
                      duration: 0.4,
                      ease: [0.22, 1, 0.36, 1],
                    }}
                    onClick={() => setStudyMode(mode.id)}
                    className="flex items-center gap-4 w-full text-left transition-all duration-200"
                    style={{
                      background: mode.gradient,
                      borderRadius: '16px',
                      border: `1px solid ${mode.accentColor}22`,
                      padding: '20px',
                      cursor: 'pointer',
                    }}
                    whileHover={{ scale: 1.01, y: -1 }}
                    whileTap={{ scale: 0.99 }}
                  >
                    <div
                      className="flex items-center justify-center shrink-0"
                      style={{
                        width: '48px',
                        height: '48px',
                        borderRadius: '14px',
                        backgroundColor: `${mode.accentColor}18`,
                        border: `1px solid ${mode.accentColor}30`,
                      }}
                    >
                      <Icon size={24} style={{ color: mode.accentColor }} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <h3
                        className="text-base font-semibold mb-0.5"
                        style={{ color: 'var(--text-primary)' }}
                      >
                        {mode.label}
                      </h3>
                      <p
                        className="text-sm"
                        style={{ color: 'var(--text-secondary)' }}
                      >
                        {mode.description}
                      </p>
                    </div>
                    <div
                      className="shrink-0"
                      style={{ color: 'var(--text-tertiary)' }}
                    >
                      <svg
                        width="20"
                        height="20"
                        viewBox="0 0 20 20"
                        fill="none"
                      >
                        <path
                          d="M7.5 5L12.5 10L7.5 15"
                          stroke="currentColor"
                          strokeWidth="1.5"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        />
                      </svg>
                    </div>
                  </motion.button>
                );
              })}
            </div>
          </motion.div>
        ) : (
          <motion.div
            key={`mode-${studyMode}`}
            variants={pageVariants}
            initial="initial"
            animate="animate"
            exit="exit"
            transition={{ duration: 0.35, ease: [0.22, 1, 0.36, 1] }}
            className="flex flex-col gap-4"
          >
            {/* Back button */}
            <button
              onClick={() => setStudyMode(null)}
              className="flex items-center gap-2 self-start transition-opacity hover:opacity-70"
              style={{
                background: 'none',
                border: 'none',
                cursor: 'pointer',
                color: 'var(--accent-blue)',
                fontSize: '14px',
                fontWeight: 500,
                fontFamily: 'var(--font-ui)',
                padding: '4px 0',
              }}
            >
              <ArrowLeft size={16} />
              <span>Back to Study Hub</span>
            </button>

            {/* Active study component */}
            <div>
              {studyMode === 'flashcard' && <FlashcardSession />}
              {studyMode === 'quiz' && <QuizSession />}
              {studyMode === 'speed' && <SpeedRound />}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}
