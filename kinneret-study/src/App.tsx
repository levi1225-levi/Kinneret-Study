import { useEffect } from 'react';
import AppShell from './components/layout/AppShell';
import { useAppStore } from './store/appStore';

function App() {
  const { initialize, initialized } = useAppStore();

  useEffect(() => {
    initialize();
  }, [initialize]);

  if (!initialized) {
    return (
      <div
        style={{
          height: '100vh',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          background: 'var(--bg-base)',
          color: 'var(--text-primary)',
          fontFamily: 'var(--font-ui)',
        }}
      >
        <div style={{ textAlign: 'center' }}>
          <div
            style={{
              fontSize: 48,
              fontWeight: 700,
              background: 'linear-gradient(135deg, #ffd60a, #ff9f0a)',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              marginBottom: 12,
              fontFamily: 'var(--font-hebrew)',
            }}
          >
            כִּנֶּרֶת
          </div>
          <div
            style={{
              fontSize: 24,
              fontWeight: 600,
              letterSpacing: '-0.02em',
              color: 'var(--text-primary)',
            }}
          >
            Kinneret Study
          </div>
          <div
            style={{
              marginTop: 24,
              width: 32,
              height: 32,
              border: '3px solid var(--bg-border-strong)',
              borderTopColor: 'var(--accent-blue)',
              borderRadius: '50%',
              animation: 'spin 0.8s linear infinite',
              margin: '24px auto 0',
            }}
          />
          <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
        </div>
      </div>
    );
  }

  return <AppShell />;
}

export default App;
