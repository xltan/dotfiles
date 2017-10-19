# -*- coding: utf-8 -*-
flags = ['-Wall',
        '-Wextra',
        '-Werror',
        '-Wno-long-long',
        '-Wno-variadic-macros',
        '-fexceptions',
        '-DNDEBUG',
        '-std=c++14',
        '-xc++',
        '-isystem/usr/include/']

SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c']

def FlagsForFile( filename, **kwargs ):
    return {'flags': flags, 'do_cache': True}
