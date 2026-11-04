import { FONT_FAMILY } from '../flash/text';

/**
 * Invitation discrète à tourner le téléphone, sous la scène, en portrait sur écran tactile.
 * Elle ne bloque rien : la scène reste utilisable. Un toucher sur l'invitation la masque.
 */
export function installRotateHint(): void {
  const query = window.matchMedia('(orientation: portrait) and (pointer: coarse)');

  const style = document.createElement('style');
  style.textContent = `
    .rotate-hint {
      position: fixed; left: 50%; bottom: calc(28px + env(safe-area-inset-bottom));
      transform: translateX(-50%);
      display: flex; align-items: center; gap: 10px;
      font: 500 13px ${FONT_FAMILY}; color: #666; letter-spacing: 0.02em;
      opacity: 0; transition: opacity 0.8s ease; pointer-events: none;
    }
    .rotate-hint.visible { opacity: 1; pointer-events: auto; }
    .rotate-hint svg { width: 22px; height: 22px; animation: rotate-hint 3.2s ease-in-out infinite; }
    @keyframes rotate-hint {
      0%, 25% { transform: rotate(0deg); }
      50%, 75% { transform: rotate(-90deg); }
      100% { transform: rotate(0deg); }
    }
    @media (prefers-reduced-motion: reduce) { .rotate-hint svg { animation: none; } }
  `;
  document.head.append(style);

  const hint = document.createElement('div');
  hint.className = 'rotate-hint';
  hint.setAttribute('role', 'status');
  hint.innerHTML = `
    <svg viewBox="0 0 22 22" aria-hidden="true" fill="none" stroke="#475656" stroke-width="1.2">
      <rect x="6.5" y="2.5" width="9" height="17" rx="1.5" fill="rgba(255,255,255,0.35)" />
      <line x1="10" y1="16.8" x2="12" y2="16.8" stroke-linecap="round" />
    </svg>
    <span>tournez votre téléphone</span>`;
  document.body.append(hint);

  let dismissed = false;
  hint.addEventListener('pointerdown', () => {
    dismissed = true;
    update();
  });
  const update = (): void => {
    hint.classList.toggle('visible', query.matches && !dismissed);
  };
  query.addEventListener('change', () => {
    // Revenir en portrait plus tard fait réapparaître l'invitation.
    if (!query.matches) dismissed = false;
    update();
  });
  // Petit délai : l'invitation arrive en fondu une fois la scène lancée.
  setTimeout(update, 1200);
}
