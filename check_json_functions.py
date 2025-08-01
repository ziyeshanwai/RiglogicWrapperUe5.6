#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
检查JSON相关的函数和类
"""

import sys
import os

# 添加模块路径
sys.path.insert(0, os.path.join(os.getcwd(), "riglogic", "RigLogicLib", "Public"))
sys.path.insert(0, os.path.join(os.getcwd(), "x64", "Release"))

import py3dna

print("=== JSON相关的函数 ===")
json_functions = [f for f in dir(py3dna) if 'JSON' in f]
for i, func in enumerate(json_functions):
    print(f"  {i+1:2d}. {func}")

print("\n=== JSON相关的类 ===")
json_classes = [c for c in dir(py3dna) if 'JSON' in c and not c.startswith('_')]
for i, cls in enumerate(json_classes):
    print(f"  {i+1:2d}. {cls}")

print("\n=== Writer相关的类 ===")
writer_classes = [c for c in dir(py3dna) if c.endswith('Writer') and not c.startswith('_')]
for i, cls in enumerate(writer_classes):
    print(f"  {i+1:2d}. {cls}")

print("\n=== JSONStreamWriter类的方法 ===")
if hasattr(py3dna, 'JSONStreamWriter'):
    writer_methods = [m for m in dir(py3dna.JSONStreamWriter) if not m.startswith('_')]
    for i, method in enumerate(writer_methods):
        print(f"  {i+1:2d}. {method}")
else:
    print("  JSONStreamWriter类不存在")

print("\n=== Writer类的方法 ===")
if hasattr(py3dna, 'Writer'):
    writer_methods = [m for m in dir(py3dna.Writer) if not m.startswith('_')]
    for i, method in enumerate(writer_methods):
        print(f"  {i+1:2d}. {method}")
else:
    print("  Writer类不存在") 