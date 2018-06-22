#pragma once

class MinecraftUtils {
public:
    static void workaroundLocaleBug();

    static void setupHybris();

    static void* loadMinecraftLib();

    static void setupForHeadless();

    static unsigned int getLibraryBase(void* handle);

    static void initSymbolBindings(void* handle);

    static void workaroundShutdownCrash(void* handle);

    static void patchCallInstruction(void* patchOff, void* func, bool jump);

};