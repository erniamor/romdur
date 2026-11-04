import puppeteer from 'puppeteer-core';
// usage: node shot.mjs URL OUT_PREFIX "t1,t2,..." [mouse actions json]
const [url, out, times, actions] = process.argv.slice(2);
const browser = await puppeteer.launch({
  executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
  headless: 'new',
  args: ['--autoplay-policy=no-user-gesture-required'],
  defaultViewport: { width: 980, height: 730, deviceScaleFactor: 1 },
});
const page = await browser.newPage();
page.on('console', (m) => console.log('[console]', m.type(), m.text()));
page.on('pageerror', (e) => console.log('[pageerror]', e.message));
await page.goto(url, { waitUntil: 'load' });
const acts = actions ? JSON.parse(actions) : [];
let elapsed = 0;
const steps = [...times.split(',').map((t) => ({ t: +t, shot: true })), ...acts.map((a) => ({ ...a, t: a.t }))].sort((a, b) => a.t - b.t);
for (const s of steps) {
  await new Promise((r) => setTimeout(r, s.t - elapsed));
  elapsed = s.t;
  if (s.shot) await page.screenshot({ path: `${out}-${s.t}.png` });
  else if (s.move) await page.mouse.move(s.move[0], s.move[1], { steps: 5 });
  else if (s.click) await page.mouse.click(s.click[0], s.click[1]);
  else if (s.clickEval) { const [x, y] = await page.evaluate(s.clickEval); console.log('[click]', x, y); await page.mouse.move(x, y); await page.mouse.down(); await page.mouse.up(); }
  else if (s.down) { await page.mouse.move(s.down[0], s.down[1]); await page.mouse.down(); }
  else if (s.up) await page.mouse.up();
  else if (s.type) await page.keyboard.type(s.type);
  else if (s.key) await page.keyboard.press(s.key);
  else if (s.eval) console.log('[eval]', JSON.stringify(await page.evaluate(s.eval)));
}
await browser.close();
