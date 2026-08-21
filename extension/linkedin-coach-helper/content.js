const SECTION_HEADERS = {
  experience: 'EXPERIENCE',
  education: 'EDUCATION',
  skills: 'SKILLS',
  about: 'ABOUT',
  headline: 'HEADLINE',
};

function guessSection() {
  const path = location.pathname.toLowerCase();
  if (path.includes('/details/experience')) return 'experience';
  if (path.includes('/details/education')) return 'education';
  if (path.includes('/details/skills')) return 'skills';
  if (path.includes('/edit/forms/intro')) return 'about';
  return 'about';
}

function extractText() {
  const main =
    document.querySelector('main') ||
    document.querySelector('[role="main"]') ||
    document.body;
  return (main.innerText || '').trim();
}

chrome.runtime.onMessage.addListener((msg, _sender, sendResponse) => {
  if (msg.type !== 'copySection') return;
  const key = msg.section || guessSection();
  const header = SECTION_HEADERS[key] || key.toUpperCase();
  const body = extractText();
  const payload = `${header}:\n${body}`;
  navigator.clipboard.writeText(payload).then(
    () => sendResponse({ ok: true, header, length: body.length }),
    (err) => sendResponse({ ok: false, error: String(err) }),
  );
  return true;
});
