// GH3Hack.cpp : Defines the exported functions for the DLL application.
//

#include "spooky.h"
#include "garbagetext.h"
#include "weakrand.h"
#include "keydebugging.h"
#include "stringscramble.h"

#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GlobalMap.h"
#include "gh3\CTextElement.h"
#include "gh3\CXboxText.h"
#include "gh3\SText.h"

#include <stdint.h>
#include <string.h>
#include <ctime>
#include <random>



constexpr uint32_t MAX_ELEMENTS = 65535;

#define COUNT_OF(x) ((sizeof(x)/sizeof(0[x])) / ((size_t)(!(sizeof(x) % sizeof(0[x])))))

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);
static uint32_t m_gameFrame = 0;
static uint32_t m_weirdFrame[17] = { 0 };

//GH3 Globals
static float * const g_gemStartX = (float *)0x00A13050;
static float * const g_gemStartY = (float *)0x00A13064;
static float * const g_gemEndX = (float *)0x00A13078;
static float * const g_gemEndY = (float *)0x00A1308C;
static float * const g_gemAngle = (float *)0x00A130B4;
constexpr float DefaultGemStartXDistance = 32.0f;
constexpr float DefaultGemEndXDistance = 102.4f;
constexpr float DefaultGemStartX = 576.0f;
constexpr float DefaultGemEndX = 435.2f;
constexpr float DefaultGemStartY = 305.0f;
constexpr float DefaultGemEndY = 655.0f;

/*
.data:0095FDA4                                             ; SetVariousGraphicsGlobals:loc_58B530r ...
.data:0095FDA8     g_renderInstances dd 1                  ; DATA XREF: SetVariousGraphicsGlobals+2Bw
.data:0095FDA8                                             ; SetVariousGraphicsGlobals+90w ...
.data:0095FDA8                                             ; Renders the band and other "instance" objects
.data:0095FDAC     g_renderGeoms dd 1                      ; DATA XREF: SetVariousGraphicsGlobals+3Cw
.data:0095FDAC                                             ; SetVariousGraphicsGlobals+8Aw ...
.data:0095FDAC                                             ; Renders the stage. If disabled, the band will still render but not the world surrounding them. It will be a black void
.data:0095FDB0     g_renderZoneMode dd 1                   ; DATA XREF: SetVariousGraphicsGlobals+53w
.data:0095FDB0                                             ; SetVariousGraphicsGlobals+81r
.data:0095FDB4     g_renderPrims dd 1                      ; DATA XREF: SetVariousGraphicsGlobals+A2w
.data:0095FDB4                                             ; SetVariousGraphicsGlobals+195w ...
.data:0095FDB4                                             ; No observed effects
.data:0095FDB8     g_renderPrims3D dd 1                    ; DATA XREF: SetVariousGraphicsGlobals+B3w
.data:0095FDB8                                             ; SetVariousGraphicsGlobals+19Bw ...
.data:0095FDB8                                             ; No observed effects
.data:0095FDBC     g_render2D dd 1                         ; DATA XREF: SetVariousGraphicsGlobals+C4w
.data:0095FDBC                                             ; SetVariousGraphicsGlobals+1A1w ...
.data:0095FDBC                                             ; Gems, all highway elements, and menus will not render. The black part of the highway will still render.
.data:0095FDC0     g_renderSkins dd 1                      ; DATA XREF: SetVariousGraphicsGlobals+D5w
.data:0095FDC0                                             ; SetVariousGraphicsGlobals+1A7w
.data:0095FDC0                                             ; No observed effects
.data:0095FDC4     g_renderParticles dd 1                  ; DATA XREF: SetVariousGraphicsGlobals+E6w
.data:0095FDC4                                             ; SetVariousGraphicsGlobals+1ADw ...
.data:0095FDC4                                             ; Particles will not render if this is false. This only applies to world particles. Sustain FX and other particles that only apply to the highway are unaffected.
.data:0095FDC8     g_onlyRenderMeshID dd 0FFFFFFFFh        ; DATA XREF: SetVariousGraphicsGlobals+18Aw
.data:0095FDC8                                             ; SetVariousGraphicsGlobals:loc_58AAD5w
.data:0095FDC8                                             ; No observed effects
.data:0095FDCC     g_renderLockFramerate dd 1              ; DATA XREF: SetVariousGraphicsGlobals+12Dw
.data:0095FDCC                                             ; Unknown if this has any effect
.data:0095FDD0     g_fontBaselineOffset dd 1.25            ; DATA XREF: SetVariousGraphicsGlobals+13Ew
.data:0095FDD0                                             ; SText__vmethod4:loc_5F2824r
.data:0095FDD0                                             ; Vertical adjustment for fonts. Likely needed for Japanese and other weird languages.
.data:0095FDD4     g_renderScreenFx dd 1                   ; DATA XREF: SetVariousGraphicsGlobals+108w
.data:0095FDD4                                             ; sub_645560:loc_645888r
.data:0095FDD4                                             ; If disabled the world will not render. Everything behind the highway will be nodraw
*/

bool  &g_renderInstances =		*(bool *) 0x0095FDA8; // Renders the band and other "instance" objects
bool  &g_renderGeoms =			*(bool *) 0x0095FDAC; // Renders the stage. If disabled, the band will still render but not the world surrounding them. It will be a black void
bool  &g_renderZoneMode =		*(bool *) 0x0095FDB0;
bool  &g_renderPrims =			*(bool *) 0x0095FDB4;
bool  &g_renderPrims3D =		*(bool *) 0x0095FDB8;
bool  &g_render2D =				*(bool *) 0x0095FDBC;
bool  &g_renderSkins =			*(bool *) 0x0095FDC0;
bool  &g_renderParticles =		*(bool *) 0x0095FDC4;
int   &g_onlyRenderMeshID =		*(int *) 0x0095FDC8;
bool  &g_renderLockFramerate =	*(bool *) 0x0095FDCC;
float &g_fontBaselineOffset =	*(float *) 0x0095FDD0;
bool  &g_renderScreenFx =		*(bool *) 0x0095FDD4;

bool &g_inSong = *(bool *)0x00B4EB21;
double &g_currentSongSeconds = *(double *)(0x00C489E0);



void VibrateText(float);

void Orchestrator();

//Runs every frame. I should probably integrate this natively into GH3+
void GameFrameHook()
{
    ++m_gameFrame;
    debugCheckKeys();
    RandomizeSeed();
    Orchestrator();
    

    for (auto i = 0; i < COUNT_OF(m_weirdFrame); ++i)
    {
        if (FlipCoin(0.003f))
        {
            ++m_weirdFrame[i];
        }
    }
}




//Green Start X = 576
//Green End X = 435.2000122
//Start Y =  305
//End Y =  655
//Start X = 32 diff
//End X = 102.4 diff
//Calculates the gem angle (the direction the "tail" points) given a gem's starting and ending position
float GemAngle(float StartX, float StartY, float EndX, float EndY)
{
    float x = EndX - StartX;
    float y = EndY - StartY;
    float hyp = sqrt(x*x + y*y);
    return -90.0f + (57.2958f * acos(x / hyp));
}

constexpr float GetGemStartX(int32_t fretIndex)
{
    return DefaultGemStartX + (fretIndex * DefaultGemStartXDistance);
}

constexpr float GetGemEndX(int32_t fretIndex)
{
    return DefaultGemEndX + (fretIndex * DefaultGemEndXDistance);
}

void ShiftNotesOver(int32_t shiftAmount, int startNoteIndex = 0, int endNoteIndex = 4)
{
    for (int i = startNoteIndex; i <= endNoteIndex; ++i)
    {
        float newStartX = GetGemStartX(i + shiftAmount);
        float newEndX = GetGemEndX(i + shiftAmount);
        g_gemStartX[i] = newStartX;
        g_gemEndX[i] = newEndX;
        g_gemAngle[i] = GemAngle(newStartX, DefaultGemStartY, newEndX, DefaultGemEndY);
    }
}

bool InWindow(float noteTime, float window = 0.5f)
{
    if (!g_inSong)
        return false;

    double &g_currentSongSeconds = *(double *)(0x00C489E0);
    float offset = 1.2f;
    noteTime -= offset;
    return (g_currentSongSeconds >= noteTime && g_currentSongSeconds <= (noteTime + window));
}


//Indicates how spooky the song is. Increases over time leading to a higher frequency of scary effects
static float m_spookyWeightModifier = 0.0f;

template<uint32_t index>
void MutateRandomly(bool &variable, float flashWeight = 0.4f, float onWeight = 0.000005f, float offWeight = 0.001f)
{
    static bool isMutating = false;
    
    if (isMutating)
    {
        variable = FlipCoin(flashWeight);

        if (FlipCoin(offWeight))
            isMutating = false;
    }
    else
    {
        variable = true;

        if (FlipCoin(onWeight * m_spookyWeightModifier))
            isMutating = true;
    }

}

static bool randomVibration = true;

//"Orchestrates" the creepy corruption like effects that happen in the haunted song.
void Orchestrator()
{
    if (g_forceNoInstances)
        g_renderInstances = false;
    if (g_forceNoWorld)
        g_renderGeoms = false;
    if (g_forceNoDraw2D)
        g_render2D = false;
    if (g_forceNoDraw)
        g_renderScreenFx = false;
    if (g_forcedJitter)
    {
        if (FlipCoin(0.5f))
            VibrateText(20.0f);
    }

    if (!g_enabled)
        return;

    //Shifting
    if (g_currentSongSeconds <= 58.0f)
        ShiftNotesOver(0);
    if (InWindow(69.33f))
        ShiftNotesOver(-1,0,0);
    else if (InWindow(72.00f))
        ShiftNotesOver(0, 0, 0);
    else if (InWindow(80.00f))
        ShiftNotesOver(-1, 0, 0);
    else if (InWindow(82.66f))
        ShiftNotesOver(-2, 0, 0);
    else if (InWindow(84.00f))
        ShiftNotesOver(-3, 0, 0);
    else if (InWindow(84.66f))
        ShiftNotesOver(-5, 0, 0);
    else if (InWindow(85.33f,20.0f))
    {
        ShiftNotesOver(rand()%20 - 10);
    }
    
    //LOL
    //Uncomment if you want the menu to explode after 22 seconds
    //m_spookyWeightModifier = 0.0f;
    //const float maxWeight = 22.0f;
    //if (g_currentSongSeconds > 22.0f)
    //{
    //    const float minSpookTime = 22.0f;
    //    const float maxSpookTime = 29.0f;
    //    m_spookyWeightModifier = ((static_cast<float>(g_currentSongSeconds) - minSpookTime) / (maxSpookTime - minSpookTime));
    //    m_spookyWeightModifier *= m_spookyWeightModifier;
    //    m_spookyWeightModifier *= maxWeight;
    //    if (m_spookyWeightModifier > maxWeight)
    //        m_spookyWeightModifier = maxWeight;
    //}

    m_spookyWeightModifier = 0.0f;
    const float maxWeight = 5.0f;
    if (g_inSong && g_currentSongSeconds > 8.0f)
    {
        
        const float minSpookTime = 8.0f;
        const float maxSpookTime = 75.0f;
        m_spookyWeightModifier = ((static_cast<float>(g_currentSongSeconds) - minSpookTime) / (maxSpookTime-minSpookTime));
        m_spookyWeightModifier *= m_spookyWeightModifier;
        m_spookyWeightModifier *= maxWeight;
        if (m_spookyWeightModifier > maxWeight)
            m_spookyWeightModifier = maxWeight;
    }
    
    RandomizeSeed();

    MutateRandomly<0>(randomVibration, 0.0f, 0.0001f);

    //Vibrating text
    VibrateText(0.0f);
    if (InWindow(51.8f, 6.0f))
    {
        if(FlipCoin(0.5f))
            VibrateText(50.0f);
    }
    if (!randomVibration)
    {
        if (FlipCoin(0.5f))
            VibrateText(20.0f);
    }

    float spookyRatio = m_spookyWeightModifier / maxWeight;
    if (!g_forceNoInstances)
        MutateRandomly<1>(g_renderInstances, static_cast<float>(0.5 - (0.4 * spookyRatio)), 0.000015f, 0.0003f);
    if (!g_forceNoWorld)
        MutateRandomly<2>(g_renderGeoms, 0.25f, 0.000015f, 0.0005f);
    if (!g_forceNoDraw2D)
        MutateRandomly<3>(g_render2D, 0.5f);
    if (!g_forceNoDraw)
        MutateRandomly<4>(g_renderScreenFx, 0.0f, 0.0000012f, 0.0002f);
}

void __declspec(naked) GameFrameHookNaked()
{
    static const uint32_t returnAddress = 0x005B0C59;

    __asm
    {
        pushad; //pushad and popad are overkill but who cares 
        call GameFrameHook;
        popad;

        //Displaced code
        mov     eax, [ecx + 8];
        and     eax, 0Fh;
        add     eax, 0FFFFFFFFh;

        jmp returnAddress;
    }
}



///Vibrates text vertically
void VibrateText(float range)
{
    //Update this to "pulse" messups

    //GH3::HashMapNode *node = GH3::GlobalMap::GetNode(KEY_FONT_BASELINE_OFFSET);
    //if (node == nullptr)
    //	return;

    float value = 0;
    float f = (float)rand() / RAND_MAX;
    f *= f;
    f *= f;
    if (rand() > RAND_MAX / 2)
        f *= -1;
    value += range*f;

    g_fontBaselineOffset = value;
}

///Special string variants. These strings will be "corrupted" by the game in specific ways
enum class SpecialStringEnum
{
    NORMAL = 0, 
    GARBAGE_STATIC, 
    GARBAGE_EVERYFRAME,  
    GARBAGE_SPORADIC,
    RANDOM_STATIC,	
    RANDOM_EVERYFRAME,
    RANDOM_SPORADIC,
    SECRET_SONG,
};

///Determine if the given string is a special string variant and if so, what type it is
SpecialStringEnum StringType(const wchar_t *str)
{
    if (str == nullptr || wcsncmp(str, defaultGarbageText, 5) != 0)
        return SpecialStringEnum::NORMAL;

    switch (str[5])
    {
    case L'0':
        return SpecialStringEnum::GARBAGE_STATIC;
    case L'1':
        return SpecialStringEnum::RANDOM_STATIC;
    case L'2':
        return SpecialStringEnum::GARBAGE_SPORADIC;
    case L'3':
        return SpecialStringEnum::RANDOM_SPORADIC;
    case L'4':
        return SpecialStringEnum::GARBAGE_EVERYFRAME;
    case L'5':
        return SpecialStringEnum::RANDOM_EVERYFRAME;
    case L'6':
        return SpecialStringEnum::SECRET_SONG;
    default:
        return SpecialStringEnum::NORMAL;
    }
}

/// Applies a special corruption effect to the string designated for the haunted song title
/// Alternates between displaying "HELP ME" and random corruptions of game code and a person screaming for help
void SecretSongifyString(wchar_t *str)
{
    static uint32_t spookyIndex = rand();
    static bool isSpooky = false;
    static uint32_t lastFrame = 0;
    const float spookOnWeight = 0.01f; //Odds that the song title will transition into the spooky state where it says creepy things
    const float spookOffWeight = 0.02f; //Odds that the spooky state will transition back into the song title

    if (str == nullptr)
        return;

    static const wchar_t * defaultName = L"H...E...L...P......M...E                                                                                                                                                                ";
    //static const wchar_t * defaultName = L"\\c2I WILL NOT BE CONTAINED                                                                                                                                                                 ";

    int i = 0;
    for (wchar_t *c = str; *c != L'\0'; ++c)
    {
        *c = defaultName[i];
        ++i;
    }

    if (isSpooky)
    {
        //This will prevent shadows from getting too nutty since they are actually a separate text object
        if (lastFrame != m_gameFrame)
        {
            spookyIndex += COUNT_OF(defaultGarbageText) - 1; //This is making the assumption that the amount of garbage text used is the same as the default garbage text which as long as I don't fuck up is a safe assumption
            lastFrame = m_gameFrame;
        }

        //Copy the spooky string over
        const wchar_t * garbageString = GarbageText::GetSpookyString(spookyIndex);
        for (wchar_t *c = str; *c != L'\0'; ++c)
        {
            *c = *garbageString;
            ++garbageString;
        }

        if (FlipCoin(spookOffWeight) && !(g_inSong && g_currentSongSeconds > 70.0))
            isSpooky = false;
        
    }
    else
    {
        if (FlipCoin(spookOnWeight))
            isSpooky = true;
    }

}

///This is the heart of all text manipulation
void __fastcall TextCopyTakeover(GH3::CXboxText *xboxText)
{
    wchar_t * const text = xboxText->text;

    if (text == nullptr)
        return;

    if (g_forceColorStrings)
        InsertRandomEscapeSequence<L'c', 13>(text);

    if (!g_enabled)
        return;

    SpecialStringEnum type = StringType(text);
    uint32_t seed = 0;
    uint32_t i;
    switch (type)
    {
        default:
        case SpecialStringEnum::GARBAGE_STATIC:
        case SpecialStringEnum::RANDOM_STATIC:
            seed = reinterpret_cast<uint32_t>(text);
            break;

        case SpecialStringEnum::GARBAGE_EVERYFRAME:
        case SpecialStringEnum::RANDOM_EVERYFRAME:
            seed = reinterpret_cast<uint32_t>(text) + m_gameFrame;
            break;

        case SpecialStringEnum::GARBAGE_SPORADIC:
        case SpecialStringEnum::RANDOM_SPORADIC:
            i = reinterpret_cast<uint32_t>(text) % COUNT_OF(m_weirdFrame);
            seed = (reinterpret_cast<uint32_t>(text)/4 + m_weirdFrame[i])/8;
            seed ^= (seed << 13);
            seed ^= (seed >> 17);
            seed ^= (seed << 5);
            seed += 541;
            break;

        case SpecialStringEnum::SECRET_SONG:
            seed = m_gameFrame;
            break;
    }
    
    srand(seed);

    switch (type)
    {
        case SpecialStringEnum::GARBAGE_STATIC:
        case SpecialStringEnum::GARBAGE_SPORADIC:
        case SpecialStringEnum::GARBAGE_EVERYFRAME:
            GarbifyString(text);
            break;
        case SpecialStringEnum::RANDOM_STATIC:
        case SpecialStringEnum::RANDOM_SPORADIC:
        case SpecialStringEnum::RANDOM_EVERYFRAME:
            ScrambleString(text);
            break;
    }

    RandomizeSeed();

    if (type == SpecialStringEnum::SECRET_SONG)
    {
        SecretSongifyString(text);
        seed = ( (m_gameFrame << 16) + 3481) ^ m_gameFrame;
        srand(seed);
    }


    if (type != SpecialStringEnum::NORMAL)
    {
        if (FlipCoin(0.05f))
            WeakScrambleString(text);
    }
    else
    {
        //if (g_inSong && FlipCoin(0.04f * m_spookyWeightModifier))
        if (FlipCoin(0.04f * m_spookyWeightModifier))
            WeakScrambleString(text, 0.05f + 0.05f * m_spookyWeightModifier, 0.08f, 0.9f);
    }
}

void __declspec(naked) TextCopyTakeoverNaked()
{
    static const uint32_t returnAddress = 0x00616996;

    __asm
    {
        push    esi;			//.text:00616990 000 
        mov     esi, ecx;		//.text:00616991 004 
        call TextCopyTakeover;

        //Displaced code
        mov     eax, [esi + 4]; //.text:00616993 004 

        jmp returnAddress;
    }
}




//Sprite texture stuff at 004FD580 

//Stops engine globals from being set every frame
void NopEngineGlobalSetting()
{
    //.text:0058A94B 1F4 mov     g_renderInstances, eax
    g_patcher.WriteNOPs((void *)0x0058A94B, 5);

    //.text:0058A95C 1FC mov     g_renderGeoms, eax
    g_patcher.WriteNOPs((void *)0x0058A95C, 5);

    //.text:0058A973 1EC mov     g_renderZoneMode, eax
    g_patcher.WriteNOPs((void *)0x0058A973, 5);

    //.text:0058A9C2 1F4 mov     g_renderPrims, eax
    g_patcher.WriteNOPs((void *)0x0058A9C2, 5);

    //.text:0058A9D3 1FC mov     g_renderPrims3D, eax
    g_patcher.WriteNOPs((void *)0x0058A9D3, 5);

    //.text:0058A9E4 204 mov     g_render2D, eax
    g_patcher.WriteNOPs((void *)0x0058A9E4, 5);

    //.text:0058A9F5 20C mov     g_renderSkins, eax
    g_patcher.WriteNOPs((void *)0x0058A9F5, 5);

    //.text:0058AA06 214 mov     g_renderParticles, eax
    g_patcher.WriteNOPs((void *)0x0058AA06, 5);

    //.text:0058AA17 21C mov     g_noRender_OverrideChecksum, eax
    g_patcher.WriteNOPs((void *)0x0058AA17, 5);

    //.text:0058AA28 224 mov     g_renderScreenFx, eax
    g_patcher.WriteNOPs((void *)0x0058AA28, 5);

    //.text:0058AA3C 1EC mov     g_onlyRender_OverrideChecksum, eax
    g_patcher.WriteNOPs((void *)0x0058AA3C, 5);

    //.text:0058AA4D 1F4 mov     g_renderLockFramerate, eax
    g_patcher.WriteNOPs((void *)0x0058AA4D, 5);

    //.text:0058AA5E 1FC fstp    g_fontBaselineOffset
    g_patcher.WriteNOPs((void *)0x0058AA5E, 6);
        
    //.text:0058AA70 204 mov     g_pixOutput, eax
    g_patcher.WriteNOPs((void *)0x0058AA70, 5);
}

void HauntMyGame()
{
    static void * const gameFrameDetour = (void *)0x005B0C50;
    static void * const xboxChangeOffsetDetour = (void *)0x00576760;
    static void * const textCopyTakeover = (void *)0x00616990;

    g_patcher.WriteJmp(gameFrameDetour, GameFrameHookNaked); // Game frame hook. Runs every frame after engine is initialized
    g_patcher.WriteJmp(textCopyTakeover, TextCopyTakeoverNaked);
    NopEngineGlobalSetting();
}