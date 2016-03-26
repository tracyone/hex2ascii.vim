/**
 * Copyright (c),2002-2016,tracyone. 
 * All rights reserved.
 *
 * @file			hex2ascii.c
 * @brief			read text file which content hex then convert it to ascii
 *                  just like one of the st3 function:
 *                  File->Save with Encoding->hexadecimal
 * @date			2016-03-26/20:53:11
 * @compiler		gcc
 * @author			tracyone , tracyone@live.cn
 * @lastchange		2016-03-26/20:53:11
 * @history
 * 1,2016-03-26/20:53:11 first release
 *
 * ================================================================
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <libgen.h>

char hexdigit (char c)
{
    char outc;

    outc = c - '0';
    if (outc > 9)                                 /* A - F or a - f */
        outc -= 7;                                  /* A - F */
    if (outc > 15)                                /* a - f? */
        outc -= 32;
    if ((outc > 15) || (outc < 0))
    {
        fprintf (stderr, "Invalid character %c, aborting\n", c);
        exit(4);
    }
    return outc;
}

int main (int argc, char *argv [])
{
    char oc;
    FILE *text=NULL;
    FILE *outfile=NULL;
    char *hexchar=NULL;
    if ( argc < 3  )
    {
        printf("Uasge:%s textfile outputfile\n", basename(argv[0]));
        exit(2);
    }
    text=fopen(argv[1],"r+");
    if ( text == NULL )
    {
        printf("Open %s failed\n", argv[1]);
        exit(3);
    }

    outfile = fopen(argv[2],"w+");
    if ( outfile == NULL )
    {
        printf("Create %s failed\n", argv[1]);
        exit(3);
    }

    hexchar=malloc(2);
    if (hexchar == NULL )
    {
        printf("Malloc failed!\n");
        exit(3);
    }
    while( !feof(text)  ) 
    {
        if (fread(hexchar,1,2,text) == 1)
        {
            if ( hexchar[0] == '\n' )
                continue;
            fprintf (stderr,"must be even\n");
            fclose(text);
            fclose(outfile);
            exit(3);
        }
        else
        {
            if ( hexchar[0] == '\n' || hexchar[0] == ' ' )
            {
                ungetc(hexchar[1],text);
                continue;
            }
            if (*hexchar)
            {
                oc = (hexdigit (*hexchar++) << 4) ;
                oc +=  hexdigit (*hexchar++);
                fputc (oc, outfile);
            }
        }

    }
    printf("Convert successfully\n");
    fclose(text);
    fclose(outfile);

    return 0;
}
