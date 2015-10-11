/*
 *  Generic Call Interface for Rexx
 *  Copyright © 2003-2004, Florian Groﬂe-Coosmann
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * ----------------------------------------------------------------------------
 *
 * This file contains the code to use the API of the current Rexx
 * implementation.
 * Please, don't patch it. If you want to use a special implementation with
 * different function, e.g. for a core support, copy this file, patch it and
 * use it instead.
 */

#define INCL_REXXSAA
#include "gci.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* a forwarder, see below */
struct GCI_library;

/*
 * GCI_func is the main type for housekeeping an external function in a double
 * linked list with an extra link to the parent's library entry.
 *
 * THE REXX IMPLEMENTATION'S TECHNIQUE SHALL BE USED HERE INSTEAD!
 *
 * The relation is this:
 *                  +-----------------+
 * iname[?]<->...<->|<prev       next>|<->another_iname_element
 *                  |                 |
 *                  |       lib       |
 *                  +--------+--------+
 *   +-----------+           |
 *   | lib-entry |           |
 *   | ref-count |<----------+
 *   +-----------+
 */
typedef struct GCI_func {
   void              (*func)();      /* entry point */
   GCI_treeinfo        treeinfo;     /* entry point and argument informations */
                                     /* HOUSEKEEPING */
   GCI_str             internal;     /* internal name */
   unsigned            hash;         /* hash value for the internal name */
   struct GCI_library *lib;          /* ptr to library */
   struct GCI_func    *prev;         /* Within the internal name's list */
   struct GCI_func    *next;
} GCI_func;

/*
 * A library has a handle and a list of functions registered to it.
 */
typedef struct GCI_library {
   void               *handle;       /* whatever it will be */
   unsigned            refcount;     /* Entry will be deleted if back on 0 */
   GCI_str             library;      /* name */
   unsigned            hash;         /* hash value for library name */
   struct GCI_library *prev;         /* Within the libraries list */
   struct GCI_library *next;
} GCI_library;

/*
 * We have arrays for libraries and internal names. The element sizes shall
 * be primes.
 */
static GCI_func *internals[251] = { NULL, };
static GCI_library *libraries[251] = { NULL, };
static char prefixChar[2] = "\0";  /* two '\0', used for stem names */

/*
 * GCI_hash computes a hashvalue for str and returns it.
 *
 * This is Fowler/Noll/Vo hash for 32 bit, see
 * http://www.isthe.com/chongo/tech/comp/fnv
 */
static unsigned GCI_hash( const GCI_str *str )
{
   unsigned retval = 2166136261u;
   const char *s = GCI_ccontent( str );
   int len = GCI_strlen( str );

   while ( len-- > 0 )
   {
      retval ^= (unsigned char) *s++;
      retval *= 166777619;
   }

   return retval;
}

/*
 * internalLookup tries to look for a function with the given name in the
 * internal name space. NULL is returned if the function cannot be found.
 *
 * The argument must have been uppercased already.
 */
static GCI_func *internalLookup( GCI_str *str )
{
   unsigned hash = GCI_hash( str );
   GCI_func *f;

   if ( ( f = internals[hash % elements(internals)] ) == NULL )
      return NULL;

   while ( f != NULL )
   {
      /*
       * Comparing the hash value should be very distinctive.
       */
      if ( f->hash == hash )
      {
         if ( GCI_streq( str, &f->internal ) )
            return f;
      }

      f = f->next;
   }
   return NULL;
}

/*
 * freeFunction deletes and unlinks the given function entry. The corresponding
 * library entry isn't accessed, the usage counter not decremented.
 * The interpreter will not be informed about the deletion. Do it on your own.
 */
static void freeFunction( void *hidden,
                          GCI_func *kill )
{
   if ( kill == NULL )
      return;

   if ( kill->prev != NULL )
      kill->prev->next = kill->next;
   if ( kill->next != NULL )
      kill->next->prev = kill->prev;
   GCI_strfree( hidden, &kill->internal );
   if ( kill->treeinfo.nodes != NULL )
      GCI_free( hidden, kill->treeinfo.nodes );

   if ( internals[kill->hash % elements(internals)] == kill )
      internals[kill->hash % elements(internals)] = kill->next;

   GCI_free( hidden, kill );
}

/*
 * createFunction create an internal function from a given name. The function
 * name will NOT be registered but is linked into the internal function name's
 * list.
 * The new function is returned in *newfunc.
 * Return values:
 * GCI_OK:                   Everything is fine.
 * GCI_NoMemory:             Out of free memory.
 * GCI_FunctionAlreadyKnown: The internal name is registered already.
 */
static GCI_result createFunction( void *hidden,
                                  GCI_func **newfunc,
                                  const GCI_str *name )
{
   GCI_func *ptr, *f;
   GCI_result rc;

   *newfunc = NULL;
   if ( ( ptr = GCI_malloc( hidden, sizeof( GCI_func ) ) ) == NULL )
      return GCI_NoMemory;

   memset( ptr, 0, sizeof( GCI_func ) );

   if ( ( rc = GCI_strdup( hidden, &ptr->internal, name ) ) != GCI_OK )
   {
      freeFunction( hidden, ptr );
      return rc;
   }
   GCI_uppercase( hidden, &ptr->internal );
   ptr->hash = GCI_hash( &ptr->internal );

   if ( ( f = internals[ptr->hash % elements(internals)] ) != NULL )
   {
      while ( f != NULL )
      {
         /*
          * Comparing the hash value should be very distinctive.
          */
         if ( f->hash == ptr->hash )
         {
            if ( GCI_streq( &ptr->internal, &f->internal ) )
            {
               freeFunction( hidden, ptr );
               return GCI_FunctionAlreadyKnown;
            }
         }

         f = f->next;
      }
   }

   if ( ( f = internals[ptr->hash % elements(internals)] ) != NULL )
      f->prev = ptr;
   ptr->next = f;
   internals[ptr->hash % elements(internals)] = ptr;
   *newfunc = ptr;
   return GCI_OK;
}

/*
 * freeLibraryHandle unlinks a dynamic link library. The handle may be NULL.
 *
 * We support Windows and unix only.
 */
static void freeLibraryHandle( void *handle )
{
   if ( handle == NULL )
      return;
   GCI_freeLibrary( handle );
}

/*
 * connectLibraryHandle links a dynamic link library. The handle is returned.
 *
 * We support Windows and unix only.
 */
static void *connectLibraryHandle( void *hidden,
                                   const GCI_str *name )
{
   char *buf;
   void *retval;

   (hidden = hidden);

   if ( ( buf = GCI_malloc( hidden, GCI_strlen( name ) + 32 ) ) == NULL )
      return NULL;

   retval = GCI_getLibrary( GCI_ccontent( name ), GCI_strlen( name ), buf );

   GCI_free( hidden, buf );

   return retval;
}

/*
 * freeLibrary deletes and unlinks the given library entry. The entries usage
 * count is decremented first. If the counter doesn't become 0, nothing
 * happens.
 * The associated handle will be freed.
 */
static void freeLibrary( void *hidden,
                         GCI_library *kill )
{
   int mustkill;

   if ( kill == NULL )
      return;

   /* failsafe checking */
   mustkill = kill->refcount == 0;
   if ( --(kill->refcount) == 0 )
      mustkill = 1;

   if ( !mustkill )
      return;

   if ( kill->prev != NULL )
      kill->prev->next = kill->next;
   if ( kill->next != NULL )
      kill->next->prev = kill->prev;
   GCI_strfree( hidden, &kill->library );

   if ( libraries[kill->hash % elements(libraries)] == kill )
      libraries[kill->hash % elements(libraries)] = kill->next;

   freeLibraryHandle( kill->handle );
   GCI_free( hidden, kill );
}

/*
 * createLibrary create an library entry or increments an existing one's
 * reference count.
 * The new or known library is returned in *newlib.
 * NOT be registered but is linked into the internal function name's
 * list.
 * Return values:
 * GCI_OK:              Everything is fine.
 * GCI_NoMemory:        Out of free memory.
 * GCI_LibraryNotFound: A library of this name can not be found or loaded.
 */
static GCI_result createLibrary( void *hidden,
                                 GCI_library **newlib,
                                 const GCI_str *name )
{
   GCI_result rc;
   GCI_str newName;
   unsigned hash;
   GCI_library *ptr, *l;

   *newlib = NULL;
   if ( ( rc = GCI_strdup( hidden, &newName, name ) ) != GCI_OK )
      return rc;
   hash = GCI_hash( &newName );
   if ( ( l = libraries[hash % elements(libraries)] ) != NULL )
   {
      while ( l != NULL )
      {
         /*
          * Comparing the hash value should be very distinctive.
          */
         if ( l->hash == hash )
         {
            if ( GCI_streq( &newName, &l->library ) )
            {
               GCI_strfree( hidden, &newName );
               l->refcount++;
               *newlib = l;
               return GCI_OK;
            }
         }

         l = l->next;
      }
   }

   /*
    * Need to create a new library entry.
    */
   if ( ( ptr = GCI_malloc( hidden, sizeof( GCI_library ) ) ) == NULL )
   {
      GCI_strfree( hidden, &newName );
      return GCI_NoMemory;
   }
   memset( ptr, 0, sizeof( GCI_library ) );
   ptr->refcount = 1;
   ptr->library = newName;
   ptr->hash = hash;
   if ( ( ptr->handle = connectLibraryHandle( hidden, &newName ) ) == NULL )
   {
      freeLibrary( hidden, ptr );
      return GCI_LibraryNotFound;
   }

   if ( ( l = libraries[hash % elements(libraries)] ) != NULL )
      l->prev = ptr;
   ptr->next = l;
   libraries[hash % elements(libraries)] = ptr;
   *newlib = ptr;
   return GCI_OK;
}

/*
 * getFunctionPointer fetches a function pointer of a dynamic link library.
 * The entry point is returned. handle must be the handle of the library and
 * name the name of the function.
 *
 * We support Windows and unix only.
 */
static void ( *getFunctionPointer( void *hidden,
                                   void *handle,
                                   const GCI_str *name ) )()
{
   char *buf;
   void (*retval)();

   if ( ( buf = GCI_strtoascii( hidden, name ) ) == NULL )
      return NULL;

   retval = GCI_getEntryPoint( handle, buf );

   GCI_free( hidden, buf );

   return retval;
}

/*
 * Returns the translated function code from GCI_result to the various
 * RXFUNC_??? codes.
 * This function also shall set the textual representation of an error code
 * to that value that will be accessed by RxFuncErrMsg. If this can't be done,
 * the variable GCI_RC is set.
 *
 * dispo is either NULL (or the content is NULL) or contains the position of
 * the error within the structure. dispo's content will be deallocated.
 */
static int GCIcode2RxFuncCode( void *hidden,
                               GCI_result rc,
                               GCI_str *dispo )
{
   GCI_str description, fullinfo, *fi = NULL;
   char retval[10];
   GCI_strOfCharBuffer(retval);

   GCI_strcats( &str_retval, "GCI_RC" );
   GCI_describe( &description, rc );

   if ( ( dispo != NULL ) && ( GCI_content( dispo ) == NULL ) )
      dispo = NULL;

   if ( ( dispo != NULL ) && ( rc != GCI_OK ) )
   {
      if ( GCI_stralloc( hidden, &fullinfo, GCI_strlen( dispo ) +
                                            GCI_strlen( &description ) +
                                            3 ) == GCI_OK )
      {
         fi = &fullinfo;
         GCI_strcpy( fi, &description );
         GCI_strcats( fi, ": " );
         GCI_strcat( fi, dispo );
      }
   }

   if ( fi != NULL )
      GCI_writeRexx( hidden, &str_retval, fi, 0 );
   else
      GCI_writeRexx( hidden, &str_retval, &description, 0 );

   if ( dispo != NULL )
      GCI_strfree( hidden, dispo );
   if ( fi != NULL )
      GCI_strfree( hidden, fi );

   switch ( rc )
   {
      case GCI_OK:                   return RXFUNC_OK;
      case GCI_NoMemory:             return RXFUNC_NOMEM;
      case GCI_FunctionAlreadyKnown: return RXFUNC_DEFINED;
      case GCI_LibraryNotFound:      return RXFUNC_MODNOTFND;
      case GCI_NoLibraryFunction:    return RXFUNC_ENTNOTFND;
      case GCI_FunctionNotFound:     return RXFUNC_NOTREG;
      case GCI_SyntaxError:          return RXFUNC_BADTYPE;
      case GCI_ArgStackOverflow:     return RXFUNC_NOMEM;
      default:
         break;
   }
   return rc + 10000;
}

/*
 * GCI_migrate converts a RXSTRING into a GCI_str. No further memory
 * allocation is done and it is STRONGLY forbidden to use GCI_strfree.
 * The return value shall be used for further operations.
 */
static const GCI_str *GCI_migrate( GCI_str *str,
                                   CONST RXSTRING *string )
{
   if ( !RXVALIDSTRING( *string ) )
   {
      str->val = NULL;
      str->used = str->max = 0;
   }
   else
   {
      str->val = (char *) RXSTRPTR( *string );
      str->used = str->max = (int) RXSTRLEN( *string );
   }
   return str;
}

/*
 * assignedRxString builds a RXSTRING of a GCI_str. The RXSTRING is set
 * in the usual manner and a terminating zero is appended without notification
 * of the target. NULL-strings are converted to empty strings.
 * Returns 1 on error, 0 on success.
 */
static int assignRxString( void *hidden,
                           PRXSTRING dest,
                           const GCI_str *src )
{
   char *h;

   (hidden = hidden);

   if ( RXNULLSTRING( *dest ) || ( RXSTRLEN( *dest ) < (ULONG) src->used+1 ) )
   {
      if ( ( h = GCI_malloc( hidden, (ULONG) (src->used+1) ) ) == NULL )
      {
         /*
          * We can't do anything in case of an error.
          */
         return 1;
      }
   }
   else
      h = RXSTRPTR( *dest );

   memcpy( h, src->val, src->used );
   h[(int) (src->used)] = '\0';
   MAKERXSTRING( *dest, h, (ULONG) src->used );
   return 0;
}

/*
 * readRexx works as a merged version of the function GCI_readRexx and
 * GCI_readNewRexx below. The difference is the flag allocate. If this is
 * set, the function works aas GCI_readNewRexx, otherwise is works like
 * GCI_readRexx.
 */
static GCI_result readRexx( void *hidden,
                            const GCI_str *name,
                            GCI_str *target,
                            int symbolicAccess,
                            int signalOnNovalue,
                            int allocate,
                            int *novalue )
{
   SHVBLOCK shv;
   ULONG retval;
   GCI_result rc;

   shv.shvnext = NULL;
   MAKERXSTRING( shv.shvname, (void *) GCI_ccontent( name ),
                              (ULONG) GCI_strlen( name ) );
   shv.shvnamelen = RXSTRLEN( shv.shvname );
   if ( allocate )
   {
      MAKERXSTRING( shv.shvvalue, NULL, 0 );
   }
   else
   {
      MAKERXSTRING( shv.shvvalue, GCI_content( target ),
                                  (ULONG) GCI_strmax( target ) );
   }
   shv.shvvaluelen = RXSTRLEN( shv.shvvalue );
   if ( symbolicAccess )
      shv.shvcode = RXSHV_SYFET;
   else
      shv.shvcode = RXSHV_FETCH;
   shv.shvret = 0;

   retval = RexxVariablePool( &shv );
   if ( shv.shvvaluelen < shv.shvvalue.strlength )
      shv.shvvalue.strlength = shv.shvvaluelen;
   if ( !allocate && ( (char *) shv.shvvalue.strptr != GCI_content( target ) ) )
         retval |= RXSHV_TRUNC;

   if ( novalue )
      *novalue = ( retval & RXSHV_NEWV ) ? 1 : 0;
   /*
    * We can't throw a condition in the simple bridge mode. But specific
    * implementations with a native interface to the interpreter shall
    * throw adequate signals.
    */

   if ( ( retval == RXSHV_OK ) ||
        ( ( retval == RXSHV_NEWV ) && !signalOnNovalue ) )
   {
      if ( allocate )
      {
         GCI_str h;

         GCI_migrate( &h, &shv.shvvalue );
         if ( ( rc = GCI_stralloc( hidden, target, GCI_strlen( &h ) ) )
                                                                    != GCI_OK )
            return rc;
         GCI_strcpy( target, &h );
      }
      else
         GCI_strsetlen( target, RXSTRLEN( shv.shvvalue ) );
      return GCI_OK;
   }

   if ( retval & RXSHV_NEWV )  return GCI_MissingValue;
   if ( retval & RXSHV_TRUNC ) return GCI_BufferTooSmall;
   if ( retval & RXSHV_BADN )  return GCI_IllegalName;
   if ( retval & RXSHV_MEMFL ) return GCI_NoMemory;

   return GCI_RexxError;
}

/*
 * This function returns 1 if a SYNTAX error should be raised, 0 otherwise.
 */
static int syntaxError( GCI_result rc )
{
   switch ( rc )
   {
      case GCI_NoMemory:
      case GCI_WrongInput:
      case GCI_NumberRange:
      case GCI_StringRange:
      case GCI_UnsupportedNumber:
      case GCI_BufferTooSmall:
      case GCI_MissingName:
      case GCI_MissingValue:
      case GCI_IllegalName:
      case GCI_RexxError:
      case GCI_NoBaseType:
      case GCI_InternalError:
      case GCI_SyntaxError:
      case GCI_ArgStackOverflow:
         return 1;

      default:
         break;
   }
   return 0;
}
/*****************************************************************************
 *****************************************************************************
 ** GLOBAL FUNCTIONS *********************************************************
 *****************************************************************************
 *****************************************************************************/

/*
 * GCI_readRexx reads the content of one variable of name "name" into the
 * "target". The size or the content-holding string of target isn't changed,
 * the caller must provide a sufficient space.
 *
 * symbolicAccess shall be set if normal access is expected. If this variable
 * is 0, the variable's name is treated as "tail-expanded" and any further
 * interpretation of the name isn't done by the interpreter.
 *
 * signalOnNovalue shall be set if this function shall throw a NOVALUE
 * condition if the variable isn't set. This function may or may not be
 * able to do so. If not, the return value is set to GCI_MissingValue.
 *
 * *novalue is set either to 1 for a return of a variable's default value or
 * to 0 if the variable has an assigned value. novalue may be NULL.
 *
 * Return values:
 * GCI_OK:             Everything is fine.
 * GCI_MissingValue:   signalOnNovalue is set and this function doesn't
 *                     support to fire a NOVALUE condition.
 * GCI_BufferTooSmall: The "target" buffer is too small to hold the result.
 * GCI_IllegalName:    "name" is illegal in terms of Rexx. Especially on
 *                     non-"symbolicAccess" the caller must provide uppercased
 *                     stem names if a stem is used.
 * GCI_RexxError:      An unexpected other error is returned by the
 *                     interpreter.
 */
GCI_result GCI_readRexx( void *hidden,
                         const GCI_str *name,
                         GCI_str *target,
                         int symbolicAccess,
                         int signalOnNovalue,
                         int *novalue )
{
   return readRexx( hidden,
                    name,
                    target,
                    symbolicAccess,
                    signalOnNovalue,
                    0,
                    novalue );
}

/*
 * GCI_readNewRexx reads the content of one variable of name "name" into the
 * "target". The content of the target is overwritten regardless of its
 * current content.
 *
 * symbolicAccess shall be set if normal access is expected. If this variable
 * is 0, the variable's name is treated as "tail-expanded" and any further
 * interpretation of the name isn't done by the interpreter.
 *
 * signalOnNovalue shall be set if this function shall throw a NOVALUE
 * condition if the variable isn't set. This function may or may not be
 * able to do so. If not, the return value is set to GCI_MissingValue.
 *
 * *novalue is set either to 1 for a return of a variable's default value or
 * to 0 if the variable has an assigned value. novalue may be NULL.
 *
 * Return values:
 * GCI_OK:             Everything is fine.
 * GCI_NoMemory:       Can't allocate enough memory for the return value.
 * GCI_MissingValue:   signalOnNovalue is set and this function doesn't
 *                     support to fire a NOVALUE condition.
 * GCI_IllegalName:    "name" is illegal in terms of Rexx. Especially on
 *                     non-"symbolicAccess" the caller must provide uppercased
 *                     stem names if a stem is used.
 * GCI_RexxError:      An unexpected other error is returned by the
 *                     interpreter.
 */
GCI_result GCI_readNewRexx( void *hidden,
                            const GCI_str *name,
                            GCI_str *target,
                            int symbolicAccess,
                            int signalOnNovalue,
                            int *novalue )
{
   return readRexx( hidden,
                    name,
                    target,
                    symbolicAccess,
                    signalOnNovalue,
                    1,
                    novalue );
}

/*
 * GCI_writeRexx sets the content of one variable of name "name" to the content
 * of "value".
 *
 * symbolicAccess shall be set if normal access is expected. If this variable
 * is 0, the variable's name is treated as "tail-expanded" and any further
 * interpretation of the name isn't done by the interpreter.
 *
 * Return values:
 * GCI_OK:             Everything is fine.
 * GCI_NoMemory:       Can't allocate enough memory for the return value.
 * GCI_MissingValue:   signalOnNovalue is set and this function doesn't
 *                     support to fire a NOVALUE condition.
 * GCI_IllegalName:    "name" is illegal in terms of Rexx. Especially on
 *                     non-"symbolicAccess" the caller must provide uppercased
 *                     stem names if a stem is used.
 * GCI_RexxError:      An unexpected other error is returned by the
 *                     interpreter.
 */
GCI_result GCI_writeRexx( void *hidden,
                          const GCI_str *name,
                          const GCI_str *value,
                          int symbolicAccess )
{
   SHVBLOCK shv;
   ULONG retval;

   (hidden = hidden);

   shv.shvnext = NULL;
   MAKERXSTRING( shv.shvname, (void *) GCI_ccontent( name ),
                              (ULONG) GCI_strlen( name ) );
   shv.shvnamelen = RXSTRLEN( shv.shvname );
   MAKERXSTRING( shv.shvvalue, (void *) GCI_ccontent( value ),
                               (ULONG) GCI_strlen( value ) );
   shv.shvvaluelen = RXSTRLEN( shv.shvvalue );
   if ( GCI_ccontent( value ) == NULL )
      shv.shvcode = (UCHAR) ( ( symbolicAccess ) ? RXSHV_SYDRO : RXSHV_DROPV );
   else if ( symbolicAccess )
      shv.shvcode = RXSHV_SYSET;
   else
      shv.shvcode = RXSHV_SET;
   shv.shvret = 0;

   retval = RexxVariablePool( &shv );

   if ( ( retval == RXSHV_OK ) || ( retval == RXSHV_NEWV ) )
   {
      return GCI_OK;
   }

   if ( retval & RXSHV_TRUNC ) return GCI_NoMemory;
   if ( retval & RXSHV_BADN )  return GCI_IllegalName;
   if ( retval & RXSHV_MEMFL ) return GCI_NoMemory;

   return GCI_RexxError;
}

/*
 * RxFuncDefine adds a function/procedure entry to the system and defines the
 * structure and infos for the external call. All arguments can be obtained
 * from the 4 arguments in argv.
 *
 * The arguments to RxFuncDefine are as usual for external library calls.
 * We use argc, argv and returnstring. The later one is set in the
 * usual manner.
 *
 * The definition and meaning of the 4 arguments can be read from the
 * comments of gci_rxfuncdefine.c:GCI_RxFuncDefine().
 *
 * The return value is 0 if 4 arguments are passed with strings, 1 otherwise.
 *
 * The return string is set in case of a return value of 0. The return string
 * will contain the error code of GCI_RxFuncDefine converted to a
 * RXFUNC_??? value. If the description of the error cannot be assigned
 * to that value usually returned by RxFuncErrMsg, the description is assigned
 * to the variable "GCI_RC".
 */
APIRET APIENTRY RxFuncDefine( PCSZ calledname,
                              ULONG argc,
                              CONST PRXSTRING argv,
                              PCSZ queuename,
                              PRXSTRING returnstring )
{
   GCI_result rc;
   GCI_str internal, library, external, stem, disposition;
   int i;
   char retval[10];
   GCI_strOfCharBuffer(retval);

   (calledname = calledname);
   (queuename = queuename);

   if ( ( argc != 4 ) )
      return 1;

   for ( i = 0; i < 4; i++ )
   {
      if ( RXNULLSTRING( argv[i] ) )
         return 1;
   }

   memset( &disposition, 0, sizeof( disposition ) );
   rc = GCI_RxFuncDefine( NULL,
                          GCI_migrate( &internal, &argv[0] ),
                          GCI_migrate( &library,  &argv[1] ),
                          GCI_migrate( &external, &argv[2] ),
                          GCI_migrate( &stem,     &argv[3] ),
                          &disposition,
                          prefixChar );


   str_retval.used = sprintf( retval, "%d",
                                      GCIcode2RxFuncCode( NULL,
                                                          rc,
                                                          &disposition ) );

   return syntaxError( rc ) ||
          assignRxString( NULL, returnstring, &str_retval );
}

/*
 * GciPrefixChar gets/sets the special character that prepends leaf names.
 *
 * The arguments to RxFuncIntroChar are as usual for external library calls.
 * We use argc, argv and returnstring. The later one is set in the
 * usual manner.
 *
 * The current prefix character is returned if no argument is passed or if
 * a valid prefix is the single argument. A valid prefix is a single character.
 * It must be one of "!#$?@_". The empty string, the blank or ASCII-0 all
 * mean that no prefix should be used.
 * The prefix is used in all following usages of GCI's leaf names that are
 * names like "CALLTYPE", "VALUE", etc.
 *
 * The return value is 0 if no argument is passed or a string containing
 * a valid prefix is the argument's content; 1 otherwise.
 *
 * The return string is set in case of a return value of 0. The return string
 * will contain the previous prefix character.
 */
APIRET APIENTRY GciPrefixChar( PCSZ calledname,
                               ULONG argc,
                               CONST PRXSTRING argv,
                               PCSZ queuename,
                               PRXSTRING returnstring )
{
   int i;
   char retval[2], prefix;
   static const char valid[] = "!#$?@_ ";
   GCI_strOfCharBuffer(retval);

   (calledname = calledname);
   (queuename = queuename);

   if ( ( argc > 1 ) )
      return 1;

   retval[0] = prefixChar[0];
   retval[1] = '\0';

   if ( argc > 0 )
   {
      if ( ( argv[0].strlength > 1 ) && ( argv[0].strptr != NULL ) )
         return 1;

      i = (int) RXSTRLEN( argv[0] );
      prefix = (char) (( i == 1 ) ? argv[0].strptr[0] : '\0');
      for ( i = 0; i < sizeof( valid ); i++ ) /* includes '\0' */
      {
         if ( prefix == valid[i] )
            break;
      }
      if ( i >= sizeof( valid ) )
         return 1;

      prefixChar[0] = (char) (( prefix == ' ' ) ? '\0' : prefix);
   }

   str_retval.used = (retval[0]) ? 1 : 0;
   return assignRxString( NULL, returnstring, &str_retval );
}

/*
 * GCI_RegisterDefinedFunction will register the function will all known
 * informations at the Rexx interpreter. We really have troubles here, in case
 * of multi-threading we smash all informations! And there is no real change
 * to bypass the error. You can add some cool system depending functions, OK,
 * but non in stupid ANSI/ISO C.
 * This function will works only for single-threaded systems! Really!
 *
 * Well, beside this, the stem has parsed and all information of it is put
 * into *ti. All contents of *ti are consumed on success and shall not be
 * reused in any case. internal, library, external are described in
 * GCI_RxFuncDefine.
 *
 * This function
 *
 * Return codes:
 * GCI_OK:                   Everything's fine.
 * GCI_NoMemory:             Not enough memory.
 * GCI_FunctionAlreadyKnown: The internal name is registered already.
 * GCI_LibraryNotFound:      A library of this name can not be found or loaded.
 * GCI_NoLibraryFunction:    An external function of this names doesn't exist
 *                           in the external library.
 */
GCI_result GCI_RegisterDefinedFunction( void *hidden,
                                        const GCI_str *internal,
                                        const GCI_str *library,
                                        const GCI_str *external,
                                        const GCI_treeinfo *ti )
{
   GCI_result rc;
   ULONG drc;
   GCI_func *f;
   GCI_library *l;
   char *name;

   if ( ( rc = createFunction( hidden, &f, internal ) ) != GCI_OK )
      return rc;

   if ( ( rc = createLibrary( hidden, &l, library ) ) != GCI_OK )
   {
      freeFunction( hidden, f );
      return rc;
   }

   f->lib = l;
   /*
    * The final step: fetch the function pointer.
    */
   if ( ( f->func = getFunctionPointer( hidden, l->handle, external ) )
                                                                      == NULL )
   {
      freeFunction( hidden, f );
      freeLibrary( hidden, l );
      return GCI_NoLibraryFunction;
   }

   /*
    * Now register the function in the interpreter.
    */
   if ( ( name = GCI_strtoascii( hidden, &f->internal ) ) == NULL )
   {
      freeFunction( hidden, f );
      freeLibrary( hidden, l );
      return GCI_NoMemory;
   }
   drc = RexxRegisterFunctionDll( name, "gci", "_GciDispatcher" );
   GCI_free( hidden, name );

   switch ( drc )
   {
      case RXFUNC_OK:
         break;

      case RXFUNC_DEFINED:
         freeFunction( hidden, f );
         freeLibrary( hidden, l );
         return GCI_FunctionAlreadyKnown;

      case RXFUNC_NOMEM:
         freeFunction( hidden, f );
         freeLibrary( hidden, l );
         return GCI_NoMemory;

      default:
         freeFunction( hidden, f );
         freeLibrary( hidden, l );
         return GCI_InternalError;
   }

   f->treeinfo = *ti;
   return GCI_OK;
}

/*
 * GciFuncDrop is a workaround and replacement for RxFuncDrop. Its intention
 * is to remove a function from the list of Rexx-available functions. This
 * should be done by RxFuncDrop in the original documentation. But the
 * interpreter doesn't know anything of GCI in bridging mode and we want to
 * support a half documented routine which shall do RxFuncDrop's work in
 * this case.
 * We expect one argument in argv[0] which must be a function's name.
 *
 * The arguments to GciFuncDrop are as usual for external library calls.
 * We use argc, argv and returnstring. The later one is set in the
 * usual manner.
 *
 * The return value is 0 if 1 argument is passed with string, 1 otherwise.
 *
 * The return string is set in case of a return value of 0. The return string
 * will contain the error code of GCI_RxFuncDefine converted to a
 * RXFUNC_??? value. If the description of the error cannot be assigned
 * to that value usually returned by RxFuncErrMsg, the description is assigned
 * the the variable "GCI_RC".
 */
APIRET APIENTRY GciFuncDrop( PCSZ calledname,
                             ULONG argc,
                             CONST PRXSTRING argv,
                             PCSZ queuename,
                             PRXSTRING returnstring )
{
   GCI_str internal;
   ULONG drc;
   GCI_result rc, rc2;
   GCI_func *f;
   char retval[10], *name;
   GCI_strOfCharBuffer(retval);

   (calledname = calledname);
   (queuename = queuename);

   if ( argc != 1 )
      return 1;

   if ( RXNULLSTRING( argv[0] ) )
      return 1;

   GCI_migrate( &internal, &argv[0] );

   /*
    * We do a failsafe deregistering here and try to deregister both at GCI as
    * at the interpreter in either case of a return value.
    */
   if ( ( f = internalLookup( &internal ) ) == NULL )
      rc = GCI_FunctionNotFound;
   else
   {
      freeLibrary( NULL, f->lib );
      freeFunction( NULL, f );
      rc = GCI_OK;
   }

   if ( ( name = GCI_strtoascii( NULL, &internal ) ) != NULL )
   {
      drc = RexxDeregisterFunction( name );
      switch ( drc )
      {
         case RXFUNC_OK:
#ifdef RXFUNC_PARTOFPKG
         case RXFUNC_PARTOFPKG:
#else
         case 20:              /* shall be RXFUNC_PARTOFPKG */
#endif
            rc2 = GCI_OK;
            break;

         case RXFUNC_NOTREG:
            rc2 = GCI_FunctionNotFound;
            break;

         default:
            rc2 = GCI_InternalError;
            break;
      }
      GCI_free( hidden, name );
   }
   else
      rc2 = GCI_NoMemory;

   if ( rc == GCI_OK )
      rc = rc2;
   str_retval.used = sprintf( retval, "%d",
                                      GCIcode2RxFuncCode( NULL,
                                                          rc,
                                                          NULL ) );

   return syntaxError( rc ) ||
          assignRxString( NULL, returnstring, &str_retval );
}

/*
 * GCI_remove_structure deallocates the GCI_treeinfo structure and all
 * descendants.
 * THIS FUNCTION IS NOT USED IN THE API BRIDGING MODE.
 */
void GCI_remove_structure( void *hidden,
                           GCI_treeinfo *gci_info )
{
   GCI_treeinfo *ti = gci_info;

   (hidden = hidden);

   if ( ti != NULL )
   {
      if ( ti->nodes != NULL )
         GCI_free( hidden, ti->nodes );
      GCI_free( hidden, ti );
   }
}

/*
 * _GciDispatcher is the entry point of all GCI registered functions by the
 * user. We check the called name for an internally registered function and
 * return 1 if the function is no longer registered or hasn't been since ever.
 *
 * The function's arguments and return value depend on its usage from case
 * to case.
 */
APIRET APIENTRY _GciDispatcher( PCSZ calledname,
                                ULONG argc,
                                CONST PRXSTRING argv,
                                PCSZ queuename,
                                PRXSTRING returnstring )
{
   GCI_result rc = GCI_OK;
   GCI_str name, disposition, direct_retval;
   GCI_func *f = NULL;
   GCI_str args[10];
   ULONG i;
   int retval;
   char empty[1];
   GCI_strOfCharBuffer(empty);

   (queuename = queuename);

   /*
    * This trivial test should come first to be sure not to access nonexisting
    * memory.
    */
   if ( argc > 10 )
      return 1;

   if ( ( rc = GCI_stralloc( NULL, &name, strlen( calledname ) ) ) == GCI_OK )
   {
      GCI_strcats( &name, calledname );
      GCI_uppercase( NULL, &name );
      if ( ( f = internalLookup( &name ) ) == NULL )
         rc = GCI_FunctionNotFound;
      GCI_strfree( NULL, &name );
   }

   if ( rc != GCI_OK )
   {
      GCIcode2RxFuncCode( NULL, GCI_NoMemory, NULL );
      assignRxString( NULL, returnstring, &str_empty );

      return syntaxError( rc );
   }

   memset( args, 0, sizeof( args ) );
   for ( i = 0; i < argc; i++ )
      GCI_migrate( &args[i], &argv[i] );

   memset( &disposition, 0, sizeof( disposition ) );
   memset( &direct_retval, 0, sizeof( direct_retval ) );

   rc = GCI_execute( NULL,
                     f->func,
                     &f->treeinfo,
                     (int) argc,
                     args,
                     &disposition,
                     &direct_retval,
                     prefixChar );

   GCIcode2RxFuncCode( NULL, rc, &disposition );

   if ( rc == GCI_OK )
   {
      if ( GCI_ccontent( &direct_retval ) == NULL )
      {
         retval = assignRxString( NULL, returnstring, &str_empty );
      }
      else
      {
         retval = assignRxString( NULL, returnstring, &direct_retval );
         GCI_strfree( NULL, &direct_retval );
      }
      return retval;
   }

   retval = assignRxString( NULL, returnstring, &str_empty );
   GCI_strfree( NULL, &direct_retval ); /* not really needed hopefully */
   /*
    * In case of an error we have to distinct between called "as function"
    * or not.
    */
   if ( !f->treeinfo.callinfo.as_function )
      return retval || syntaxError( rc );

   return 1;
}


APIRET APIENTRY GciBitness(PCSZ *name, ULONG argc, CONST PRXSTRING argv, PCSZ queuename, PRXSTRING returnstring)
{
  if (argc != 0) return 1;
                                       /* format into the buffer            */
  sprintf(returnstring->strptr, "%d", GCI_BITNESS);
  returnstring->strlength = strlen(returnstring->strptr);

  return 0;
}
