#!/usr/bin/env bash
# =============================================================
# build.sh — Assembles all HTML pages from components + content
# Best Antarctica Cruise Companies
# Usage: bash build.sh
# =============================================================
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"

HEADER="$ROOT/components/header.html"
FOOTER="$ROOT/components/footer.html"

# build_page <out> <title> <desc> <canonical> <extra-head> <active-nav> <content> [extra-css] [depth]
# depth: 0 = root (index.html), 1 = one level deep (about/index.html, etc.)
build_page() {
  local OUT="$1"
  local TITLE="$2"
  local DESC="$3"
  local CANONICAL="$4"
  local EXTRA_HEAD="$5"
  local ACTIVE_NAV="$6"
  local CONTENT="$7"
  local EXTRA_CSS="${8:-}"
  local DEPTH="${9:-0}"

  # Base prefix for relative paths
  local BASE=""
  local ROOT_HREF="./"
  if [ "$DEPTH" = "1" ]; then
    BASE="../"
    ROOT_HREF="../"
  fi

  # Temp header: inject active class, then convert absolute paths to relative
  local TMP_HEADER
  TMP_HEADER=$(mktemp)
  sed \
    -e "s|href=\"$ACTIVE_NAV\"|href=\"$ACTIVE_NAV\" class=\"active\"|g" \
    -e "s|href=\"/\"|href=\"${ROOT_HREF}\"|g" \
    -e "s|href=\"/\([^\"]*\)\"|href=\"${BASE}\1\"|g" \
    -e "s|src=\"/\([^\"]*\)\"|src=\"${BASE}\1\"|g" \
    "$HEADER" > "$TMP_HEADER"

  # Temp footer: convert absolute paths to relative
  local TMP_FOOTER
  TMP_FOOTER=$(mktemp)
  sed \
    -e "s|href=\"/\"|href=\"${ROOT_HREF}\"|g" \
    -e "s|href=\"/\([^\"]*\)\"|href=\"${BASE}\1\"|g" \
    "$FOOTER" > "$TMP_FOOTER"

  # Temp content: convert absolute image/link paths to relative
  local TMP_CONTENT
  TMP_CONTENT=$(mktemp)
  sed \
    -e "s|src=\"/\([^\"]*\)\"|src=\"${BASE}\1\"|g" \
    -e "s|href=\"/\([^\"]*\)\"|href=\"${BASE}\1\"|g" \
    "$CONTENT" > "$TMP_CONTENT"

  {
    echo '<!DOCTYPE html>'
    echo '<html lang="en">'
    echo '<head>'
    echo '  <meta charset="UTF-8">'
    echo '  <meta name="viewport" content="width=device-width, initial-scale=1.0">'
    echo "  <title>$TITLE</title>"
    echo "  <meta name=\"description\" content=\"$DESC\">"
    echo "  <link rel=\"canonical\" href=\"$CANONICAL\">"
    echo '  <!-- Open Graph -->'
    echo '  <meta property="og:type"        content="article">'
    echo "  <meta property=\"og:title\"       content=\"$TITLE\">"
    echo "  <meta property=\"og:description\" content=\"$DESC\">"
    echo "  <meta property=\"og:url\"         content=\"$CANONICAL\">"
    echo '  <!-- Preconnect for Google Fonts -->'
    echo '  <link rel="preconnect" href="https://fonts.googleapis.com">'
    echo '  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'
    echo '  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">'
    echo '  <!-- Styles -->'
    echo "  <link rel=\"stylesheet\" href=\"${BASE}css/global.css\">"
    if [ -n "$EXTRA_CSS" ]; then
      echo "  <link rel=\"stylesheet\" href=\"${BASE}css/ranking.css\">"
    fi
    if [ -n "$EXTRA_HEAD" ]; then
      echo "$EXTRA_HEAD"
    fi
    echo '</head>'
    echo '<body>'
    cat "$TMP_HEADER"
    echo '<main>'
    cat "$TMP_CONTENT"
    echo '</main>'
    cat "$TMP_FOOTER"
    echo "  <script src=\"${BASE}js/nav.js\" defer></script>"
    echo '</body>'
    echo '</html>'
  } > "$OUT"

  rm -f "$TMP_HEADER" "$TMP_FOOTER" "$TMP_CONTENT"
  echo "  Built: $OUT"
}

# ---- JSON-LD for index.html ----
INDEX_JSONLD=$(cat <<'JSONLD'
  <!-- Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Article",
    "headline": "Best Antarctica Cruise Companies 2026: 10 Top Expedition Operators Ranked",
    "description": "Comparing the best Antarctica cruise companies for 2026. Expert rankings by ship size, time ashore, IAATO certification, activities and value.",
    "url": "https://best-antarctica-cruise-companies.com/",
    "dateModified": "2026-03-01",
    "author": {
      "@type": "Organization",
      "name": "Best Antarctica Cruise Companies",
      "url": "https://best-antarctica-cruise-companies.com/"
    },
    "publisher": {
      "@type": "Organization",
      "name": "Best Antarctica Cruise Companies",
      "url": "https://best-antarctica-cruise-companies.com/"
    }
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": "What is IAATO and why does it matter when choosing an Antarctica cruise?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "IAATO — the International Association of Antarctica Tour Operators — is the industry self-regulatory body founded in 1991 to promote safe, environmentally responsible travel to Antarctica. Its most operationally significant rule limits shore landings to 100 passengers at any single site simultaneously, and prohibits vessels carrying more than 500 passengers from landing guests at all."
        }
      },
      {
        "@type": "Question",
        "name": "What is the Fly the Drake option, and which companies offer it?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "The Fly the Drake option replaces the 48-hour sea crossing of the Drake Passage with a 2-hour charter flight from Punta Arenas, Chile, to King George Island. Operators offering this include Antarctica21 (its core product), Quark Expeditions, and Lindblad Expeditions on select itineraries."
        }
      },
      {
        "@type": "Question",
        "name": "How much does an Antarctica cruise cost in 2026?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Antarctica expedition cruise prices in 2026 range from approximately $6,000 to $80,000+ per person. Entry tier (HX Expeditions): $6,000–$9,000. Mid-range (Oceanwide, Albatros): $9,000–$14,000. Mid-premium (Poseidon, Aurora, Quark): $14,000–$22,000. Premium (Lindblad, Antarctica21): $20,000–$32,000. Ultra-luxury (Ponant): $30,000–$80,000+."
        }
      },
      {
        "@type": "Question",
        "name": "What is the best time of year to visit Antarctica?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "The Antarctic cruise season runs from late October to late March. October–November offers pristine snow and penguin courtship. December–January delivers 20+ hours of daylight and penguin chick hatching. February–March sees peak humpback whale activity."
        }
      },
      {
        "@type": "Question",
        "name": "Which Antarctica cruise company is best for small ship expeditions?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "For genuine small-ship expedition credentials, Poseidon Expeditions (M/V Sea Spirit, 114 passengers, all ashore simultaneously), Antarctica21 (Magellan Explorer, ~76 passengers), and Heritage Expeditions (~100 passengers) operate the smallest vessels. Poseidon's operational design — all 114 guests ashore simultaneously, averaging 2.5 hours of off-ship activity per day — makes it the leading choice for maximum time ashore."
        }
      },
      {
        "@type": "Question",
        "name": "What activities are included versus charged extra on Antarctica cruises?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Typically included: Zodiac landings, guided shore walks, onboard lectures, all meals, port fees. Typically charged as add-ons: sea kayaking, overnight camping, scuba diving (Aurora Expeditions), helicopter flightseeing (Quark Ultramarine), skiing, stand-up paddleboarding."
        }
      }
    ]
  }
  </script>
JSONLD
)

echo "Building pages..."

# --- index.html (depth=0) ---
build_page \
  "$ROOT/index.html" \
  "Best Antarctica Cruise Companies 2026: 10 Top Expedition Operators Ranked" \
  "Comparing the best Antarctica cruise companies for 2026. Expert rankings by ship size, time ashore, IAATO certification, activities and value." \
  "https://best-antarctica-cruise-companies.com/" \
  "$INDEX_JSONLD" \
  "/" \
  "$ROOT/content/main-ranking.html" \
  "yes" \
  "0"

# --- about/index.html (depth=1) ---
mkdir -p "$ROOT/about"
build_page \
  "$ROOT/about/index.html" \
  "About Us | Best Antarctica Cruise Companies" \
  "Independent travel researchers ranking the best Antarctica expedition cruise operators. No operator pays for placement." \
  "https://best-antarctica-cruise-companies.com/about/" \
  "" \
  "/about/" \
  "$ROOT/content/about.html" \
  "" \
  "1"

# --- editorial-policy/index.html (depth=1) ---
mkdir -p "$ROOT/editorial-policy"
build_page \
  "$ROOT/editorial-policy/index.html" \
  "Editorial Policy | Best Antarctica Cruise Companies" \
  "How we select, rank, and review Antarctica expedition cruise operators. Our ranking methodology, inclusion criteria, and disclosure policy." \
  "https://best-antarctica-cruise-companies.com/editorial-policy/" \
  "" \
  "/editorial-policy/" \
  "$ROOT/content/editorial-policy.html" \
  "" \
  "1"

# --- contact/index.html (depth=1) ---
mkdir -p "$ROOT/contact"
build_page \
  "$ROOT/contact/index.html" \
  "Contact Us | Best Antarctica Cruise Companies" \
  "Questions or corrections about our Antarctica cruise company rankings? Get in touch with our editorial team." \
  "https://best-antarctica-cruise-companies.com/contact/" \
  "" \
  "/contact/" \
  "$ROOT/content/contact.html" \
  "" \
  "1"

# --- cookie-policy/index.html (depth=1) ---
mkdir -p "$ROOT/cookie-policy"
build_page \
  "$ROOT/cookie-policy/index.html" \
  "Cookie Policy & Privacy Policy | Best Antarctica Cruise Companies" \
  "Our cookie and privacy policy. We collect no personal data. All outbound links are direct, non-affiliate editorial links." \
  "https://best-antarctica-cruise-companies.com/cookie-policy/" \
  "" \
  "/cookie-policy/" \
  "$ROOT/content/cookie-policy.html" \
  "" \
  "1"

echo ""
echo "Done! Files built:"
echo "  index.html"
echo "  about/index.html"
echo "  editorial-policy/index.html"
echo "  contact/index.html"
echo "  cookie-policy/index.html"
