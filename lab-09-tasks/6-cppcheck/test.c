void check_endianess(void)
{
  int a;
  char *p = (char *)&a;
 
  if (*p)
    printf("Little endian\n");
  else
    printf("Big endian\n");
}
