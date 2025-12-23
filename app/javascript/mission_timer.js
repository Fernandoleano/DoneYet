// Live Timer for Mission Time Tracking
document.addEventListener('DOMContentLoaded', () => {
  const timerDisplay = document.getElementById('timer-display');
  if (!timerDisplay) return;

  const isRunning = timerDisplay.dataset.isRunning === 'true';
  const startedAt = timerDisplay.dataset.startedAt;
  const trackedSeconds = parseInt(timerDisplay.dataset.trackedSeconds) || 0;

  if (isRunning && startedAt) {
    // Update timer every second
    setInterval(() => {
      const started = new Date(startedAt);
      const now = new Date();
      const currentSessionSeconds = Math.floor((now - started) / 1000);
      const totalSeconds = trackedSeconds + currentSessionSeconds;

      timerDisplay.textContent = formatTime(totalSeconds);
    }, 1000);
  }
});

function formatTime(totalSeconds) {
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;

  if (hours > 0) {
    return `${hours}h ${minutes}m`;
  } else if (minutes > 0) {
    return `${minutes}m ${seconds}s`;
  } else {
    return `${seconds}s`;
  }
}
