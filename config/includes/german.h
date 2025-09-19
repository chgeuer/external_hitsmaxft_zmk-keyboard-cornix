/*
 * German layout definitions for ZMK
 * Based on German QWERTZ keyboard layout
 */

#pragma once

// German specific characters
#define DE_Z SEMI       // Z key position in German layout
#define DE_Y Z          // Y key position in German layout
#define DE_SS MINUS     // ß (eszett/sharp s)
#define DE_PLUS RBRC    // + key
#define DE_HASH NUHS    // # key
#define DE_MINS FSLH    // - key

// German special characters with modifiers
#define DE_EXLM LS(N1)  // ! (exclamation mark)
#define DE_DQOT LS(N2)  // " (quotation marks)
#define DE_DLR LS(N4)   // $ (dollar sign)
#define DE_AMPR LS(N6)  // & (ampersand)
#define DE_PERC LS(N5)  // % (percent)

// AltGr combinations for special characters
#define DE_PIPE RA(NUBS)  // | (pipe)
#define DE_AT RA(Q)       // @ (at sign)
#define DE_TILD RA(RBRC)  // ~ (tilde)
#define DE_EURO RA(E)     // € (euro sign)
#define DE_ASTR LS(RBRC)  // * (asterisk)

// More German characters
#define DE_RING LS(GRAVE) // ° (degree symbol)
#define DE_PARA LS(N3)    // § (section sign)
#define DE_LPRN LS(N8)    // ( (left parenthesis)
#define DE_RPRN LS(N9)    // ) (right parenthesis)
#define DE_EQL LS(N0)     // = (equals)
#define DE_BSLS RA(MINUS) // \ (backslash)

// Brackets and braces
#define DE_LCBR RA(N7)    // { (left curly brace)
#define DE_RCBR RA(N0)    // } (right curly brace)
#define DE_LBRC RA(N8)    // [ (left square bracket)
#define DE_RBRC RA(N9)    // ] (right square bracket)
#define DE_QUOT LS(NUHS)  // ' (apostrophe)

// Comparison operators
#define DE_LESS NUBS      // < (less than)
#define DE_MORE LS(NUBS)  // > (greater than)
#define DE_COLN LS(DOT)   // : (colon)
#define DE_SLSH LS(N7)    // / (forward slash)

// German umlauts
#define DE_AE SQT         // ä (a-umlaut)
#define DE_OE SEMI        // ö (o-umlaut)
#define DE_UE LBRC        // ü (u-umlaut)

// Additional German characters
#define DE_CARET RA(GRAVE) // ^ (circumflex)
#define DE_EQL LS(N0)      // = (equals)
#define DE_GRAVE GRAVE     // ` (grave accent)