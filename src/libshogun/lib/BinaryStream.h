/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Written (W) 2009 Soeren Sonnenburg
 * Copyright (C) 2009 Fraunhofer Institute FIRST and Max-Planck-Society
 */

#ifndef __BINARYSTREAM_H__
#define __BINARYSTREAM_H__

#include "lib/io.h"
#include "base/SGObject.h"

#include <stdio.h>
#include <string.h>

/** @brief memory mapped emulation via binary streams (files)
*
* Implements memory mapped file emulation (\sa CMemoryMappedFile) via standard
* file operations like fseek, fread etc
*/
template <class T> class CBinaryStream : public CSGObject
{
	public:
		/** default constructor
		 */
		CBinaryStream() : CSGObject()
		{
            rw=NULL;
            m_fname=NULL;
			fd = NULL:
			length = 0;
		}

		/** constructor
		 *
		 * open a file for read mode
		 *
		 * @param fname name of file, zero terminated string
		 * @param flag determines read or read write mode (currently only 'r' is supported)
		 */
		CBinaryStream(const char* fname, const char* flag="r")
		: CSGObject()
		{
			open_stream(bs.m_fname, bs.rw);
		}


		/* copy constructor
		 *
		 * @param bs binary stream to copy from
		 */
        CBinaryStream(const CBinaryStream &bs)
        {
			open_stream(bs.m_fname, bs.rw);
            ASSERT(length==bs.length);
        }


		/** destructor */
		virtual ~CBinaryStream()
		{
			close_stream();
		}

		void open_stream(const char* fname, const char* flag="r")
		{
            rw=strdup(flag);
            m_fname=strdup(fname);

			fd = fopen(fname, flag);
			if (!fd)
                SG_ERROR("Error opening file '%s'\n", m_fname);

			struct stat sb;
			if (stat(fname, &sb) == -1)
                SG_ERROR("Error determining file size of '%s'\n", m_fname);

			length = sb.st_size;
			SG_DEBUG("Opened file '%s' of size %ld byte\n", fname, length);
		}

		void close_stream()
		{
			free(rw);
            free(m_fname);
			if (fd)
				fclose(fd);

            rw=NULL;
            m_fname=NULL;
			fd = NULL:
			length = 0;
		}

		/** get the number of objects of type T cointained in the file 
		 *
		 * @return length of file
		 */
		uint64_t get_length()
		{
			return length/sizeof(T);
		}

		/** get the size of the file in bytes
		 *
		 * @return size of file in bytes
		 */
		uint64_t get_size()
		{
			return length;
		}

		/** get next line from file
		 *
		 * The returned line may be modfied in case the file was opened
		 * read/write. It is otherwise read-only.
		 *
		 * @param len length of line (returned via reference)
		 * @param offs offset to be passed for reading next line, should be 0
		 * 			initially (returned via reference)
		 *
		 * @return line (NOT ZERO TERMINATED)
		 */
		char* get_line(uint64_t& len, uint64_t& offs)
		{
			return NULL;
		}

		/** count the number of lines in a file
		 *
		 * @return number of lines
		 */
		int32_t get_num_lines()
		{
			return 0;
		}

		/** read num elements starting from index into buffer
		 *
		 * @param buffer buffer that has to be at least num elements long
		 * @param index index into file starting from which elements are read
		 * @param num number of elements to be read
		 */
		void pre_buffer(T* buffer, long index, long num) const
		{           
			ASSERT(index>=0);
			ASSERT(num>=0);

			if (num==0)
				return;

			if (fseek(fd, ((long) sizeof(T))*((long) index), SEEK_SET) != 0)
				SG_ERROR(stderr, "Error seeking to %ld (file '%s')\n", sizeof(T)*((int64_t) index), m_fname);

			if ( fread(buffer, sizeof(T), num, fd) != num)
				SG_ERROR(stderr, "Error calling fread (file '%s')\n", m_fname);
		}


		/** operator overload for file read only access
		 *
		 * @param index index
		 * @return element at index
		 */
		inline T operator[](int32_t index) const
		{

			if (fseek(fd, ((long) sizeof(T))*((long) index), SEEK_SET) != 0)
				SG_ERROR(stderr, "Error seeking to %ld (file '%s')\n", sizeof(T)*((int64_t) index), m_fname);

			T ptr;

			if ( fread(&ptr, sizeof(T), 1, fd) != 1)
				SG_ERROR(stderr, "Error calling fread (file '%s')\n", m_fname);

			return T;
		}

		/** @return object name */
		inline virtual const char* get_name() const { return "BinaryStream"; }

	protected:
		/** file descriptor */
		FILE* fd;
		/** size of file */
		uint64_t length;
		/** mode */
		char* rw;
        /* fname */
        char* m_fname;

};
#endif // BINARY_STREAM