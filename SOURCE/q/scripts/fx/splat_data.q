Splat_Critical_Remaining_Polys_Pcnt = 0.5
Splat_Alpha_Degen_Rate = 8

script PreAllocSplats
	printf \{"Initializing SplatHeap"}
	PreAllocTextureSplat \{name = 'JOW_Grit01' material = sys_BloodSplat01_sys_BloodSplat01}
	PreAllocTextureSplat \{name = 'JOW_Puff01' material = sys_BloodSplat02_sys_BloodSplat02}
	PreAllocTextureSplat \{name = 'skidtrail' material = sys_skidmark_sys_skidmark}
endscript
