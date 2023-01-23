#include <string.h>
#include <stdlib.h>
#include <stdio.h>


//#define LOG
#ifdef LOG
#define print printf
#else
#define print(...)
#endif

#define ESWAP(i) (((i & 0xFF) << 24) | ((i & 0xFF00) << 8) | ((i & 0xFF0000) >> 8) | ((i & 0xFF000000) >> 24))
typedef unsigned int uint;

void AlignFile(FILE*f,unsigned char bits)
{
	int*fnull = calloc(32,sizeof(int));
	// bits == 2, align to 4 bytes
	bits = 1 << bits;
	unsigned char align = ftell(f);
	if (align&(bits-1))
		fwrite(fnull, 1, bits-(align&(bits-1)), f);
}
int align(int a, unsigned char bits)
{
	bits = 1 << bits;
	unsigned char align = a;
	if (align&(bits-1))
		return bits-(align&(bits-1));
	return 0;
}

//__attribute__ ((section(".text")))
char*filebase="fastgh3_%s.mp3";
char*names[]={
	"guitar",
	"rhythm",
	"song",
	"preview"
};
enum bitrate_index {
	M_free = 0b0000,
	M_32b = 0b0001,
	M_40b = 0b0010,
	M_48b = 0b0011,
	M_56b = 0b0100,
	M_64b = 0b0101,
	M_80b = 0b0110,
	M_96b = 0b0111,
	M_112b = 0b1000,
	M_128b = 0b1001,
	M_160b = 0b1010,
	M_192b = 0b1011,
	M_224b = 0b1100,
	M_256b = 0b1101,
	M_320b = 0b1110,
	M_bad = 0b1111
};
enum samprate_index {
	M_r44100 = 0b00,
	M_r48000 = 0b01,
	M_r32000 = 0b10,
	M_rreserved = 0b11
};
// VERSION 1, LAYER 3
// only format we're using (i'm pretty sure)
uint16_t bitrates(uint8_t index) {
	if (!index) return 0; // free (to parse for special data by program)
	if (index < 15)
		// lfg so based
		return (32 + ((--index&3)<<3) << (index>>2));
	return -1; // bad
}
uint16_t samprates[] = {
	44100,
	48000,
	32000,
	-1 // bad
};

// 0xFFFB504C & 0xFFE00000 >> 21 & 0x7FF
#define MFRAME_GET_FSYNC(h) h >> 21
// 0xFFFB504C & 0x00180000 >> 19 & 0x3
#define MFRAME_GET_VERSN(h) h >> 19 & 3
// 0xfffb504c & 0x00060000 >> 17 & 0x3
#define MFRAME_GET_LAYER(h) h >> 17 & 3
// 0xFFFB504C & 0x00010000 >> 16 & 1
#define MFRAME_GET_PRTCT(h) h >> 16 & 1
// 0xFFFB504C & 0x0000F000 >> 12 & 0xF
#define MFRAME_GET_BTIDX(h) h >> 12 & 15
// 0xFFFB504C & 0x00000C00 >> 10 & 3
#define MFRAME_GET_FRIDX(h) h >> 10 & 3
// 0xFFFB504C & 0x00000200 >> 9 & 1
#define MFRAME_GET_PADBT(h) h >> 9 & 1
// 0xFFFB504C & 0x00000100 >> 8 & 1
#define MFRAME_GET_PRVBT(h) h >> 8 & 1
// 0xFFFB504C & 0x000000C0 >> 6 & 1
#define MFRAME_GET_CHNLM(h) h >> 6 & 3
#define MFRAME_GET_MDEXT(h) h >> 4 & 3
// 0xFFFB504C & 0x00000008 >> 3 & 1
#define MFRAME_GET_COPYR(h) h >> 3 & 1
// 0xFFFB504C & 0x00000004 >> 2 & 1
#define MFRAME_GET_ORGNL(h) h >> 2 & 1
#define MFRAME_GET_EMPHS(h) h & 3

typedef uint32_t MHDR;
typedef struct {
	uint32_t hdr;
	uint8_t*data;
} MFRAME_TAG, *MFRAME;

// samples per frame
#define SPF 1152
#define __FC 4
#define __ESIZE 0x50
#define __SSIZE 8 + (__ESIZE * __FC)
#define __FNSIZE 30
const int spf	= SPF;
const int ssize	= __SSIZE;
const int fc	= __FC; // FC ACAIPOG
const int esize	= __ESIZE;
const int fnsize= __FNSIZE;
typedef struct {
	uint16_t ssize; // __SSIZE
	char fname[__FNSIZE]; // 30 bytes
	uint32_t samples;
	uint32_t datasize;
	uint32_t loop_start;
	uint32_t loop_end;
	uint32_t mode;
	uint32_t rate;
	uint16_t vol;
	uint16_t pan;
	uint16_t priority;
	uint16_t chs;
	float min_dist;
	float max_dist;
	uint32_t var_freq;
	uint16_t var_vol;
	uint16_t var_pan;
} FENTRY;
int constheader[] = {
	ESWAP(0x46534233),
	// "error: initializer element is not constant"
	// WHEN THE VALUE IS CONSTANT!!!!!!!!!!!!!!!!!!!!!!
	__FC,
	__SSIZE,
	0,
	ESWAP(0x01000300), // shorts: 1,3
	0
};
FENTRY fileent = {
	ssize: __ESIZE,
	samples: 0,
	datasize: 0,
	loop_start: 0,
	loop_end: 0,
	mode: 0x204,
	rate: 44100,
	vol: 0xff,
	pan: 0x80,
	priority: 0xff,
	chs: 2,
	min_dist: 1.f,
	max_dist: 10000.f,
	var_freq: 0,
	var_vol: 0,
	var_pan: 0
};
uint32_t MFRAME_SIZE(uint32_t hdr)
{
	// MAKING 144 A FLOAT BLOATED THE PROGRAM SUPER HARD WTFFFFF
	// time to use linking with FASM (which i have already for another thing)
	return 144*(bitrates(MFRAME_GET_BTIDX(hdr))*1000)/samprates[MFRAME_GET_FRIDX(hdr)];
}

int __getmainargs(int * _Argc, char *** _Argv, char *** _Env, int _DoWildCard);

int   argc;
char**argv, __env;
_start() //int main(int argc, char*argv[])
{
	/*for (int i = 0; i < 16; i++)
	{
		//print("precalc: %u\n", bitrate_values[i]);
		print("generat: %u\n", bitrates(i));
	}*/
	__getmainargs(&argc,(char***)&argv,(char***)&__env,0);
	if (argc != 1+5)
	{
		print("insufficient arguments\n");
		return 1;
	}
	// arg order:
	// [0]: fastgh3_guitar
	// [1]: fastgh3_rhythm
	// [2]: fastgh3_song
	// [3]: fastgh3_preview
	// [4]: output path/name
	//char*fname = argv[5];
	print("output: %s\n",argv[5]);
	FILE*FSB = fopen(argv[5],"wb"), *MP3;
	fwrite(&constheader,4,6,FSB);
	int i;
	for (i = 0; i < fc; i++)
	{
		print("loading audio (1): %s\n",argv[i+1]);
		
		MHDR h;
		MP3 = fopen(argv[i+1],"rb");
		if (!MP3)
		{
			print("fail: %s\n",argv[i+1]);
			return 1;
		}
		fseek(MP3,0,SEEK_END);
		size_t _EOF = ftell(MP3);
		fileent.datasize = _EOF + align(_EOF, 4);
		int samplecount = 0;
		fseek(MP3,0,SEEK_SET);
		while (ftell(MP3) < _EOF) // WHY NO WORK !feof(MP3)
		{
			fread(&h,sizeof(MHDR),1,MP3);
			*(int*)(&h) = ESWAP((int)h);
			fseek(MP3, MFRAME_SIZE(h)-4, SEEK_CUR);
			fseek(MP3, MFRAME_GET_PADBT(h), SEEK_CUR); // WHY
			//print("got frame: %u bytes\n",MFRAME_SIZE(h));
			samplecount += spf;
			// does the | 0x000FF000 mean there is audio?
			// yeah i definitely wont figure out DCT anytime soon probably
		}
		fseek(MP3,0,SEEK_SET);
		fileent.samples = samplecount;
		//print("audio length: %f\n", songlength);
		fclose(MP3);
		
		sprintf(fileent.fname,filebase,names[i]);
		fwrite(&fileent,sizeof(FENTRY),1,FSB);
	}
	AlignFile(FSB,4);
	int total_2 = ftell(FSB);
	for (i = 0; i < fc; i++)
	{
		print("loading audio (2): %s\n",argv[i+1]);
		
		MP3 = fopen(argv[i+1],"rb");
		fseek(MP3,0,SEEK_END);
		int size = ftell(MP3);
		char*MP3f = (char*)malloc(size);
		fseek(MP3,0,SEEK_SET);
		fread(MP3f,1,size,MP3);
		fwrite(MP3f,1,size,FSB);
		//free(MP3f);
		fclose(MP3);
		AlignFile(FSB,4);
	}
	int total = ftell(FSB) - total_2;
	fseek(FSB,12,SEEK_SET);
	fwrite(&total,sizeof(int),1,FSB);
	//MFRAME_TAG test;
	//int hhh = ESWAP(0xFFFB504C);
	//memcpy(&test,&hhh,4);
	//fwrite(&test,sizeof(int),1,FSB);
	fclose(FSB);
	return 0;
}
