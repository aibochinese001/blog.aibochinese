# -*- coding: utf-8 -*-
"""Post-change regression check: HTML structure + internal link integrity."""
import os
import re
from collections import defaultdict
from html.parser import HTMLParser

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKIP = {".git", "redirects", ".workbuddy", "node_modules", "pagefind"}
VOID = {"area", "base", "br", "col", "embed", "hr", "img",
        "input", "link", "meta", "source", "track", "wbr"}


class P(HTMLParser):
    def __init__(self):
        super().__init__()
        self.stack = []

    def handle_starttag(self, t, a):
        if t not in VOID:
            self.stack.append(t)

    def handle_endtag(self, t):
        if t in VOID:
            return
        if self.stack and self.stack[-1] == t:
            self.stack.pop()
        elif t in self.stack:
            while self.stack and self.stack.pop() != t:
                pass


def read(p):
    raw = open(p, "rb").read()
    for e in ("utf-8", "gb18030", "latin-1"):
        try:
            return raw.decode(e)
        except UnicodeDecodeError:
            continue
    return ""


def htmls():
    for dp, dn, fn in os.walk(ROOT):
        dn[:] = [d for d in dn if d not in SKIP]
        for f in fn:
            if f.lower().endswith((".html", ".htm")):
                yield os.path.join(dp, f)


def main():
    bad, n = [], 0
    for p in htmls():
        s = read(p)
        pr = P()
        n += 1
        try:
            pr.feed(s)
        except Exception:
            bad.append((p, "parse-exc"))
            continue
        if pr.stack:
            bad.append((p, ",".join(pr.stack[-3:])))
    print("HTML structure : parsed=%d  suspicious=%d" % (n, len(bad)))
    for b in bad[:8]:
        print("    ", b)

    HREF = re.compile(r"<a[^>]+href\s*=\s*[\"']([^\"']+)", re.I)
    SCRIPT = re.compile(r"<script\b.*?</script>", re.I | re.S)
    broken = defaultdict(list)
    checked = 0
    for p in htmls():
        s = SCRIPT.sub("", read(p))
        base = os.path.dirname(p)
        for m in HREF.finditer(s):
            h = m.group(1).strip()
            if not h or h.startswith(("http", "mailto:", "tel:", "javascript:", "#")):
                continue
            rel = h.split("?")[0].split("#")[0]
            if rel.startswith("/"):
                # root-relative URL: resolve against the site root, not the drive root
                t = os.path.normpath(os.path.join(ROOT, rel.lstrip("/")))
            else:
                t = os.path.normpath(os.path.join(base, rel))
            t = t.replace(os.sep, "/")
            checked += 1
            if not os.path.exists(t):
                broken[t].append(os.path.relpath(p, ROOT))
    print("\ninternal links  : checked=%d  broken=%d" % (checked, len(broken)))
    for t, srcs in list(broken.items())[:12]:
        print("     %s   <- %s" % (t, srcs[0]))

    # canonical sanity
    CAN = re.compile(r'<link[^>]+rel=["\']canonical["\'][^>]*href=["\']([^"\']+)', re.I)
    tot = 0
    bad_c = []
    for p in htmls():
        for m in CAN.finditer(read(p)):
            tot += 1
            u = m.group(1)
            if not u.startswith("https://blog.aibochinese.com/"):
                bad_c.append((os.path.relpath(p, ROOT), u))
    print("\ncanonical tags  : %d   malformed=%d" % (tot, len(bad_c)))
    for b in bad_c[:5]:
        print("     ", b)


if __name__ == "__main__":
    main()
