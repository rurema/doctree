#!/usr/bin/env python3
import os
import re
import sys

ROOT = "/home/debian/rurema/doctree/manual/api"
OUT = "/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad/lib-check"

def strip_quotes(s):
    s = s.strip()
    if len(s) >= 2 and s[0] == s[-1] and s[0] in ('"', "'"):
        return s[1:-1]
    return s

def parse_front_matter(lines):
    """lines: list of all lines in file. Return (fm_dict, fm_end_index) or (None, 0) if no front matter."""
    if not lines or lines[0].rstrip('\n') != '---':
        return None, 0
    fm = {}
    i = 1
    end_idx = None
    while i < len(lines):
        line = lines[i].rstrip('\n')
        if line == '---':
            end_idx = i
            break
        # simple key: value parser (top-level only)
        m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$', line)
        if m:
            key = m.group(1)
            val = m.group(2)
            fm[key] = strip_quotes(val)
        i += 1
    if end_idx is None:
        return None, 0
    return fm, end_idx

all_md = []
for dirpath, dirnames, filenames in os.walk(ROOT):
    for fn in filenames:
        if fn.endswith('.md'):
            full = os.path.join(dirpath, fn)
            all_md.append(full)

all_md.sort()

library_rows = []  # (name, since, until, category)
nonlibrary_rows = []  # (name, type_value, is_builtin, is_toplevel)
gate_anomaly_files = []

for full in all_md:
    rel = os.path.relpath(full, ROOT)
    name = rel[:-3] if rel.endswith('.md') else rel  # strip .md
    with open(full, 'r', encoding='utf-8', errors='replace') as f:
        lines = f.readlines()
    fm, end_idx = parse_front_matter(lines)
    is_builtin = rel.startswith('_builtin/') or rel.startswith('_builtin' + os.sep)
    is_toplevel = ('/' not in name)

    if fm is not None and fm.get('type') == 'library':
        since = fm.get('since', '')
        until = fm.get('until', '')
        category = fm.get('category', '')
        library_rows.append((name, since, until, category))

        # check gate anomalies: first 5 lines for #%since / #%until
        first5 = lines[:5]
        for idx, l in enumerate(first5):
            if '#%since' in l or '#%until' in l:
                gate_anomaly_files.append(f"{name}: line {idx+1}: {l.rstrip()}")
    else:
        if is_builtin:
            continue  # excluded from non-library list per task
        type_val = fm.get('type', '') if fm is not None else '(no front matter)'
        nonlibrary_rows.append((name, type_val, is_toplevel))

# Write library TSV
library_rows.sort(key=lambda r: r[0])
with open(os.path.join(OUT, 'rurema-libs.tsv'), 'w', encoding='utf-8') as f:
    f.write("name\tsince\tuntil\tcategory\n")
    for row in library_rows:
        f.write('\t'.join(row) + '\n')

# Write non-library TSV
nonlibrary_rows.sort(key=lambda r: r[0])
with open(os.path.join(OUT, 'non-library-files.tsv'), 'w', encoding='utf-8') as f:
    f.write("name\ttype\n")
    for name, type_val, is_toplevel in nonlibrary_rows:
        f.write(f"{name}\t{type_val}\n")

# Gate anomalies file
with open(os.path.join(OUT, 'gate-anomalies.txt'), 'w', encoding='utf-8') as f:
    if gate_anomaly_files:
        f.write("先頭5行に #%since / #%until を含む library ファイル:\n")
        for line in gate_anomaly_files:
            f.write(line + '\n')
    else:
        f.write("該当なし: type: library を持つファイルの先頭5行に #%since / #%until を含むものはなかった。\n")

# Notes
total = len(library_rows)
since_rows = [r for r in library_rows if r[1]]
until_rows = [r for r in library_rows if r[2]]
toplevel_libs = [r for r in library_rows if '/' not in r[0]]
subpath_libs = [r for r in library_rows if '/' in r[0]]

from collections import defaultdict
first_level_counts = defaultdict(int)
for r in subpath_libs:
    first = r[0].split('/')[0]
    first_level_counts[first] += 1

# non-library toplevel (not under _builtin, no subpath, type != library)
toplevel_nonlib = [r for r in nonlibrary_rows if r[2]]

with open(os.path.join(OUT, 'notes-doctree.md'), 'w', encoding='utf-8') as f:
    f.write("# doctree manual/api ライブラリ抽出メモ\n\n")
    f.write(f"- type: library 総数: {total}\n\n")
    f.write(f"## since 付き ({len(since_rows)} 件)\n\n")
    for r in sorted(since_rows, key=lambda x: x[0]):
        f.write(f"- {r[0]}: since={r[1]}\n")
    f.write(f"\n## until 付き ({len(until_rows)} 件)\n\n")
    for r in sorted(until_rows, key=lambda x: x[0]):
        f.write(f"- {r[0]}: until={r[2]}\n")
    f.write(f"\n## トップレベル(サブパスなし) vs サブパス付き\n\n")
    f.write(f"- トップレベル(name に `/` を含まない): {len(toplevel_libs)} 件\n")
    f.write(f"- サブパス付き(name に `/` を含む): {len(subpath_libs)} 件\n\n")
    f.write("## トップレベル第1階層ごとのサブライブラリ数\n\n")
    for k in sorted(first_level_counts.keys()):
        f.write(f"- {k}/: {first_level_counts[k]} 件\n")
    f.write(f"\n## 特記事項\n\n")
    f.write(f"- non-library-files.tsv の総数(_builtin/ 除く): {len(nonlibrary_rows)}\n")
    f.write(f"- そのうちトップレベル(サブディレクトリでない)で type: library でないもの: {len(toplevel_nonlib)} 件\n")
    for r in sorted(toplevel_nonlib, key=lambda x: x[0]):
        f.write(f"  - {r[0]} (type: {r[1]})\n")

print("total md files:", len(all_md))
print("library count:", total)
print("non-library count (excl _builtin):", len(nonlibrary_rows))
print("toplevel non-library count:", len(toplevel_nonlib))
print("since count:", len(since_rows))
print("until count:", len(until_rows))
print("gate anomalies:", len(gate_anomaly_files))
