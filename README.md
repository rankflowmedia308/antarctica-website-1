# Best Antarctica Cruise Companies

**Domain:** best-antarctica-cruise-companies.com
**Type:** SEO ranking page — independent editorial guide

## Build

```bash
bash build.sh
```

Assembles all `index.html` pages from shared components + content files.

## File Structure

```
├── index.html                  ← Built output (main ranking page)
├── about/index.html            ← Built output
├── editorial-policy/index.html ← Built output
├── contact/index.html          ← Built output
├── cookie-policy/index.html    ← Built output
├── components/
│   ├── header.html             ← Shared nav (no boilerplate)
│   └── footer.html             ← Shared footer (no boilerplate)
├── content/
│   ├── main-ranking.html       ← Main page content
│   ├── about.html
│   ├── editorial-policy.html
│   ├── contact.html
│   └── cookie-policy.html
├── css/
│   ├── global.css              ← Reset, typography, header, footer
│   └── ranking.css             ← Ranking page styles
├── js/
│   └── nav.js                  ← Mobile nav toggle only
└── build.sh
```

## Editing Content

1. Edit files in `content/` or `components/`
2. Run `bash build.sh` to rebuild
3. Output files are in the root and subdirectories

## Design Notes

- Mobile-first, single breakpoint at 768px
- Max content width: 860px centered
- No JS required for content — all renders without JS
- JS only used for mobile nav toggle
