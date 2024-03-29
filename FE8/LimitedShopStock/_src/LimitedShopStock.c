#include "LimitedShopStock.h"

void SU_SaveShopStock(void* target, int size) {
    WriteAndVerifySramFast(gCurrentShopStocks, target, size);
}

void SU_LoadShopStock(void* source, int size) {
    ReadSramFast(source, gCurrentShopStocks, size);
}

void InitShopStock() {
    int i = 0;
    ShopStockEntry* limitedItems = gShopStockTable[gChapterData.chapterIndex];
    if (limitedItems) {
        while (limitedItems[i].item) {
            (*gCurrentShopStocks)[i] = limitedItems[i].stock;
            ++i;
        }
        (*gCurrentShopStocks)[i] = 0; //Termintator
    }
    else {
        memset(*gCurrentShopStocks, 0, 1); //Terminator only
    }
}

int GetItemStockEntryNumber(u16 item) {
    u8 itemID = GetItemIndex(item);
    ShopStockEntry* limitedItems = gShopStockTable[gChapterData.chapterIndex];
    if (limitedItems) {
        for (int i = 0; limitedItems[i].item; ++i) {
            if (limitedItems[i].item == itemID) {
                return i;
            }
        }
    }
    return (-1); //Item is not a stock item
}

int GetItemStock(u16 item) {
    int stockItem = GetItemStockEntryNumber(item);
    if (stockItem != (-1)) {
        return (*gCurrentShopStocks)[stockItem];
    }
    return (-1); 
}

bool IsItemInStock(u16 item) {
    int stockItem = GetItemStockEntryNumber(item);
    if (stockItem != (-1)) {
        if ((*gCurrentShopStocks)[stockItem]) {
            return TRUE;
        }
        else {
            return FALSE;
        }
    }
    return TRUE;
}

void ReduceItemStock(u16 item) {
    int stockItem = GetItemStockEntryNumber(item);
    if (stockItem != (-1) && (*gCurrentShopStocks)[stockItem] > 0) {
        (*gCurrentShopStocks)[stockItem]--;
    }
}

void DrawShopItemLine(struct TextHandle* th, int item, struct Unit* unit, u16* dst) {
    DrawItemMenuLine(th, item, IsItemDisplayUsable(unit, item), dst);

    if (IsItemSellable(item) != 0) {
        DrawUiNumber(dst + 0x11, 2, GetItemSellPrice(item));
    } else {
        Text_InsertString(th, 0x5C, 2, GetStringFromIndex(0x537));
    }

    return;
}

void DrawStockedItemLine(struct TextHandle* text, int item, s8 isUsable, u16* mapOut) {
    Text_SetParameters(text, 0, (isUsable ? TEXT_COLOR_NORMAL : TEXT_COLOR_GRAY));
    Text_AppendStringAscii(text, GetItemName(item));

    Text_Display(text, mapOut + 2);

    DrawUiNumberOrDoubleDashes(mapOut + 11, isUsable ? TEXT_COLOR_BLUE : TEXT_COLOR_GRAY, GetItemUses(item));
    DrawUiNumberOrDoubleDashes(mapOut + 20, TEXT_COLOR_BLUE, GetItemStock(item));

    DrawIcon(mapOut, GetItemIconId(item), 0x4000);
}

void sub_80B5164(TextHandle* th, int item, Unit* unit, u16* dst) {
    u8 visible;

    int price = GetItemPurchasePrice(unit, item);

    if (unit == 0) {
        visible = 1;
    } else {
        visible = IsItemDisplayUsable(unit, item);
    }

    DrawStockedItemLine(th, item, visible, dst);

    sub_8004B88(
        dst + 0x11,
        (int)GetPartyGoldAmount() >= price
            ? 2
            : 1,
        price
    );

    return;
}

void ShopProc_Loop_BuyKeyHandler(struct BmShopProc* proc) {
    u8 unkA;
    u32 unkC;
    int price;
    int a;
    int b;

    sub_80B5604();

    SetBgPosition(2, 0, sub_80B5698());

    unkA = proc->curIndex;
    unkC = sub_80B568C() != unkA;

    proc->curIndex = sub_80B568C();
    proc->unk_5d = sub_80B56A8();

    proc->unk_5e = proc->curIndex;
    proc->unk_5f = proc->unk_5d;

    a = proc->curIndex;
    a *= 16;

    b = ((proc->unk_5d * 16)) - 72;

    DisplayUiHand(40, a - b);

    if ((proc->helpTextActive != 0) && (unkC != 0)) {
        a = (proc->curIndex * 16);
        b = ((proc->unk_5d * 16) - 72);
        StartItemHelpBox(56, a - b, proc->shopItems[proc->curIndex]);
    }

    DisplayShopUiArrows();

    if (sub_80B56CC() != 0) {
        return;
    }

    if (proc->helpTextActive != 0) {
        if (gKeyState.pressedKeys & (KEY_BUTTON_B | KEY_BUTTON_R)) {
            proc->helpTextActive = 0;
            CloseHelpBox();
        }

        return;
    }

    if (gKeyState.pressedKeys & KEY_BUTTON_R) {
        proc->helpTextActive = 1;
        a = (proc->curIndex * 16);
        b = ((proc->unk_5d * 16) - 72);
        StartItemHelpBox(56, a - b, proc->shopItems[proc->curIndex]);

        return;
    }

    price = GetItemPurchasePrice(proc->unit, proc->shopItems[proc->curIndex]);

    if (gKeyState.pressedKeys & KEY_BUTTON_A) {
        if (!IsItemInStock(proc->shopItems[proc->curIndex])) {
            StartShopDialogue(OutOfStockTextBase, proc);

            ProcGoto(proc, 1);
        }
        else if (price > (int)GetPartyGoldAmount()) {
            StartShopDialogue(0x8B2, proc);
            // SHOP_TYPE_ARMORY: "You don't have the money![.][A]"
            // SHOP_TYPE_VENDOR: "You're short of funds.[A]"
            // SHOP_TYPE_SECRET_SHOP: "Heh! Not enough money![A]"

            ProcGoto(proc, 1);
        } else {
            SetTalkNumber(price);
            StartShopDialogue(0x8B5, proc);
            // SHOP_TYPE_ARMORY: "How does [.][G] gold[.][NL]sound to you?[.][Yes]"
            // SHOP_TYPE_VENDOR: "That's worth [.][G] gold.[NL]Is that all right?[Yes]"
            // SHOP_TYPE_SECRET_SHOP: "That is worth [G] gold.[NL]Is that acceptable?[.][Yes]"

            BreakProcLoop(proc);
        }

        return;
    }

    if (gKeyState.pressedKeys & KEY_BUTTON_B) {
        PlaySfx(0x6B);
        ProcGoto(proc, 7);

        return;
    }

    return;
}

void HandleShopBuyAction(struct BmShopProc* proc) {
    sub_8014B88(0xB9, 8);

    gActionData.unitActionType = UNIT_ACTION_SHOPPED;

    SetPartyGoldAmount(GetPartyGoldAmount() - GetItemPurchasePrice(proc->unit, proc->shopItems[proc->curIndex]));
    ReduceItemStock(proc->shopItems[proc->curIndex]);

    UpdateShopItemCounts(proc);
    sub_80B4F90(proc);

    DisplayGoldBoxText(gBg0MapBuffer + 0xDB);

    return;
}
