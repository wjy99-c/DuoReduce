



char acDummy[0xf0] __attribute__ ((__BELOW100__));
unsigned char B100A __attribute__ ((__BELOW100__));
unsigned char *pA = &B100A;
unsigned char B100B __attribute__ ((__BELOW100__));
unsigned char *pB = &B100B;

char *
Do (void)
{
  if (!(B100A & 0x01))
    {
      if (!(B100B & 0x01))
 return "Fail";
      else
 return "Success";
    }
  else
    return "Fail";
}

int
main (void)
{
  *pA = 0x34;
  *pB = 0xcb;
  return Do ()[0] == 'F';
}
