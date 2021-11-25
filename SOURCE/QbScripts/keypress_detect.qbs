script() {

/*
	if (WinPortSioGetControlPress(deviceNum=%deviceNum,actionNum=%actionNum)
		break
	endif

repeat(1)
{
if (WinPortSioGetControlPress(deviceNum=(*winport_bb_device_num),actionNum=1)) {
	printf("keypress !!!!!!!!!!!!!");
}
Wait(1,gameframe);
}*/

repeat
{
printf("KEYBOARD TEST");
//winport_wait_for_control_press(deviceNum=0,actionNum=1);
WinPortSioGetControlPress(deviceNum=4294967295,actionNum=1);
//formattext(textname=text222, "%c", c=100);
//printf(text222);
Wait(0.2,Seconds);
}

}