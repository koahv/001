/* vim: tabstop=2 shiftwidth=2 expandtab textwidth=80 linebreak wrap
 *
 * Copyright 2012 Matthew McCormick
 * Copyright 2013 Justin Crawford <Justasic@gmail.com>
 * Copyright 2015 Pawel 'l0ner' Soltys
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Based on: github.com/freebsd/freebsd/blob/master/usr.bin/top/machine.c
// Based on: Apple.cpp for load_string/mem_string and apple's documentation

#error ToDo: OpenBSD. This file is incomplete and likely will not compile if you remove this error (it is here to tell you it's unfinished)

#include <sstream>
#include <string>
#include <sys/types.h>

#include "getsysctl.h"
#include "memory.h"
#include "luts.h"
#include "conversions.h"

std::string mem_string( bool use_colors = false )
{
  // These values are in bytes
  int64_t total_mem = 0;
  int64_t used_mem = 0;
  int64_t unused_mem = 0;
  int32_t inactive_mem = 0;
  int32_t active_mem = 0;
  int32_t free_mem = 0;
  int32_t wired_mem = 0;
  int32_t page_size = 0;
  int32_t cache_mem = 0;
  std::ostringstream oss;

  // Get total physical memory, page size, and some other needed info
  GETSYSCTL( "hw.realmem", total_mem );
  GETSYSCTL( "hw.pagesize", page_size );

  GETSYSCTL( "vm.stats.vm.v_free_count", free_mem );
  GETSYSCTL( "vm.stats.vm.v_inactive_count", inactive_mem );
  GETSYSCTL( "vm.stats.vm.v_cache_count", cache_mem );
  GETSYSCTL( "vm.stats.vm.v_wire_count", wired_mem );

  // Get all memory which can be allocated
  //unused_mem = (inactive_mem + cache_mem + free_mem) * page_size;
  used_mem = (
      static_cast<int64_t>( active_mem ) + static_cast<int64_t>( wired_mem ) + 
      static_cast<int64_t>( inactive_mem ) ) * static_cast<int64_t>( page_size );

  if( use_colors )
  {
    oss << mem_lut[( 100 * used_mem ) / total_mem];
  }

  oss << convert_unit( used_mem, MEGABYTES ) << '/' 
    << convert_unit( total_mem, MEGABYTES ) << "MB";

  if( use_colors )
  {
    oss << "#[fg=default,bg=default]";
  }

  return oss.str();
}

