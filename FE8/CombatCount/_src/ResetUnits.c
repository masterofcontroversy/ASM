#include "gbafe.h"

extern void SetCombatCount(Unit* unit, int value);

void InitFactionCombatCounts() {
    int i;

    for (i = gChapterData.currentPhase + 1; i < gChapterData.currentPhase + 0x40; ++i) {
        Unit* unit = GetUnit(i);

        if (UNIT_IS_VALID(unit)) {
            SetCombatCount(unit, 0);
        }
    }
}
