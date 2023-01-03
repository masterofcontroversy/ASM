## For those writing custom functions

### Inputs
```
r0 = AnimSwapProc*
r1 = AnimSwapListEntry*
```

### Output
Animation ID to use. OR 0 to skip the current entry and go to the next one.

### Structs
NOTE: If you're using the non-skills version, skillID will always be 0.
```c
struct AnimSwapProc {
/*00*/  PROC_HEADER;
/*29*/  u8  maySwap;
/*2A*/  u8  currentRoundID;
/*2B*/  u8  pad;
/*2C*/  BattleUnit* rightUnit;
/*30*/  BattleUnit* leftUnit;
/*34*/  AnimationInterpreter* currentUnitAIS;
/*38*/  u16 defaultRightAnim;
/*4A*/  u16 defaultLeftAnim;
};

struct AnimSwapListEntry {
/*00*/  u16 animToReplace;
/*02*/  u16 replacementAnim;
/*04*/  u16 (*swapFunc) (AnimSwapProc* proc, AnimSwapListEntry* swapEntry);
/*08*/  unsigned attributes : 19;
/*0A*/  unsigned info       : 5;
/*0B*/  u8  skillID;
/*0C*/  u16 flagID;
/*0E*/  u8  pad[2];
};
```

## For those editing the source code
Clone StanHash's [CLib repository](https://github.com/StanHash/FE-CLib), and place it in the same directory as the makefile.  
To compile the code, run `make`.
