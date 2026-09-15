# -*- coding: utf-8 -*-
"""
Detect TRUE duplicate pages and add <link rel="canonical"> to the non-authoritative copies.

A pair is considered a true duplicate only when BOTH hold:
  * normalised <title> is identical
  * visible-text similarity (Jaccard over char 4-grams) >= 0.80

This avoids the trap of matching unrelated pages that merely share a filename
(e.g. mooc/photoshop/chapter2.html vs mooc/site-architecture/chapter2.html)
or share a boilerplate site-wide meta description.

Authority (winner) is chosen by:
  1. more inbound internal links
  2. topical section dir (payment/, tools/, SMC/, ...) over post/
  3. richer visible content
Only the losers get rel=canonical; the winner is left untouched.
"""
import os
import re
import sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKIP_DIRS = {".git", "node_modules", "redirects", ".workbuddy", "css", "uploads"}
SKIP_FILES = {"404.html"}
SKIP_PREFIX = ("conmon_funcation_code/",)

TITLE_RE = re.compile(r"<title[^>]*>(.*?)</title>", re.I | re.S)
DESC_RE = re.compile(
    r"<meta[^>]+name\s*=\s*[\"']description[\"'][^>]*content\s*=\s*[\"']([^\"']*)[\"']", re.I)
CANON_RE = re.compile(r'<link[^>]+rel\s*=\s*["\']canonical["\'][^>]*>', re.I)
HREF_RE = re.compile(r"<a[^>]+href\s*=\s*[\"']([^\"'#]+)", re.I)
HEAD_OPEN_RE = re.compile(r"<head[^>]*>", re.I)
SCRIPT_RE = re.compile(r"<script\b.*?</script>", re.I | re.S)
STYLE_RE = re.compile(r"<style\b.*?</style>", re.I | re.S)
COMMENT_RE = re.compile(r"<!--.*?-->", re.S)
TAG_RE = re.compile(r"<[^>]+>")
WS_RE = re.compile(r"\s+")

SIM_THRESHOLD = 0.80
SITE = "https://blog.aibochinese.com"


def read_text(rel):
    p = os.path.join(ROOT, rel)
    try:
        raw = open(p, "rb").read()
    except OSError:
        return None
    for enc in ("utf-8", "gb18030", "latin-1"):
        try:
            return raw.decode(enc)
        except UnicodeDecodeError:
            continue
    return None


def write_text(rel, s):
    p = os.path.join(ROOT, rel)
    with open(p, "w", encoding="utf-8", newline="") as f:
        f.write(s)


def html_files():
    out = []
    for dp, dn, fn in os.walk(ROOT):
        dn[:] = [d for d in dn if d not in SKIP_DIRS]
        for f in fn:
            if not f.lower().endswith((".html", ".htm")):
                continue
            rel = os.path.relpath(os.path.join(dp, f), ROOT).replace("\\", "/")
            if f in SKIP_FILES or rel.startswith(SKIP_PREFIX):
                continue
            out.append(rel)
    return sorted(out)


def visible_text(s):
    s = COMMENT_RE.sub(" ", s)
    s = SCRIPT_RE.sub(" ", s)
    s = STYLE_RE.sub(" ", s)
    s = TAG_RE.sub(" ", s)
    return WS_RE.sub(" ", s).strip()


def norm_title(t):
    t = WS_RE.sub(" ", t or "").strip()
    # strip a trailing " - 爱博·客" style site suffix so near-identical titles match
    t = re.sub(r"\s*[-–|]\s*爱博[·・]?客.*$", "", t).strip()
    return t


def shingles(text, n=4):
    text = re.sub(r"\s+", "", text)
    if len(text) < n:
        return {text} if text else set()
    return {text[i:i + n] for i in range(len(text) - n + 1)}


def similarity(a, b):
    if not a or not b:
        return 0.0
    inter = len(a & b)
    if not inter:
        return 0.0
    return inter / len(a | b)


def main(apply=False):
    files = html_files()
    meta = {}
    for rel in files:
        b = read_text(rel)
        if b is None:
            continue
        t = TITLE_RE.search(b)
        d = DESC_RE.search(b)
        vis = visible_text(b)
        meta[rel] = {
            "title": norm_title(t.group(1)) if t else "",
            "raw_title": WS_RE.sub(" ", t.group(1)).strip() if t else "",
            "desc": (d.group(1) or "").strip() if d else "",
            "size": len(b),
            "vis_len": len(vis),
            "shingles": shingles(vis),
            "has_canon": bool(CANON_RE.search(b)),
            "body": b,
        }

    inbound = defaultdict(int)
    for rel in files:
        b = meta[rel]["body"]
        base = os.path.dirname(rel)
        for m in HREF_RE.finditer(b):
            href = m.group(1).strip()
            if not href or href.startswith(("http", "mailto:", "tel:", "javascript:")):
                continue
            target = os.path.normpath(os.path.join(base, href.split("?")[0])).replace("\\", "/")
            if target in meta:
                inbound[target] += 1

    # candidate pairs: same title
    by_title = defaultdict(list)
    for rel, m in meta.items():
        if m["title"]:
            by_title[m["title"]].append(rel)

    pairs = []
    for title, group in by_title.items():
        if len(group) < 2:
            continue
        for i in range(len(group)):
            for j in range(i + 1, len(group)):
                a, b = group[i], group[j]
                sim = similarity(meta[a]["shingles"], meta[b]["shingles"])
                if sim >= SIM_THRESHOLD:
                    pairs.append((a, b, sim))

    # union-find to cluster
    parent = {r: r for r in meta}

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[rb] = ra

    for a, b, sim in pairs:
        union(a, b)

    clusters = defaultdict(list)
    for r in meta:
        clusters[find(r)].append(r)
    dup_clusters = [c for c in clusters.values() if len(c) > 1]

    def score(rel):
        m = meta[rel]
        top = rel.split("/")[0] if "/" in rel else ""
        topical = 0 if top == "post" else 1
        root = 2 if "/" not in rel else 0
        # The home page must ALWAYS be the authority; pointing it at a copy
        # would transfer the entire site's ranking signals to /post/index.html.
        home = 10_000 if rel == "index.html" else 0
        return (home, inbound[rel], topical * 10 + root, m["vis_len"], m["size"])

    print("=" * 72)
    print("TRUE DUPLICATE DETECTION  (title match + >=%.0f%% body similarity)" % (SIM_THRESHOLD * 100))
    print("=" * 72)
    print("pages scanned        : %d" % len(meta))
    print("same-title groups    : %d" % len(by_title))
    print("verified dup pairs   : %d" % len(pairs))
    print("duplicate clusters   : %d" % len(dup_clusters))

    plan = []
    print("\n--- clusters ---")
    for cl in sorted(dup_clusters, key=lambda c: sorted(c)[0]):
        ranked = sorted(cl, key=score, reverse=True)
        winner = ranked[0]
        losers = ranked[1:]
        print("\nwinner: %s   (in=%d, vis=%d)" % (winner, inbound[winner], meta[winner]["vis_len"]))
        for l in losers:
            sim = similarity(meta[winner]["shingles"], meta[l]["shingles"])
            print("   dup: %s   (in=%d, vis=%d, sim=%.2f)" % (l, inbound[l], meta[l]["vis_len"], sim))
            plan.append((l, winner))

    print("\ntotal canonical tags to add: %d" % len(plan))

    if not apply:
        print("\n[DRY RUN] pass --apply to write changes")
        return

    added = 0
    for loser, winner in plan:
        b = meta[loser]["body"]
        if CANON_RE.search(b):
            continue
        url = SITE + "/" + winner
        tag = '<link rel="canonical" href="%s">' % url
        m = HEAD_OPEN_RE.search(b)
        if not m:
            print("  !! no <head> in %s -- skipped" % loser)
            continue
        b = b[:m.end()] + "\n    " + tag + b[m.end():]
        write_text(loser, b)
        added += 1
        print("  + %s -> %s" % (loser, winner))
    print("\napplied canonical to %d pages" % added)


if __name__ == "__main__":
    main(apply="--apply" in sys.argv)
