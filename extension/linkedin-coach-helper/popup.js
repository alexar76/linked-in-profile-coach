document.getElementById('copy').addEventListener('click', async () => {
  const section = document.getElementById('section').value;
  const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
  const status = document.getElementById('status');
  if (!tab?.id) {
    status.textContent = 'No active tab';
    return;
  }
  chrome.tabs.sendMessage(tab.id, { type: 'copySection', section }, (res) => {
    if (chrome.runtime.lastError) {
      status.textContent = 'Open a LinkedIn page first';
      return;
    }
    status.textContent = res?.ok
      ? `Copied (${res.length} chars)`
      : res?.error || 'Failed';
  });
});
