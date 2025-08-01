#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
检查可用的工厂函数
"""

import sys
import os

# 添加模块路径
sys.path.insert(0, os.path.join(os.getcwd(), "riglogic", "RigLogicLib", "Public"))
sys.path.insert(0, os.path.join(os.getcwd(), "x64", "Release"))

import py3dna

print("检查可用的工厂函数:")
functions = [f for f in dir(py3dna) if f.endswith('_create')]
for i, func in enumerate(functions):
    print(f"  {i+1:2d}. {func}")

print("\n检查BinaryStreamReader相关函数:")
reader_functions = [f for f in dir(py3dna) if 'BinaryStreamReader' in f]
for i, func in enumerate(reader_functions):
    print(f"  {i+1:2d}. {func}")

print("\n检查FileStream相关函数:")
stream_functions = [f for f in dir(py3dna) if 'FileStream' in f]
for i, func in enumerate(stream_functions):
    print(f"  {i+1:2d}. {func}") 