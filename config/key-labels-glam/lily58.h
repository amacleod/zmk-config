/*
 * Copyright (c) 2024 Allister MacLeod
 *
 * SPDX-License-Identifier: MIT
 */

// These definitions are different from those in urob/zmk-helpers
// because I prefer to treat the uppermost row as a number row,
// rather than defining a floor row below the top three rows.
// This allows me to use similar key labels among my Corne, my
// Zaphod Lite, and my Lily58.

//   0   1   2   3   4   5             6   7   8   9  10  11
//  12  13  14  15  16  17            18  19  20  21  22  23
//  24  25  26  27  28  29            30  31  32  33  34  35
//  36  37  38  39  40  41  42    43  44  45  46  47  48  49
//              50  51  52  53    54  55  56  57

// LN5 LN4 LN3 LN2 LN1 LN0           RN0 RN1 RN2 RN3 RN4 RN5
// LT5 LT4 LT3 LT2 LT1 LT0           RT0 RT1 RT2 RT3 RT4 RT5
// LM5 LM4 LM3 LM2 LM1 LM0           RM0 RM1 RM2 RM3 RM4 RM5
// LB5 LB4 LB3 LB2 LB1 LB0 LEC   REC RB0 RB1 RB2 RB3 RB4 RB5
//             LH3 LH2 LH1 LH0   RH0 RH1 RH2 RH3

// N = number, T = top, M = middle, B = bottom, H = thumb, EC = encoder capable

#pragma once

#define LN0  5
#define LN1  4
#define LN2  3
#define LN3  2
#define LN4  1
#define LN5  0

#define LT0 17
#define LT1 16
#define LT2 15
#define LT3 14
#define LT4 13
#define LT5 12

#define LM0 29
#define LM1 28
#define LM2 27
#define LM3 26
#define LM4 25
#define LM5 24

#define LEC 42

#define LB0 41
#define LB1 40
#define LB2 39
#define LB3 38
#define LB4 37
#define LB5 36

#define LH0 53
#define LH1 52
#define LH2 51
#define LH3 50


#define RN0  6
#define RN1  7
#define RN2  8
#define RN3  9
#define RN4 10
#define RN5 11

#define RT0 18
#define RT1 19
#define RT2 20
#define RT3 21
#define RT4 22
#define RT5 23

#define RM0 30
#define RM1 31
#define RM2 32
#define RM3 33
#define RM4 34
#define RM5 35

#define REC 43

#define RB0 44
#define RB1 45
#define RB2 46
#define RB3 47
#define RB4 48
#define RB5 49

#define RH0 54
#define RH1 55
#define RH2 56
#define RH3 57
