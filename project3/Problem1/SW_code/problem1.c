int fib(int n)
{
   if (n <= 1)
      return n;
   return fib(n-1) + fib(n-2);
}


int main (void)
{
  int n = 4;
  int x1, x2;

  x1 = fib(n-1);
  x2 = fib(n-2);
  return x1+x2;
}


