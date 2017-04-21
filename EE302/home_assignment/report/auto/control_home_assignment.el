(TeX-add-style-hook
 "control_home_assignment"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("geometry" "a4paper" "tmargin=1in" "bmargin=1in") ("inputenc" "utf8")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "geometry"
    "inputenc"
    "graphicx"
    "parskip"
    "pdflscape"
    "listings"
    "amsmath")
   (TeX-add-symbols
    "ra")
   (LaTeX-add-labels
    "eq:1"
    "eq:2"
    "eq:3"
    "eq:4")
   (LaTeX-add-environments
    '("answer" LaTeX-env-args ["argument"] 1)
    '("question" LaTeX-env-args ["argument"] 1)))
 :latex)

