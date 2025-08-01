#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
检查JSONStreamWriter的正确使用方式
"""

import sys
import os

# 添加模块路径
sys.path.insert(0, os.path.join(os.getcwd(), "riglogic", "RigLogicLib", "Public"))
sys.path.insert(0, os.path.join(os.getcwd(), "x64", "Release"))

import py3dna

print("=== JSONStreamWriter类的方法 ===")
if hasattr(py3dna, 'JSONStreamWriter'):
    writer_methods = [m for m in dir(py3dna.JSONStreamWriter) if not m.startswith('_')]
    for i, method in enumerate(writer_methods):
        print(f"  {i+1:2d}. {method}")
else:
    print("  JSONStreamWriter类不存在")

print("\n=== 检查JSONStreamWriter_create函数 ===")
if hasattr(py3dna, 'JSONStreamWriter_create'):
    print("  ✅ JSONStreamWriter_create函数存在")
else:
    print("  ❌ JSONStreamWriter_create函数不存在")

print("\n=== 检查JSONStreamWriter_destroy函数 ===")
if hasattr(py3dna, 'JSONStreamWriter_destroy'):
    print("  ✅ JSONStreamWriter_destroy函数存在")
else:
    print("  ❌ JSONStreamWriter_destroy函数不存在")

print("\n=== 检查JSONStreamWriter.create方法 ===")
if hasattr(py3dna.JSONStreamWriter, 'create'):
    print("  ✅ JSONStreamWriter.create方法存在")
else:
    print("  ❌ JSONStreamWriter.create方法不存在")

print("\n=== 检查JSONStreamWriter.destroy方法 ===")
if hasattr(py3dna.JSONStreamWriter, 'destroy'):
    print("  ✅ JSONStreamWriter.destroy方法存在")
else:
    print("  ❌ JSONStreamWriter.destroy方法不存在") 