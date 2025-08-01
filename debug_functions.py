#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
详细检查所有可用的函数和类
"""

import sys
import os

# 添加模块路径
sys.path.insert(0, os.path.join(os.getcwd(), "riglogic", "RigLogicLib", "Public"))
sys.path.insert(0, os.path.join(os.getcwd(), "x64", "Release"))

import py3dna

print("=== 所有可用的函数 ===")
all_functions = [f for f in dir(py3dna) if not f.startswith('_')]
for i, func in enumerate(all_functions):
    print(f"  {i+1:3d}. {func}")

print("\n=== 所有以_create结尾的函数 ===")
create_functions = [f for f in dir(py3dna) if f.endswith('_create')]
for i, func in enumerate(create_functions):
    print(f"  {i+1:2d}. {func}")

print("\n=== 所有以Reader结尾的类 ===")
reader_classes = [c for c in dir(py3dna) if c.endswith('Reader') and not c.startswith('_')]
for i, cls in enumerate(reader_classes):
    print(f"  {i+1:2d}. {cls}")

print("\n=== 所有以Stream结尾的类 ===")
stream_classes = [c for c in dir(py3dna) if c.endswith('Stream') and not c.startswith('_')]
for i, cls in enumerate(stream_classes):
    print(f"  {i+1:2d}. {cls}")

print("\n=== BinaryStreamReader类的方法 ===")
if hasattr(py3dna, 'BinaryStreamReader'):
    reader_methods = [m for m in dir(py3dna.BinaryStreamReader) if not m.startswith('_')]
    for i, method in enumerate(reader_methods):
        print(f"  {i+1:2d}. {method}")
else:
    print("  BinaryStreamReader类不存在") 