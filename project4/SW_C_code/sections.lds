SECTIONS
{
  . = 0x00000000;
	.text : 
	{
		*(.text) 
		*(.rodata)
	}

	. = ALIGN(0x00014000);

	.data : {*(.data)}

	.bss : {*(.bss)}
}
