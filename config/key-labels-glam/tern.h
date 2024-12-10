/*
 * Copyright (c) 2024 Allister MacLeod
 *
 * SPDX-License-Identifier: MIT
 */

// Thirty-key keyboard: Tern. Like a Hummingbird but with lower pinky columns.

//      0   1   2   3             4   5   6   7
//  8   9  10  11  12            13  14  15  16  17
// 18  19  20  21                    22  23  24  25
//                 26  27    28  29

//     LT3 LT2 LT1 LT0          RT0 RT1 RT2 RT3
// LM4 LM3 LM2 LM1 LM0          RM0 RM1 RM2 RM3 RM4
// LB4 LB3 LB2 LB1                  RB1 RB2 RB3 RB4
//                 LH1 LH0  RH0 RH1

#pragma once

#define LT0  3
#define LT1  2
#define LT2  1
#define LT3  0

#define LM0 12
#define LM1 11
#define LM2 10
#define LM3  9
#define LM4  8

#define LB1 21
#define LB2 20
#define LB3 19
#define LB4 18

#define LH0 27
#define LH1 26


#define RT0  4
#define RT1  5
#define RT2  6
#define RT3  7

#define RM0 13
#define RM1 14
#define RM2 15
#define RM3 16
#define RM4 17

#define RB1 22
#define RB2 23
#define RB3 24
#define RB4 25

#define RH0 28
#define RH1 29
