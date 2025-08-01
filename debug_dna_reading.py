#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
详细调试DNA读取问题
"""

import sys
import os

# 添加模块路径
sys.path.insert(0, os.path.join(os.getcwd(), "riglogic", "RigLogicLib", "Public"))
sys.path.insert(0, os.path.join(os.getcwd(), "x64", "Release"))

import py3dna

print("🔍 详细调试DNA读取问题")
print("=" * 50)

try:
    print("step 1: 检查template.dna文件是否存在...")
    if os.path.exists("template.dna"):
        file_size = os.path.getsize("template.dna")
        print(f"  ✅ 文件存在，大小: {file_size} 字节")
    else:
        print("  ❌ 文件不存在！")
        sys.exit(1)

    print("\nstep 2: 创建文件流...")
    stream = py3dna.FileStream_create(
        "template.dna",
        py3dna.FileStream.AccessMode_Read,
        py3dna.FileStream.OpenMode_Binary
    )
    print("  ✅ 文件流创建成功")

    print("\nstep 3: 检查文件流状态...")
    if hasattr(stream, 'size'):
        stream_size = stream.size()
        print(f"  流大小: {stream_size}")
    else:
        print("  无法获取流大小")

    print("\nstep 4: 创建BinaryStreamReader...")
    reader = py3dna.BinaryStreamReader.create(stream)
    print("  ✅ BinaryStreamReader创建成功")

    print("\nstep 5: 尝试读取DNA数据...")
    # 尝试调用read方法
    if hasattr(reader, 'read'):
        print("  调用reader.read()...")
        try:
            reader.read()
            print("  ✅ reader.read()成功")
        except Exception as e:
            print(f"  ❌ reader.read()失败: {e}")

    print("\nstep 6: 详细检查DNA内容...")
    
    # 检查所有可用的getter方法
    getter_methods = [m for m in dir(reader) if m.startswith('get') and not m.startswith('_')]
    print(f"  找到 {len(getter_methods)} 个getter方法")
    
    # 测试一些关键的getter方法
    key_methods = [
        'getName', 'getArchetype', 'getGender', 'getAge', 'getLODCount',
        'getJointCount', 'getBlendShapeChannelCount', 'getMeshCount',
        'getGUIControlCount', 'getRawControlCount'
    ]
    
    for method_name in key_methods:
        if hasattr(reader, method_name):
            try:
                method = getattr(reader, method_name)
                if method_name in ['getLODCount', 'getJointCount', 'getBlendShapeChannelCount', 
                                 'getMeshCount', 'getGUIControlCount', 'getRawControlCount']:
                    # 这些方法可能需要参数
                    if method_name == 'getLODCount':
                        result = method()
                    else:
                        result = method(0)  # 尝试传入索引0
                else:
                    result = method()
                print(f"  {method_name}: {result}")
            except Exception as e:
                print(f"  {method_name}: 调用失败 - {e}")
        else:
            print(f"  {method_name}: 方法不存在")

    print("\nstep 7: 检查DNA文件格式...")
    # 尝试读取文件的前几个字节来检查格式
    try:
        stream.seek(0)
        if hasattr(stream, 'read'):
            # 读取前16个字节
            data = stream.read(16)
            print(f"  文件前16字节: {data}")
        else:
            print("  无法直接读取流数据")
    except Exception as e:
        print(f"  读取文件头失败: {e}")

    print("\nstep 8: 释放资源...")
    py3dna.BinaryStreamReader.destroy(reader)
    py3dna.FileStream_destroy(stream)
    print("  ✅ 资源释放成功")

except Exception as e:
    print(f"❌ 调试过程中出错: {e}")
    import traceback
    traceback.print_exc() 