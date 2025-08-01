#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
编译Python扩展模块
"""

import os
import sys
import subprocess
from setuptools import setup, Extension

def compile_extension():
    """编译Python扩展模块"""
    
    current_dir = os.getcwd()
    swig_dir = os.path.join(current_dir, "riglogic", "RigLogicLib", "Public")
    
    # 检查SWIG生成的文件
    wrap_file = os.path.join(swig_dir, "py3dna_wrap.cxx")
    py_file = os.path.join(swig_dir, "py3dna.py")
    
    if not os.path.exists(wrap_file):
        print(f"❌ 错误: 找不到SWIG包装文件 {wrap_file}")
        print("请先运行: swig -python -c++ -o py3dna_wrap.cxx py3dna.i")
        return False
    
    if not os.path.exists(py_file):
        print(f"❌ 错误: 找不到Python模块文件 {py_file}")
        print("请先运行: swig -python -c++ -o py3dna_wrap.cxx py3dna.i")
        return False
    
    print(f"✅ 找到SWIG生成的文件:")
    print(f"  - {wrap_file}")
    print(f"  - {py_file}")
    
    # 定义扩展模块
    py3dna_module = Extension(
        '_py3dna',
        sources=[wrap_file],
        include_dirs=[
            os.path.join(current_dir, "riglogic", "RigLogicLib", "Public"),
            os.path.join(current_dir, "riglogic", "RigLogicLib", "Public", "spyus"),
            os.path.join(current_dir, "riglogic", "RigLogicLib", "Private"),
            os.path.join(current_dir, "ThirdLib", "AutoDeskFBXSDK2020.3.2", "include"),
            "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.22621.0\\ucrt",
            "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.22621.0\\um",
            "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.22621.0\\shared",
            "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.22621.0\\winrt",
        ],
        library_dirs=[
            os.path.join(current_dir, "riglogic", "x64", "Release"),
            os.path.join(current_dir, "ThirdLib", "AutoDeskFBXSDK2020.3.2", "lib", "vs2019", "x64", "release"),
        ],
        libraries=[
            "riglogic",
            "libfbxsdk",
            "libxml2",
            "zlib",
        ],
        define_macros=[
            ("DNA_BUILD_WITH_JSON_SUPPORT", None),
            ("_HAS_CXX20", "0"),
            ("_HAS_CXX23", "0"),
            ("_SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING", None),
            ("_SILENCE_CXX20_CISO646_REMOVED_WARNING", None),
            ("_SILENCE_CXX20_U8PATH_DEPRECATION_WARNING", None),
        ],
        extra_compile_args=[
            "/std:c++17",
            "/EHsc",
            "/DWIN32",
            "/D_WINDOWS",
            "/D_USRDLL",
            "/D_WINDLL",
        ],
        extra_link_args=[
            "/MACHINE:X64",
        ],
    )
    
    # 设置编译选项
    setup(
        name="py3dna",
        version="1.0.0",
        description="Python bindings for DNA/RigLogic",
        ext_modules=[py3dna_module],
        py_modules=["py3dna"],
        package_dir={"": swig_dir},
    )

if __name__ == "__main__":
    print("🔨 开始编译Python扩展模块...")
    try:
        compile_extension()
        print("✅ 编译完成！")
    except Exception as e:
        print(f"❌ 编译失败: {e}")
        sys.exit(1) 