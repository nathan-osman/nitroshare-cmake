# The MIT License (MIT)
#
# Copyright (c) 2015 Nathan Osman
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Split a version (in the form "x.y.z") into its three components
# The results will be in variables named:
# - <_prefix>_MAJOR
# - <_prefix>_MINOR
# - <_prefix>_PATCH
function(SPLIT_VERSION _prefix _version)
    string(REPLACE "." ";" v ${_version})
    list(GET v 0 v_major)
    list(GET v 1 v_minor)
    list(GET v 2 v_patch)
    set(${_prefix}_MAJOR ${v_major} PARENT_SCOPE)
    set(${_prefix}_MINOR ${v_minor} PARENT_SCOPE)
    set(${_prefix}_PATCH ${v_patch} PARENT_SCOPE)
endfunction()
