// BUBU.Market · send each visitor to the view built for their device.
//
// Loaded by BOTH index.html (desktop app) and m.html (mobile app). It looks at
// which page it is on and redirects only when the device and the page disagree,
// so there is no loop.
//
// ?desktop on a phone, or ?mobile on a computer, overrides the choice and is
// remembered for the rest of the visit.
(function () {
  var q = location.search;
  if (q.indexOf('desktop') > -1) { try { sessionStorage.setItem('bubu-view', 'desktop'); } catch (e) {} }
  if (q.indexOf('mobile') > -1)  { try { sessionStorage.setItem('bubu-view', 'mobile'); } catch (e) {} }

  var forced = null;
  try { forced = sessionStorage.getItem('bubu-view'); } catch (e) {}

  // A phone or a small touch screen. Tablets stay on the desktop app, which
  // has the room for it.
  var phone = /Android|iPhone|iPod|Windows Phone|webOS|BlackBerry/i.test(navigator.userAgent)
    || (window.matchMedia && window.matchMedia('(max-width: 820px) and (pointer: coarse)').matches);

  var want = forced === 'desktop' ? 'desktop' : forced === 'mobile' ? 'mobile' : (phone ? 'mobile' : 'desktop');
  var onMobilePage = /\/m(\.html)?$/i.test(location.pathname);

  if (want === 'mobile' && !onMobilePage) location.replace('/m.html');
  if (want === 'desktop' && onMobilePage) location.replace('/');
})();
