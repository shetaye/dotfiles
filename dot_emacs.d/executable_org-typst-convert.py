#!/usr/bin/env python3
"""Joseph's Org Typst<->LaTeX interop script.

Converts Org-generated LaTeX fragments into Typst source files for preview.
Handles inline/display math, multiline environments (align, gather, etc.),
and block-level constructs (theorem, proof, definition, ...) mapped to
ctheorems-based Typst functions. Designed to be called from Org's
org-preview-latex-process-alist as the :latex-compiler step.

Copyright (c) 2026 Joseph Shetaye

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

import argparse
import re
import sys


def extract_color(tex: str, name: str) -> tuple[float, ...] | None:
    r"""Extract \definecolor{name}{rgb}{r, g, b} as a tuple of floats."""
    m = re.search(rf"\\definecolor\{{{name}\}}\{{rgb\}}\{{([^}}]*)\}}", tex)
    if not m:
        return None
    return tuple(float(x.strip()) for x in m.group(1).split(","))


def rgb_to_typst(rgb: tuple[float, ...]) -> str:
    """Convert (r, g, b) floats in [0,1] to a Typst rgb() call."""
    return "rgb({}, {}, {})".format(
        int(rgb[0] * 255 + 0.5),
        int(rgb[1] * 255 + 0.5),
        int(rgb[2] * 255 + 0.5),
    )


def extract_snippet(tex: str) -> str:
    r"""Extract content from {\color{fg} ...} with proper brace matching."""
    m = re.search(r"\{\\color\{fg\}", tex)
    if not m:
        return ""

    depth = 0
    for i in range(m.start(), len(tex)):
        if tex[i] == "{":
            depth += 1
        elif tex[i] == "}":
            depth -= 1
            if depth == 0:
                return tex[m.end() : i].strip()

    # Unbalanced - return everything after the pattern.
    return tex[m.end() :].strip()


# LaTeX environments that map to Typst constructs from common/math.typ.
ENVIRONMENT_MAP = {
    "proof": "proof",
    "proof-sketch": "proof-sketch",
    "problem": "problem",
    "algorithm": "algorithm",
    "theorem": "theorem",
    "corollary": "corollary",
    "lemma": "lemma",
    "proposition": "proposition",
    "definition": "definition",
    "example": "example",
}

# LaTeX math environments that become Typst block math.
BLOCK_MATH_ENVS = [
    "align*", "align",
    "gather*", "gather",
    "equation*", "equation",
    "multline*", "multline",
]


def convert_linebreaks(text: str) -> str:
    r"""Convert LaTeX \\ to Typst \. Drops optional spacing like \\[2em]."""
    return re.sub(r"\\\\(\[[^\]]*\])?", r"\\", text)


def convert_math_envs(text: str) -> str:
    r"""Convert LaTeX math environments to Typst math blocks.

    Block envs (align*, equation*, ...) become display math $ ... $.
    \[...\] becomes display math, \(...\) becomes inline math.
    In Typst, display vs inline is determined by whitespace inside the $:
      $x$    is inline,  $ x $  (or $\n...\n$) is display."""

    # Block math environments
    for env in BLOCK_MATH_ENVS:
        pattern = re.compile(
            rf"\\begin\{{{re.escape(env)}\}}"
            rf"(.*?)"
            rf"\\end\{{{re.escape(env)}\}}",
            re.DOTALL,
        )
        text = pattern.sub(
            lambda m: f"$\n{convert_linebreaks(m.group(1).strip())}\n$",
            text,
        )

    # \[...\] -> display (block) math
    text = re.sub(
        r"\\\[(.*?)\\\]",
        lambda m: f"$\n{m.group(1).strip()}\n$",
        text,
        flags=re.DOTALL,
    )

    # \(...\) -> inline math
    text = re.sub(
        r"\\\((.*?)\\\)",
        lambda m: f"${m.group(1).strip()}$",
        text,
        flags=re.DOTALL,
    )

    return text


def convert_environments(text: str) -> str:
    r"""Convert \begin{env}...\end{env} to Typst #env[...] constructs."""
    for latex_env, typst_fn in ENVIRONMENT_MAP.items():
        pattern = re.compile(
            rf"\\begin\{{{re.escape(latex_env)}\}}"
            rf"(.*?)"
            rf"\\end\{{{re.escape(latex_env)}\}}",
            re.DOTALL,
        )
        text = pattern.sub(
            lambda m, fn=typst_fn: f"#{fn}[\n{m.group(1).strip()}\n]",
            text,
        )
    return text


def strip_org_comments(text: str) -> str:
    r"""Remove LaTeX line comments (unescaped %) inserted by Org.

    In LaTeX, % eats the rest of the line *and* the newline (joining
    lines with no space).  We must not strip escaped \%."""
    text = re.sub(r"(?<!\\)%[ \t]*\n", "", text)
    text = re.sub(r"(?<!\\)%[ \t]*$", "", text)
    return text


def convert_snippet(snippet: str) -> str:
    """Full conversion pipeline for an extracted LaTeX snippet.

    Order matters:
      1. Strip Org % comments
      2. Convert math environments (align*, \\[...\\], etc.)
         - this also converts \\\\ -> \\ inside math envs
      3. Convert theorem/proof/etc. environments
      4. Convert remaining \\\\ linebreaks in text"""
    snippet = strip_org_comments(snippet)
    snippet = convert_math_envs(snippet)
    snippet = convert_environments(snippet)
    snippet = convert_linebreaks(snippet)
    return snippet


def has_block_constructs(snippet: str) -> bool:
    """True if snippet contains Typst block-level constructs.

    Block constructs like #theorem[...] need a fixed page width;
    auto-width collapses to zero, wrapping text per-character."""
    return any(f"#{fn}[" in snippet for fn in ENVIRONMENT_MAP.values())


# ---------------------------------------------------------------------------
# Self-tests
# ---------------------------------------------------------------------------

def run_tests() -> None:
    """Run self-tests and exit."""
    pass_count = 0
    fail_count = 0

    def check(name: str, got: str, expected: str) -> None:
        nonlocal pass_count, fail_count
        if got == expected:
            pass_count += 1
            print(f"  PASS: {name}")
        else:
            fail_count += 1
            print(f"  FAIL: {name}")
            print(f"    expected: {expected!r}")
            print(f"    got:      {got!r}")

    # --- strip_org_comments ---
    print("strip_org_comments:")
    check("single % eol",
          strip_org_comments("$3$%\n"), "$3$")
    check("double %% eol",
          strip_org_comments("$3$%%\n"), "$3$")
    check("escaped \\% preserved",
          strip_org_comments("100\\% done%\n"), "100\\% done")
    check("% at eof no newline",
          strip_org_comments("$x$%"), "$x$")
    check("multiple lines joined",
          strip_org_comments("a%\nb%\nc"), "abc")

    # --- extract_snippet ---
    print("extract_snippet:")
    check("simple",
          extract_snippet(r"{\color{fg} $x$}"), "$x$")
    check("nested braces",
          extract_snippet(r"{\color{fg} \frac{a}{b}}"), r"\frac{a}{b}")
    check("deeply nested",
          extract_snippet(r"{\color{fg} \frac{\sqrt{x}}{y}}"),
          r"\frac{\sqrt{x}}{y}")
    check("no match",
          extract_snippet("no color here"), "")

    # --- convert_linebreaks ---
    print("convert_linebreaks:")
    check("basic",
          convert_linebreaks("a \\\\ b"), "a \\ b")
    check("with spacing arg",
          convert_linebreaks("a \\\\[2em] b"), "a \\ b")
    check("no linebreak unchanged",
          convert_linebreaks("a b"), "a b")

    # --- convert_math_envs ---
    print("convert_math_envs:")
    check("align*",
          convert_math_envs(
              "\\begin{align*}x &= 1 \\\\\ny &= 2\\end{align*}"),
          "$\nx &= 1 \\\ny &= 2\n$")
    check("equation*",
          convert_math_envs(
              "\\begin{equation*}E = mc^2\\end{equation*}"),
          "$\nE = mc^2\n$")
    check("display \\[...\\]",
          convert_math_envs("\\[x^2 + y^2\\]"),
          "$\nx^2 + y^2\n$")
    check("inline \\(...\\)",
          convert_math_envs("\\(x^2\\)"),
          "$x^2$")
    check("inline $...$ unchanged",
          convert_math_envs("$x$"), "$x$")
    check("align* with spacing arg",
          convert_math_envs(
              "\\begin{align*}a \\\\\n\\\\[1em] b\\end{align*}"),
          "$\na \\\n\\ b\n$")

    # --- convert_environments ---
    print("convert_environments:")
    check("theorem",
          convert_environments(
              "\\begin{theorem}Let $x$ be...\\end{theorem}"),
          "#theorem[\nLet $x$ be...\n]")
    check("proof",
          convert_environments("\\begin{proof}QED\\end{proof}"),
          "#proof[\nQED\n]")

    # --- full pipeline ---
    print("convert_snippet (full pipeline):")
    check("inline math passthrough",
          convert_snippet("$6$%"), "$6$")
    check("inline with braces",
          convert_snippet("$\\frac{a}{b}$%"), "$\\frac{a}{b}$")
    check("display \\[...\\]",
          convert_snippet("\\[x^2\\]%"), "$\nx^2\n$")
    check("align inside theorem",
          convert_snippet(
              "\\begin{theorem}We have:"
              "\\begin{align*}x &= 1 \\\\\ny &= 2\\end{align*}"
              "\\end{theorem}%"),
          "#theorem[\nWe have:$\nx &= 1 \\\ny &= 2\n$\n]")
    check("text linebreak outside math",
          convert_snippet("Line 1 \\\\ Line 2"),
          "Line 1 \\ Line 2")
    check("inline \\(...\\) in theorem",
          convert_snippet(
              "\\begin{theorem}For \\(x > 0\\) we win.\\end{theorem}"),
          "#theorem[\nFor $x > 0$ we win.\n]")

    # --- has_block_constructs ---
    print("has_block_constructs:")
    check("proof is block",
          str(has_block_constructs("#proof[\nQED\n]")), "True")
    check("theorem is block",
          str(has_block_constructs("#theorem[\nfoo\n]")), "True")
    check("inline math is not block",
          str(has_block_constructs("$x^2$")), "False")
    check("display math is not block",
          str(has_block_constructs("$\nx^2\n$")), "False")

    # --- color extraction ---
    print("extract_color:")
    check("fg white",
          str(extract_color("\\definecolor{fg}{rgb}{1,1,1}", "fg")),
          "(1.0, 1.0, 1.0)")
    check("bg dark",
          str(extract_color(
              "\\definecolor{bg}{rgb}{0.05, 0.05, 0.11}", "bg")),
          "(0.05, 0.05, 0.11)")
    check("missing returns None",
          str(extract_color("no color", "fg")), "None")

    # --- rgb_to_typst ---
    print("rgb_to_typst:")
    check("white", rgb_to_typst((1.0, 1.0, 1.0)), "rgb(255, 255, 255)")
    check("black", rgb_to_typst((0.0, 0.0, 0.0)), "rgb(0, 0, 0)")
    check("rounding",
          rgb_to_typst((0.0509804, 0.054902, 0.109804)),
          "rgb(13, 14, 28)")

    print(f"\n{pass_count} passed, {fail_count} failed")
    sys.exit(1 if fail_count else 0)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-v", "--verbose", action="store_true",
                        help="print input LaTeX and output Typst to stdout")
    parser.add_argument("--test", action="store_true",
                        help="run self-tests and exit")
    parser.add_argument("--width", default="auto",
                        help="page width for block constructs (e.g. '100ch'); "
                             "math fragments always use auto")
    parser.add_argument("input", nargs="?", help="input .tex file")
    parser.add_argument("output", nargs="?", help="output .typ file")
    args = parser.parse_args()

    if args.test:
        run_tests()
        return

    if not args.input or not args.output:
        parser.error("input and output are required (unless --test)")

    with open(args.input) as f:
        tex = f.read()

    if args.verbose:
        print("=== INPUT LATEX ===")
        print(tex)
        print("===================")

    fg = extract_color(tex, "fg")
    bg = extract_color(tex, "bg")
    snippet = convert_snippet(extract_snippet(tex))

    lines: list[str] = []

    page_width = args.width if has_block_constructs(snippet) else "auto"
    if bg:
        lines.append(
            f"#set page(width: {page_width}, height: auto, "
            f"margin: (x: 0.2em, y: 0.4em), fill: {rgb_to_typst(bg)})"
        )
    else:
        lines.append(
            f"#set page(width: {page_width}, height: auto, margin: (x: 0.2em, y: 0.4em))"
        )

    lines.append('#import "/common/common.typ": *')

    lines.append('#set text(font: "BerkeleyMono Nerd Font Mono", size: 10pt)')
    lines.append('#show math.equation: set text(font: "Noto Sans Math")')

    if has_block_constructs(snippet):
        lines.append('#show: thmrules.with(qed-symbol: $square$)')

    if fg:
        lines.append(f"#set text(fill: {rgb_to_typst(fg)})")

    if snippet:
        lines.append(snippet)

    output = "\n".join(lines) + "\n"

    with open(args.output, "w") as f:
        f.write(output)

    if args.verbose:
        print("=== OUTPUT TYPST ===")
        print(output)
        print("====================")


if __name__ == "__main__":
    main()
