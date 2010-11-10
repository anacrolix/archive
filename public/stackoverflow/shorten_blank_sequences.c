main()
{
    int c;
    while ((c = getchar()) != EOF)
    {
        if (isblank(c)) {
            do {
                c = getchar();
            } while (c != EOF && isblank(c));
            putchar(' ');

    }
    return 0;
}
