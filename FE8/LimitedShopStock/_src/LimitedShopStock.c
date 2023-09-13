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
            gCurrentShopStocks[i] = limitedItems[i].stock;
            ++i;
        }
        gCurrentShopStocks[i] = 0; //Termintator
    }
    else {
        memset(gCurrentShopStocks, 0, 1); //Terminator only
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
    return 0;
}

bool IsItemInStock(u16 item) {
    int stockItem = GetItemStockEntryNumber(item);
    if (stockItem && gCurrentShopStocks[stockItem]) {
        return TRUE;
    }
    return FALSE;
}

bool IsItemStockItem(u16 item) {
    if (GetItemStockEntryNumber(item)) {
        return TRUE;
    }
    return FALSE;
}

void ReduceItemStock(u16 item) {
    int stockItem = GetItemStockEntryNumber(item);
    if (stockItem && gCurrentShopStocks[stockItem] > 0) {
        gCurrentShopStocks[stockItem]--;
    }
}

void DrawStockedItemLine(struct TextHandle* text, int item, s8 isUsable, u16* mapOut) {
    Text_SetParameters(text, 0, (isUsable ? TEXT_COLOR_GOLD : TEXT_COLOR_GRAY));
    Text_AppendStringAscii(text, GetItemName(item));

    Text_Display(text, mapOut + 2);

    DrawUiNumberOrDoubleDashes(mapOut + 11, isUsable ? TEXT_COLOR_BLUE : TEXT_COLOR_GRAY, GetItemUses(item));

    DrawIcon(mapOut, GetItemIconId(item), 0x4000);
}

void sub_80B5164(TextHandle* th, int item, Unit* unit, u16* dst) {
    u8 visible;
    bool isStockItem = IsItemStockItem(item);

    int price = GetItemPurchasePrice(unit, item);

    if (unit == 0) {
        visible = 1;
    } else {
        visible = IsItemDisplayUsable(unit, item);
    }

    if (isStockItem) {
        DrawStockedItemLine(th, item, IsItemInStock(item), dst);
    }
    else {
        DrawItemMenuLine(th, item, visible, dst);
    }

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

    DisplayUiHand(56, a - b);

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
        if (IsItemStockItem(proc->shopItems[proc->curIndex]) && !IsItemInStock(proc->shopItems[proc->curIndex])) {
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
