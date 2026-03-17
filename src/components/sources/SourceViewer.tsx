import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Link,
  BookOpen,
  ScrollText,
  Shield,
  Globe,
  AlertTriangle,
  CheckCircle,
  Scale,
} from 'lucide-react';
import ChainDiagram from './ChainDiagram';

type TabId = 'chain' | 'rambam' | 'written';

interface Tab {
  id: TabId;
  label: string;
}

const TABS: Tab[] = [
  { id: 'chain', label: 'Pirkei Avot 1:1' },
  { id: 'rambam', label: 'Rambam on Exodus' },
  { id: 'written', label: 'Why Written Down?' },
];

const slideVariants = {
  enter: (direction: number) => ({
    x: direction > 0 ? 200 : -200,
    opacity: 0,
  }),
  center: { x: 0, opacity: 1 },
  exit: (direction: number) => ({
    x: direction > 0 ? -200 : 200,
    opacity: 0,
  }),
};

const REASONS = [
  {
    icon: Shield,
    title: 'Roman Persecution',
    text: 'The brutal Roman occupation threatened Jewish life. Rabbis and scholars were being killed, and the continuity of oral transmission was in mortal danger. The very survival of Torah knowledge was at stake.',
  },
  {
    icon: Globe,
    title: 'Exile and Dispersion',
    text: 'Jewish communities were scattered across the Roman Empire and beyond. Without a central authority, different communities risked developing divergent traditions and forgetting key teachings.',
  },
  {
    icon: AlertTriangle,
    title: 'Fear of Forgetting',
    text: 'As the chain of transmission grew longer and the number of students multiplied, there was increasing concern that details would be lost or distorted through purely oral transmission.',
  },
  {
    icon: CheckCircle,
    title: 'Preserving Accuracy',
    text: 'Writing allowed for precise preservation of legal rulings, debates, and minority opinions. A written text could be checked and verified in ways that memory alone could not guarantee.',
  },
  {
    icon: Scale,
    title: 'Growing Legal Complexity',
    text: 'Over centuries, the body of oral law had grown enormously. The sheer volume of legal discussions, precedents, and rulings made it impractical to rely solely on memorization.',
  },
];

export default function SourceViewer() {
  const [activeTab, setActiveTab] = useState<TabId>('chain');
  const [direction, setDirection] = useState(0);
  const [showShimmer, setShowShimmer] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => setShowShimmer(false), 3500);
    return () => clearTimeout(timer);
  }, []);

  const handleTabChange = (tab: TabId) => {
    const oldIndex = TABS.findIndex((t) => t.id === activeTab);
    const newIndex = TABS.findIndex((t) => t.id === tab);
    setDirection(newIndex > oldIndex ? 1 : -1);
    setActiveTab(tab);
  };

  return (
    <div className="flex flex-col gap-5">
      {/* Pill tab selector */}
      <div
        className="relative flex p-1 mx-auto w-full max-w-lg"
        style={{
          backgroundColor: 'var(--bg-elevated)',
          borderRadius: '12px',
          border: '1px solid var(--bg-border)',
        }}
      >
        {TABS.map((tab) => (
          <button
            key={tab.id}
            onClick={() => handleTabChange(tab.id)}
            className="relative flex-1 z-10 py-2.5 px-3 text-sm font-medium transition-colors duration-200"
            style={{
              color:
                activeTab === tab.id
                  ? 'var(--text-primary)'
                  : 'var(--text-tertiary)',
              background: 'none',
              border: 'none',
              cursor: 'pointer',
              borderRadius: '10px',
            }}
          >
            {activeTab === tab.id && (
              <motion.div
                layoutId="source-tab-pill"
                className="absolute inset-0"
                style={{
                  backgroundColor: 'var(--bg-overlay)',
                  borderRadius: '10px',
                  border: '1px solid var(--bg-border-strong)',
                }}
                transition={{ type: 'spring', stiffness: 400, damping: 30 }}
              />
            )}
            <span className="relative z-10">{tab.label}</span>
          </button>
        ))}
      </div>

      {/* Tab content */}
      <div className="relative overflow-hidden" style={{ minHeight: '400px' }}>
        <AnimatePresence mode="wait" custom={direction}>
          {activeTab === 'chain' && (
            <motion.div
              key="chain"
              custom={direction}
              variants={slideVariants}
              initial="enter"
              animate="center"
              exit="exit"
              transition={{ duration: 0.35, ease: [0.22, 1, 0.36, 1] }}
            >
              <ChainTab showShimmer={showShimmer} />
            </motion.div>
          )}
          {activeTab === 'rambam' && (
            <motion.div
              key="rambam"
              custom={direction}
              variants={slideVariants}
              initial="enter"
              animate="center"
              exit="exit"
              transition={{ duration: 0.35, ease: [0.22, 1, 0.36, 1] }}
            >
              <RambamTab />
            </motion.div>
          )}
          {activeTab === 'written' && (
            <motion.div
              key="written"
              custom={direction}
              variants={slideVariants}
              initial="enter"
              animate="center"
              exit="exit"
              transition={{ duration: 0.35, ease: [0.22, 1, 0.36, 1] }}
            >
              <WrittenTab />
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}

/* ── Tab 1: Chain of Transmission ── */
function ChainTab({ showShimmer }: { showShimmer: boolean }) {
  return (
    <div className="flex flex-col gap-6">
      {/* Header card */}
      <div
        style={{
          backgroundColor: 'var(--bg-elevated)',
          borderRadius: '16px',
          border: '1px solid var(--bg-border)',
          padding: '24px',
          boxShadow: 'var(--shadow-md)',
        }}
      >
        <div className="flex items-center gap-2 mb-4">
          <Link size={18} style={{ color: 'var(--accent-gold)' }} />
          <h3
            className="text-base font-semibold"
            style={{ color: 'var(--text-primary)' }}
          >
            The Chain of Transmission
          </h3>
        </div>

        {/* Hebrew text */}
        <p
          lang="he"
          dir="rtl"
          className={showShimmer ? 'hebrew-shimmer' : ''}
          style={{
            fontFamily: "var(--font-hebrew)",
            fontSize: '22px',
            lineHeight: 1.8,
            color: showShimmer ? undefined : 'var(--text-primary)',
            marginBottom: '16px',
          }}
        >
          משה קיבל תורה מסיני, ומסרה ליהושע, ויהושע לזקנים, וזקנים לנביאים,
          ונביאים מסרוה לאנשי כנסת הגדולה.
        </p>

        {/* English translation */}
        <p
          className="text-sm leading-relaxed"
          style={{ color: 'var(--text-secondary)' }}
        >
          Moses received the Torah from Sinai and transmitted it to Joshua; Joshua
          to the Elders; the Elders to the Prophets; and the Prophets transmitted
          it to the Men of the Great Assembly.
        </p>
      </div>

      {/* Chain diagram */}
      <div
        style={{
          backgroundColor: 'var(--bg-elevated)',
          borderRadius: '16px',
          border: '1px solid var(--bg-border)',
          padding: '24px',
          boxShadow: 'var(--shadow-md)',
        }}
      >
        <h4
          className="text-sm font-semibold mb-4 text-center"
          style={{ color: 'var(--text-secondary)', letterSpacing: '0.05em' }}
        >
          CHAIN OF TRANSMISSION
        </h4>
        <ChainDiagram />
      </div>
    </div>
  );
}

/* ── Tab 2: Rambam on Exodus 24:12 ── */
function RambamTab() {
  return (
    <div className="flex flex-col gap-6">
      {/* Verse card */}
      <div
        style={{
          backgroundColor: 'var(--bg-elevated)',
          borderRadius: '16px',
          border: '1px solid var(--bg-border)',
          padding: '24px',
          boxShadow: 'var(--shadow-md)',
        }}
      >
        <div className="flex items-center gap-2 mb-4">
          <BookOpen size={18} style={{ color: 'var(--accent-blue)' }} />
          <h3
            className="text-base font-semibold"
            style={{ color: 'var(--text-primary)' }}
          >
            Exodus 24:12 &mdash; Rambam&apos;s Reading
          </h3>
        </div>

        {/* Hebrew verse with highlights */}
        <p
          lang="he"
          dir="rtl"
          className="text-center"
          style={{
            fontFamily: "var(--font-hebrew)",
            fontSize: '24px',
            lineHeight: 2,
            color: 'var(--text-primary)',
            marginBottom: '16px',
          }}
        >
          {'וְאֶתְּנָה לְךָ אֶת לֻחֹת הָאֶבֶן וְ'}
          <span
            style={{
              color: '#4f8ef7',
              textShadow: '0 0 20px rgba(79,142,247,0.3)',
              fontWeight: 700,
            }}
          >
            הַתּוֹרָה
          </span>
          {' וְ'}
          <span
            style={{
              color: '#ffd60a',
              textShadow: '0 0 20px rgba(255,214,10,0.3)',
              fontWeight: 700,
            }}
          >
            הַמִּצְוָה
          </span>
        </p>

        {/* English translation */}
        <p
          className="text-sm text-center leading-relaxed"
          style={{ color: 'var(--text-secondary)' }}
        >
          &ldquo;And I will give you the tablets of stone, and{' '}
          <span style={{ color: '#4f8ef7', fontWeight: 600 }}>the Torah</span>{' '}
          and{' '}
          <span style={{ color: '#ffd60a', fontWeight: 600 }}>
            the commandment
          </span>
          &rdquo;
        </p>
      </div>

      {/* Rambam's explanation */}
      <div
        style={{
          backgroundColor: 'var(--bg-elevated)',
          borderRadius: '16px',
          border: '1px solid var(--bg-border)',
          padding: '24px',
          boxShadow: 'var(--shadow-md)',
        }}
      >
        <div className="flex items-center gap-2 mb-4">
          <ScrollText size={18} style={{ color: 'var(--accent-purple)' }} />
          <h4
            className="text-base font-semibold"
            style={{ color: 'var(--text-primary)' }}
          >
            Rambam&apos;s Explanation
          </h4>
        </div>

        <div className="flex flex-col gap-4">
          {/* Torah = Written Law */}
          <div
            className="flex gap-3 p-4"
            style={{
              backgroundColor: 'rgba(79,142,247,0.08)',
              borderRadius: '12px',
              border: '1px solid rgba(79,142,247,0.15)',
            }}
          >
            <div
              className="shrink-0 flex items-center justify-center"
              style={{
                width: '36px',
                height: '36px',
                borderRadius: '10px',
                backgroundColor: 'rgba(79,142,247,0.15)',
              }}
            >
              <BookOpen size={18} style={{ color: '#4f8ef7' }} />
            </div>
            <div>
              <p
                className="text-sm font-semibold mb-1"
                style={{ color: '#4f8ef7' }}
              >
                &ldquo;HaTorah&rdquo; = The Written Torah
              </p>
              <p
                className="text-sm leading-relaxed"
                style={{ color: 'var(--text-secondary)' }}
              >
                The Rambam explains that &ldquo;HaTorah&rdquo; refers to the
                Written Law &mdash; the Five Books of Moses (Chumash) that were
                given in written form at Sinai. This is the text that every Jew
                can read in the Torah scroll.
              </p>
            </div>
          </div>

          {/* Mitzvah = Oral Law */}
          <div
            className="flex gap-3 p-4"
            style={{
              backgroundColor: 'rgba(255,214,10,0.06)',
              borderRadius: '12px',
              border: '1px solid rgba(255,214,10,0.15)',
            }}
          >
            <div
              className="shrink-0 flex items-center justify-center"
              style={{
                width: '36px',
                height: '36px',
                borderRadius: '10px',
                backgroundColor: 'rgba(255,214,10,0.12)',
              }}
            >
              <ScrollText size={18} style={{ color: '#ffd60a' }} />
            </div>
            <div>
              <p
                className="text-sm font-semibold mb-1"
                style={{ color: '#ffd60a' }}
              >
                &ldquo;HaMitzvah&rdquo; = The Oral Law
              </p>
              <p
                className="text-sm leading-relaxed"
                style={{ color: 'var(--text-secondary)' }}
              >
                The word &ldquo;HaMitzvah&rdquo; refers to its interpretation
                &mdash; the Oral Law. This includes explanations, applications,
                and details of how to fulfill the commandments. The Oral Torah was
                meant to be transmitted by word of mouth from teacher to student.
              </p>
            </div>
          </div>
        </div>

        {/* Summary */}
        <div
          className="mt-5 p-4 text-center"
          style={{
            backgroundColor: 'var(--bg-overlay)',
            borderRadius: '12px',
            border: '1px solid var(--bg-border)',
          }}
        >
          <p
            className="text-sm font-medium leading-relaxed"
            style={{ color: 'var(--text-primary)' }}
          >
            <span style={{ color: '#4f8ef7' }}>Torah</span> = Written Law
            &nbsp;&bull;&nbsp;{' '}
            <span style={{ color: '#ffd60a' }}>Mitzvah</span> = Oral Law
            Interpretation
          </p>
          <p
            className="text-xs mt-2"
            style={{ color: 'var(--text-tertiary)' }}
          >
            Both were given at Sinai &mdash; one in writing, one by word of mouth.
          </p>
        </div>
      </div>
    </div>
  );
}

/* ── Tab 3: Why Written Down? ── */
function WrittenTab() {
  return (
    <div className="flex flex-col gap-4">
      <div
        className="text-center mb-2"
        style={{
          backgroundColor: 'var(--bg-elevated)',
          borderRadius: '16px',
          border: '1px solid var(--bg-border)',
          padding: '20px 24px',
          boxShadow: 'var(--shadow-md)',
        }}
      >
        <h3
          className="text-base font-semibold mb-2"
          style={{ color: 'var(--text-primary)' }}
        >
          Why Was the Oral Law Written Down?
        </h3>
        <p className="text-sm" style={{ color: 'var(--text-secondary)' }}>
          According to the Rambam, five critical factors compelled Rabbi Yehudah
          HaNasi to compile the Mishnah and commit the Oral Law to writing.
        </p>
      </div>

      {REASONS.map((reason, i) => {
        const Icon = reason.icon;
        return (
          <motion.div
            key={reason.title}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{
              delay: i * 0.1,
              duration: 0.45,
              ease: [0.22, 1, 0.36, 1],
            }}
            style={{
              backgroundColor: 'var(--bg-elevated)',
              borderRadius: '16px',
              border: '1px solid var(--bg-border)',
              padding: '20px',
              boxShadow: 'var(--shadow-sm)',
            }}
          >
            <div className="flex gap-4">
              {/* Number + Icon */}
              <div className="shrink-0 flex flex-col items-center gap-2">
                <div
                  className="flex items-center justify-center text-sm font-bold"
                  style={{
                    width: '36px',
                    height: '36px',
                    borderRadius: '10px',
                    background:
                      'linear-gradient(135deg, var(--accent-orange), var(--accent-red))',
                    color: '#fff',
                  }}
                >
                  {i + 1}
                </div>
                <Icon
                  size={16}
                  style={{ color: 'var(--text-tertiary)' }}
                />
              </div>

              {/* Content */}
              <div className="flex-1 min-w-0">
                <h4
                  className="text-sm font-semibold mb-1.5"
                  style={{ color: 'var(--text-primary)' }}
                >
                  {reason.title}
                </h4>
                <p
                  className="text-sm leading-relaxed"
                  style={{ color: 'var(--text-secondary)' }}
                >
                  {reason.text}
                </p>
              </div>
            </div>
          </motion.div>
        );
      })}
    </div>
  );
}
