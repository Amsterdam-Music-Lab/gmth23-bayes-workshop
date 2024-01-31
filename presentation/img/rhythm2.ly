\version "2.24.3"

\include "fragment.ily"

\paper {
  line-width = 6\cm
  system-system-spacing.basic-distance = #8
}

\new RhythmicStaff {
  \set Score.barNumberVisibility = ##f
  \omit Staff.TimeSignature
  c4 c4 c4 c4 \bar "||" \break
  c8. c16 c4 c8. c16 c4 \bar "||" \break
  c8 c c c c4 c \bar "||"
}