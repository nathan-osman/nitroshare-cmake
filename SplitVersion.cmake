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
#
#   SPLIT_VERSION(prefix version)
#
# The resulting values will be in variables named:
# - ${_prefix}_MAJOR
# - ${_prefix}_MINOR
# - ${_prefix}_PATCH
function(SPLIT_VERSION _prefix _version)

    # Replace each "." with ";" so that it can be interpreted as a list
    string(REPLACE "." ";" v ${_version})

    # Obtain the components
    list(GET v 0 vMajor)
    list(GET v 1 vMinor)
    list(GET v 2 vPatch)

    # Set the values in the parent scope
    set(${_prefix}_MAJOR ${vMajor} PARENT_SCOPE)
    set(${_prefix}_MINOR ${vMinor} PARENT_SCOPE)
    set(${_prefix}_PATCH ${vPatch} PARENT_SCOPE)
endfunction()
