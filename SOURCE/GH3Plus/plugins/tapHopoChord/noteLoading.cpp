#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include "tapHopoChord.h"

//GH3 functions
static const void * const QbKvPairListGetByte = (void *)0x0040A9B0;

//Using global variables as a substitution for stack space
uint32_t g_openLength = 0;
uint32_t g_hopoFlag = 0;


// Open notes - increase fret array
// During loading, mask GRYBO bits if open flag is set























bool __fastcall IsSingleNote(FretMask fretMask)
{
	return (fretMask == FretMask::GREEN ||
		fretMask == FretMask::RED ||
		fretMask == FretMask::YELLOW ||
		fretMask == FretMask::BLUE ||
		fretMask == FretMask::ORANGE ||
		fretMask == FretMask::OPEN);
}

FretMask __fastcall GetFretmaskFromTrackArray(GH3::QbArray *trackArray, int currentNote)
{
	uint32_t result = 0; 
	int realFretMask = trackArray->Get(currentNote + 2);

	if (realFretMask & QbFretMask::QbOpen)
		return FretMask::OPEN;

	if (realFretMask & QbFretMask::QbGreen)
		result = FretMask::GREEN;                 
													
	if (realFretMask & QbFretMask::QbRed)
		result |= FretMask::RED;                  
													
	if (realFretMask & QbFretMask::QbYellow)
		result |= FretMask::YELLOW;                           
													
	if (realFretMask & QbFretMask::QbBlue)
		result |= FretMask::BLUE;                              
													 
	if (realFretMask & QbFretMask::QbOrange)
		result |= FretMask::ORANGE;                           
												
	return (FretMask)result;
}

FretMask __fastcall GetFretmaskFromNoteQbArray(GH3::QbArray *noteArr)
{
	if (noteArr->Get(8))
		return FretMask::OPEN;

	uint32_t fretMask = 0;
		
	if (noteArr->Get(1))
		fretMask |= FretMask::GREEN;

	if (noteArr->Get(2))
		fretMask |= FretMask::RED;

	if (noteArr->Get(3))
		fretMask |= FretMask::YELLOW;

	if (noteArr->Get(4))
		fretMask |= FretMask::BLUE;

	if (noteArr->Get(5))
		fretMask |= FretMask::ORANGE;

	return static_cast<FretMask>(fretMask);
}




// Injected into the code loading an individual note
static void * const hopoFlagDetour = (void *)0x0041D22E;
__declspec(naked) void loadTappingFlagNaked()
{
	static const int frameOffset = 0x48 + 0x4 * 8; //push an addition 4 for each offset register

	//Needed stack variables of GuitarInputFrame
	static const int arg_C = 0x10 + frameOffset;
	static const int obj = 0x04 + frameOffset;
	static const int hopoRaw = -0x28 + frameOffset;

	static const unsigned int returnAddress = 0x0041D239;

	//Too fucking lazy to convert this to C
	//It's just loading the tapping flag and setting hopo flag to 2 if it has one
	_asm
	{
		pushad

		mov      eax, [esp + 0x78]; //[esp + arg_C]
		mov      edx, [eax + 4];
		mov      eax, [eax + 8];
		mov      edi, eax;
		mov      ecx, eax;
		cmp      edx, 1;
		jz       branch_a;
		mov      edi, [eax + esi * 4 + 4];
		mov      ecx, [eax + esi * 4 + 8];

		branch_a:
		sar      ecx, 6;
		and		 ecx, 1;
		cmp      ecx, 1;
		jnz      branch_b;
		mov      edi, 2;
		mov		 [esp + 0x40], edi; //[esp + hopoRaw]

		branch_b :

		popad;

		mov     eax, KEY_PLAYER; //Existing code we pushed out of the way to jump to this cave
		push    eax;
		call    QbKvPairListGetByte;

		jmp     returnAddress; //Return to normal execution

	};
}




void __stdcall LoadOpenHopoTappingBits(GH3::QbArray *noteQbArr, GH3::QbArray *placedNotesQbArr, int currentNote, int noteIndex, float hammerOnTolerance)
{
	//noteQbArr has a repeating sequence of [offset in ms, length in ms, fretmask]
	//placedNotesQbArr is an array of QbArrays

	int sustainLength = 0;
	int openLength = 0;
	HopoFlag hopoFlag; //Actual flag that will be set on the note placed on the highway
	HopoFlag hopoRaw = HopoFlag::STRUMMED; //Calculated hopo value
	bool hopoFlip = false;
	bool tappingFlag = false;

	GH3::QbArray *prevNoteQbArray;

	FretMask fretMask;
	FretMask prevFretMask;
	FretMask currentFretMask;

	int noteQbArrSize = noteQbArr->Length();
	int prevNoteTime;
	int noteTime;

	if (noteQbArrSize != 1)
	{
		sustainLength = noteQbArr->Get(currentNote + 1); 
		fretMask = static_cast<FretMask>(noteQbArr->Get(currentNote + 2));

		if (sustainLength * (fretMask & QbFretMask::QbHopoflip) != 0)
			hopoFlip = true;
	
		if (sustainLength * (fretMask & QbFretMask::QbTapping) != 0)
			tappingFlag = true;

		openLength = sustainLength * ((fretMask >> 7) & 1);
	}

	if (noteIndex > 0)
	{
		prevNoteQbArray = reinterpret_cast<GH3::QbArray *>(placedNotesQbArr->Get(noteIndex - 1));
		prevFretMask = GetFretmaskFromNoteQbArray(prevNoteQbArray);
		currentFretMask = GetFretmaskFromTrackArray(noteQbArr, currentNote);

		prevNoteTime = prevNoteQbArray->Get(0);
		noteTime = noteQbArr->Get(currentNote);

		if (hammerOnTolerance >= ((float)noteTime - (float)prevNoteTime)
			&& IsSingleNote(currentFretMask)
			&& currentFretMask != prevFretMask)
		{
			hopoRaw = HopoFlag::HOPO;
		}
	}

	hopoFlag = static_cast<HopoFlag>((hopoFlip ? 1 : 0) ^ hopoRaw);

	if (tappingFlag)
		hopoFlag = HopoFlag::TAPPING;

	g_hopoFlag = hopoFlag;
	g_openLength = openLength;
}

static void * const LoadHopoFlagDetour = (void *)0x0041D14C;
void __declspec(naked) LoadOpenHopoTappingBitsNaked()
{
	static const unsigned int returnAddress = 0x0041D239;

	__asm
	{
		push	[esp + 40h]; // hammeronTolerance
		push	[esp + (30h + 04h)]; // noteIndex
		push	[esp + (54h + 08h)]; // currentNote
		push	[esp + (34h + 0Ch)]; // placedNotesQbArr
		push	[esp + (58h + 10h)]; // noteQbArr
		call	LoadOpenHopoTappingBits;

		mov		eax, g_hopoFlag;
		mov		[esp + 20h], eax;

		mov     ecx, [esp + 4Ch] //list
		mov     eax, KEY_PLAYER; //Existing code we pushed out of the way to jump to this cave
		push    eax;
		call    QbKvPairListGetByte;
		jmp     returnAddress; //Return to normal execution
	}
}





int __fastcall CreateNoteWithOpenImpl(GH3::QbArray *noteArray, int noteIndex, int noteTime, int greenLength, int redLength, int yellowLength, int blueLength, int orangeLength, int hopoFlag, int nextNoteTime)
{
	GH3::QbArray *note = reinterpret_cast<GH3::QbArray *>(noteArray->Get(noteIndex));

	note->Set(0, noteTime);
	note->Set(1, greenLength);
	note->Set(2, redLength);
	note->Set(3, yellowLength);
	note->Set(4, blueLength);
	note->Set(5, orangeLength);
	note->Set(6, hopoFlag);
	note->Set(7, nextNoteTime);
	note->Set(8, g_openLength);

	return 1;
}

void *CreateNote = (void *)0x0041AB60;
int __declspec(naked) CreateNoteWithOpen()
{
	__asm
	{
		mov edx, ecx;
		mov ecx, eax;
		jmp CreateNoteWithOpenImpl;
	}
}



bool TryApplyNoteLoadingPatches()
{


	return (g_patcher.WriteInt8((void *)0x0041AAD6, 9) && // Allocate an extra slot for open notes in the open note structure (normally 8)
			g_patcher.WriteJmp(hopoFlagDetour, LoadOpenHopoTappingBitsNaked) &&

			g_patcher.WriteJmp(CreateNote, CreateNoteWithOpen) && //Substitute our own CreateNote function that handles open notes
			g_patcher.WriteNOPs((void *)0x0041D452, 3) && //NOP out the "sub esp 20h" following any CreateNote call since we are cleaning up the stack ourselves (effectively changing the calling convention)
			g_patcher.WriteNOPs((void *)0x0041AD97, 3) &&
			g_patcher.WriteInt8((void *)0x0041D451, 0x28)); //Since the stack will no longer be off by 0x20 we need to fix anything that grabs a stack variable before it is correct);
}
