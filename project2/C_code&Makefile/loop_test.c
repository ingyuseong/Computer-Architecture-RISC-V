#define LOOP 5120

int loop_test()
{
    int result = 0;
    int a[LOOP];
    
	for (int i = 0 ; i < LOOP; i += 8)
            a[i] = i;
    
    
	for (int i = 0 ; i < LOOP; i += 8)
        result = result + a[i];

    return result;
}
