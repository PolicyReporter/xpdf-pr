// xpdf-pr: helpers the pdftohtml 0.39 port used to add to xpdf core (GString, UnicodeMap, Error).
// Kept here so the xpdf tree stays pristine.
#ifndef HTMLCOMPAT_H
#define HTMLCOMPAT_H

#include "GString.h"
#include "CharTypes.h"

enum UnicodeTextDirection {
  textDirUnknown,
  textDirLeftRight,
  textDirRightLeft,
  textDirTopBottom
};

static inline UnicodeTextDirection htmlGetDirection(Unicode u) {
  if (u >= 0x0590 && u <= 0x05ff) { // hebrew
    return textDirRightLeft;
  }
  return textDirLeftRight;
}

static inline GString *htmlEscape(GString *s) {
  GString *tmp = new GString();
  for (int i = 0; i < s->getLength(); ++i) {
    switch (s->getChar(i)) {
      case '"': tmp->append("&quot;"); break;
      case '&': tmp->append("&amp;"); break;
      case '<': tmp->append("&lt;"); break;
      case '>': tmp->append("&gt;"); break;
      default: tmp->append(s->getChar(i));
    }
  }
  return tmp;
}

static inline GString *htmlReplaceChar(GString *s, char oldChar, char newChar) {
  for (int i = 0; i < s->getLength(); ++i) {
    if (s->getChar(i) == oldChar) {
      s->setChar(i, newChar);
    }
  }
  return s;
}

#endif
