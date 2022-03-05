SECTIONS
{
  . = 0x00000000;
	.text : 
	{
		*(.text) 
		*(.rodata)
	}

	. = ALIGN(0x00020000);

	.data : {*(.data)}

	.bss : {*(.bss)}
}