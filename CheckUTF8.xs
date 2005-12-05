#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

/*
 * Copyright 2001 Unicode, Inc.
 *
 * Disclaimer
 *
 * This source code is provided as is by Unicode, Inc. No claims are
 * made as to fitness for any particular purpose. No warranties of any
 * kind are expressed or implied. The recipient agrees to determine
 * applicability of information provided. If this file has been
 * purchased on magnetic or optical media from Unicode, Inc., the
 * sole remedy for any claim will be exchange of defective media
 * within 90 days of receipt.
 *
 * Limitations on Rights to Redistribute This Code
 *
 * Unicode, Inc. hereby grants the right to freely use the information
 * supplied in this file in the creation of products supporting the
 * Unicode Standard, and to make copies of this file in any form
 * for internal or external distribution as long as this notice
 * remains attached.
 */


typedef unsigned char UTF8;
typedef unsigned char Boolean;

#define false           0
#define true            1

static const char trailingBytesForUTF8[256] = {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5
};

static Boolean isLegalUTF8(UTF8 *source, int length) {
        UTF8 a;
        UTF8 *srcptr = source+length;
        switch (length) {
        default: return false;
                /* Everything else falls through when "true"... */
        case 4: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
        case 3: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
        case 2: if ((a = (*--srcptr)) > 0xBF) return false;
                switch (*source) {
                    /* no fall-through in this inner switch */
                    case 0xE0: if (a < 0xA0) return false; break;
                    case 0xF0: if (a < 0x90) return false; break;
                    case 0xF4: if (a > 0x8F) return false; break;
                    default:  if (a < 0x80) return false;
                }
        case 1: if (*source >= 0x80 && *source < 0xC2) return false;
                if (*source > 0xF4) return false;
        }
        return true;
}

/********************* End code from Unicode, Inc. ***************/

/*
 * Author: Brad Fitzpatrick
 *
 */

Boolean isLegalUTF8String(char *str, int len)
{
    UTF8 *cp = str;
    int i;
    while (*cp) {
        /* how many bytes follow this character? */
        int length = trailingBytesForUTF8[*cp]+1;

        /* check for early termination of string: */
        for (i=1; i<length; i++) {
            if (cp[i] == 0) return false;
        }

        /* is this a valid group of characters? */
        if (!isLegalUTF8(cp, length))
            return false;

        cp += length;
    }

    /* if we didn't make it to the end, there must've been an internal null
     * in the perl string, which we're saying is bogus utf-8, since there's
     * no point for users giving us null chars.                             */
    return (cp == str+len) ? true : false;
}

MODULE = Unicode::CheckUTF8	PACKAGE = Unicode::CheckUTF8

PROTOTYPES: DISABLE


Boolean
isLegalUTF8String (str, len)
	char *	str
	int	len

