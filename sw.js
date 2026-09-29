// BUBU.Market service worker. Pages always come from the network, so a deploy
// reaches the app at once; the cache only holds what the offline screen needs.
// Database and API calls are never touched.
const CACHE = 'bubu-shell-v1';
const SHELL = ['/offline.html', '/img/icon-192.png', '/img/app-icon.png'];

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(SHELL)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', (e) => {
  e.waitUntil(caches.keys()
    .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
    .then(() => self.clients.claim()));
});
self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET' || req.mode !== 'navigate') return;
  e.respondWith(fetch(req).catch(() => caches.match('/offline.html')));
});
