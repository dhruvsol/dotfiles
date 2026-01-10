// ═══════════════════════════════════════════════════════════════
// 🌸 Sakura Night - LibreWolf user.js
// ═══════════════════════════════════════════════════════════════

// ── Enable userChrome.css and userContent.css ──────────────────
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// ── UI Customization ───────────────────────────────────────────
// Compact mode
user_pref("browser.uidensity", 1);

// Dark theme
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
user_pref("browser.theme.content-theme", 0);
user_pref("browser.theme.toolbar-theme", 0);

// Smooth scrolling
user_pref("general.smoothScroll", true);
user_pref("general.smoothScroll.lines.durationMaxMS", 125);
user_pref("general.smoothScroll.lines.durationMinMS", 125);
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 100);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.other.durationMaxMS", 125);
user_pref("general.smoothScroll.other.durationMinMS", 125);
user_pref("general.smoothScroll.pages.durationMaxMS", 125);
user_pref("general.smoothScroll.pages.durationMinMS", 125);

// ── Performance ────────────────────────────────────────────────
// Hardware acceleration
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);

// Session restore
user_pref("browser.sessionstore.interval", 30000);

// ── New Tab ────────────────────────────────────────────────────
// Blank new tab (faster)
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.startup.homepage", "about:blank");

// ── Privacy (LibreWolf defaults are good, these are extras) ────
// DNS over HTTPS (using Cloudflare)
user_pref("network.trr.mode", 2);
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");

// ── Behavior ───────────────────────────────────────────────────
// Middle click paste
user_pref("middlemouse.paste", false);

// Spell check in all text fields
user_pref("layout.spellcheckDefault", 2);

// Don't trim URLs
user_pref("browser.urlbar.trimURLs", false);

// Highlight all matches in find
user_pref("findbar.highlightAll", true);

// ── Developer Tools ────────────────────────────────────────────
// Dark theme for devtools
user_pref("devtools.theme", "dark");

// Enable browser toolbox
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);

// ── Font Rendering ─────────────────────────────────────────────
user_pref("gfx.text.subpixel-position.force-enabled", true);
user_pref("font.name.monospace.x-western", "JetBrains Mono");

