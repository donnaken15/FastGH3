
#include <stdio.h>
#include <stdlib.h>

char*fdata;
FILE*file;
unsigned int size;
unsigned long long hash = 0x5745534C45593634, // "WESLEY64"
		hashrev = 0x343659454C534557;

int main(int argc, char*argv[])
{
	if (argc > 1)
	{
		file = fopen(argv[1], "rb");
		if (file)
		{
			fseek(file,0,SEEK_END);
			size = ftell(file);
			fseek(file,0,SEEK_SET);
			fdata = malloc(size);
			fread(fdata,size,1,file);
			for (int i = 0; i < size; i++)
				hash ^= (((unsigned long long)fdata[i] << 56) >> ((i%8)*8));
			hash ^= ((unsigned long long)size * hashrev);
			printf("%08X",(hash >> 32));
			printf("%08X\n",(hash));
		}
	}
}
