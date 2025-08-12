#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
测试py3dna模块读取template.dna文件并序列化为JSON
"""

import sys
import os

# 添加模块路径
sys.path.insert(0, os.path.join(os.getcwd(), "riglogic", "RigLogicLib", "Public"))
sys.path.insert(0, os.path.join(os.getcwd(), "x64", "Release"))

try:
    import py3dna
    print("✅ py3dna模块导入成功！")
    
    print("\n📖 测试读取 template.dna 文件并序列化为JSON:")
    try:
        print("step 1: 准备创建文件流...")
        # 使用构造函数创建FileStream
        stream = py3dna.FileStream(
            "Ada.dna",
            py3dna.FileStream.AccessMode_Read,
            py3dna.FileStream.OpenMode_Binary
        )
        print("step 2: FileStream_create 成功！stream=", stream)

        print("step 3: 准备创建BinaryStreamReader...")
        # 使用构造函数创建BinaryStreamReader
        reader = py3dna.BinaryStreamReader(stream)
        print("step 4: BinaryStreamReader构造函数 成功！reader=", reader)

        print("step 5: 读取DNA基本信息...")
        # 首先调用read方法读取DNA数据
        print("  调用reader.read()读取DNA数据...")
        reader.read()
        print("  ✅ reader.read()成功")
        
        if hasattr(reader, "getLODCount"):
            lod_count = reader.getLODCount()
            print(f"  LOD数量: {lod_count}")
        
        if hasattr(reader, "getName"):
            name = reader.getName()
            print(f"  DNA名称: {name}")
        
        if hasattr(reader, "getArchetype"):
            archetype = reader.getArchetype()
            print(f"  原型: {archetype}")
        
        if hasattr(reader, "getGender"):
            gender = reader.getGender()
            print(f"  性别: {gender}")
            
        if hasattr(reader, "getAge"):
            age = reader.getAge()
            print(f"  年龄: {age}")
            
        if hasattr(reader, "getJointCount"):
            joint_count = reader.getJointCount()
            print(f"  关节数量: {joint_count}")
            
        if hasattr(reader, "getBlendShapeChannelCount"):
            blend_shape_count = reader.getBlendShapeChannelCount()
            print(f"  混合形状通道数量: {blend_shape_count}")
            
        if hasattr(reader, "getMeshCount"):
            mesh_count = reader.getMeshCount()
            print(f"  网格数量: {mesh_count}")

        print("step 6: 准备创建JSON输出流...")
        # 创建JSON输出文件流
        json_stream = py3dna.FileStream(
            "Ada.json",
            py3dna.FileStream.AccessMode_Write,
            py3dna.FileStream.OpenMode_Text
        )
        print("step 7: JSON输出流创建成功！")

        print("step 8: 准备创建JSONStreamWriter...")
        # 创建JSONStreamWriter
        json_writer = py3dna.JSONStreamWriter(json_stream)
        print("step 9: JSONStreamWriter构造函数 成功！")

        print("step 10: 将DNA数据写入JSON...")
        # 将reader的数据写入json_writer
        json_writer.setFrom(reader)
        print("step 11: setFrom成功！")

        print("step 12: 写入JSON文件...")
        # 写入JSON文件
        json_writer.write()
        print("step 13: JSON文件写入成功！")

        print("step 14: 释放所有资源...")
        # 释放资源（使用Python的自动垃圾回收）
        # 不需要手动调用destroy，Python会自动管理
        print("step 15: 所有资源释放成功！")
        
        print("✅ DNA读取和JSON序列化完成！输出文件: template_output.json")

    except Exception as e:
        print(f"❌ 读取失败: {e}")
        import traceback
        traceback.print_exc()
    
except ImportError as e:
    print(f"❌ 导入失败: {e}")
    sys.exit(1)
except Exception as e:
    print(f"❌ 测试失败: {e}")
    sys.exit(1)