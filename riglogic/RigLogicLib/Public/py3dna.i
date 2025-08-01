%module py3dna

#define DNA_BUILD_WITH_JSON_SUPPORT

// 添加编译选项以避免C++20兼容性问题
%{
#define _HAS_CXX20 0
#define _HAS_CXX23 0
#define _SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING
#define _SILENCE_CXX20_CISO646_REMOVED_WARNING
#define _SILENCE_CXX20_U8PATH_DEPRECATION_WARNING
%}
%{
#include <pma/Defs.h>
#include <pma/MemoryResource.h>
#include <pma/resources/AlignedMemoryResource.h>
#include <pma/resources/ArenaMemoryResource.h>
#include <pma/resources/DefaultMemoryResource.h>
#include <status/Defs.h>
#include <status/StatusCode.h>
#include <status/Status.h>
#include <trio/Defs.h>
#include <trio/Concepts.h>
#include <trio/Stream.h>
#include <trio/types/Aliases.h>
#include <trio/types/Parameters.h>
#include <trio/streams/FileStream.h>
#include <trio/streams/MemoryMappedFileStream.h>
#include <trio/streams/MemoryStream.h>

#include "dna/Defs.h"
#include "dna/DataLayer.h"
#include "arrayview/ArrayView.h"
#include "arrayview/StringView.h"
#include "dna/types/Aliases.h"
#include "dna/layers/Descriptor.h"
#include "dna/layers/Geometry.h"

#include "dna/layers/DescriptorReader.h"
#include "dna/layers/DefinitionReader.h"
#include "dna/layers/BehaviorReader.h"
#include "dna/layers/GeometryReader.h"
#include "dna/Reader.h"
#include "dna/StreamReader.h"
#include "dna/BinaryStreamReader.h"
#include "dna/JSONStreamReader.h"

#include "dna/layers/DescriptorWriter.h"
#include "dna/layers/DefinitionWriter.h"
#include "dna/layers/BehaviorWriter.h"
#include "dna/layers/GeometryWriter.h"
#include "dna/Writer.h"
#include "dna/StreamWriter.h"
#include "dna/BinaryStreamWriter.h"
#include "dna/JSONStreamWriter.h"

// 声明基类 - 暂时注释掉有问题的头文件
// %include "dna/layers/HeaderReader.h"
// %include "dna/layers/HeaderWriter.h"
// %include "dna/layers/RBFBehaviorReader.h"
// %include "dna/layers/RBFBehaviorWriter.h"
// %include "dna/layers/MachineLearnedBehaviorReader.h"
// %include "dna/layers/MachineLearnedBehaviorWriter.h"
// %include "dna/layers/JointBehaviorMetadataReader.h"
// %include "dna/layers/JointBehaviorMetadataWriter.h"
// %include "dna/layers/TwistSwingBehaviorReader.h"
// %include "dna/layers/TwistSwingBehaviorWriter.h"
// %include "dna/layers/BehaviorReader.h"
// %include "dna/layers/BehaviorWriter.h"

%}

%include <spyus/ExceptionHandling.i>

%include "stdint.i"
%include <spyus/Caster.i>

%ignore sc::operator==;
%ignore sc::operator!=;

%include <pma/Defs.h>
%include <pma/MemoryResource.h>
%include <pma/resources/AlignedMemoryResource.h>
%include <pma/resources/ArenaMemoryResource.h>
%include <pma/resources/DefaultMemoryResource.h>
%include <status/Defs.h>
%include <status/StatusCode.h>
%include <status/Status.h>
%include <trio/Defs.h>
%include <trio/Concepts.h>
%include <trio/Stream.h>
%include <trio/types/Aliases.h>
%include <trio/types/Parameters.h>
%include <trio/streams/FileStream.h>
%include <trio/streams/MemoryMappedFileStream.h>
%include <trio/streams/MemoryStream.h>
// 使用pythonize指令来生成工厂函数
pythonize_unmanaged_type(FileStream, create, destroy)
pythonize_unmanaged_type(MemoryMappedFileStream, create, destroy)
pythonize_unmanaged_type(MemoryStream, create, destroy)

%pythoncode %{
FileStream.AccessMode_Read = AccessMode_Read
FileStream.AccessMode_Write = AccessMode_Write
FileStream.AccessMode_ReadWrite = AccessMode_ReadWrite

FileStream.OpenMode_Binary = OpenMode_Binary
FileStream.OpenMode_Text = OpenMode_Text

MemoryMappedFileStream.AccessMode_Read = AccessMode_Read
MemoryMappedFileStream.AccessMode_Write = AccessMode_Write
MemoryMappedFileStream.AccessMode_ReadWrite = AccessMode_ReadWrite
%}

%include <spyus/ArrayView.i>
%include <spyus/Vector3.i>

%include "Geometry.i"

// 解决StringView中Base::ArrayView的警告
%typemap(ctype) av::StringView "const char*"
%typemap(in) av::StringView {
    if (PyUnicode_Check($input)) {
        $1 = PyUnicode_AsUTF8($input);
    } else {
        PyErr_SetString(PyExc_TypeError, "Expected a string");
        SWIG_fail;
    }
}
%typemap(out) av::StringView {
    $result = PyUnicode_FromString($1.c_str());
}
%typemap(varin) av::StringView {
    if (PyUnicode_Check($input)) {
        $1 = PyUnicode_AsUTF8($input);
    } else {
        PyErr_SetString(PyExc_TypeError, "Expected a string");
        SWIG_fail;
    }
}
%typemap(varout) av::StringView {
    $result = PyUnicode_FromString($1.c_str());
}

array_view_to_py_list(trust::ArrayView);
%apply trust::ArrayView {
    trust::ConstArrayView,
    dna::ArrayView,
    dna::ConstArrayView
};

string_view_to_py_string(trust::StringView);
%apply trust::StringView {
    dna::StringView
};

vector3_typemap(dna::Vector3);
texture_coordinate_typemap(dna::TextureCoordinate);
vertex_layout_typemap(dna::VertexLayout);

py_list_to_c_array(const std::uint16_t* jointIndices, std::uint16_t count);
%apply (const std::uint16_t* jointIndices, std::uint16_t count) {
    (const std::uint16_t* animatedMapIndices, std::uint16_t count),
    (const std::uint16_t* meshIndices, std::uint16_t count),
    (const std::uint16_t* rowIndices, std::uint16_t count),
    (const std::uint16_t* columnIndices, std::uint16_t count),
    (const std::uint16_t* outputIndices, std::uint16_t count),
    (const std::uint16_t* inputIndices, std::uint16_t count),
    (const std::uint16_t* lods, std::uint16_t count),
    (const std::uint16_t* blendShapeChannelIndices, std::uint16_t count),
    (const std::uint32_t* vertexIndices, std::uint32_t count),
    (const std::uint32_t* layoutIndices, std::uint32_t count)
};

py_list_to_c_array(const float* fromValues, std::uint16_t count);
%apply (const float* fromValues, std::uint16_t count) {
    (const float* toValues, std::uint16_t count),
    (const float* slopeValues, std::uint16_t count),
    (const float* cutValues, std::uint16_t count),
    (const float* weights, std::uint16_t count)
};

py_list_to_c_array(const float* values, std::uint32_t count);

py_list_to_c_array(const dna::VertexLayout* layouts, std::uint32_t count);

py_list_to_c_array(const dna::TextureCoordinate* textureCoordinates, std::uint32_t count);

py_list_to_c_array(const dna::Normal* normals, std::uint32_t count);
%apply (const dna::Normal* normals, std::uint32_t count) {
    (const dna::Vector3* translations, std::uint16_t count),
    (const dna::Vector3* rotations, std::uint16_t count),
    (const dna::Position* positions, std::uint32_t count),
    (const dna::Delta* deltas, std::uint32_t count)
};

%include "dna/Defs.h"  
%include "arrayview/ArrayView.h"
%include "arrayview/StringView.h" 
%include "dna/types/Aliases.h" 
%include "dna/types/Vector3.h"
%include "dna/DataLayer.h"
%include "dna/layers/Descriptor.h"
%include "dna/layers/Geometry.h"
%include "dna/layers/DescriptorReader.h"
%include "dna/layers/DefinitionReader.h"
%include "dna/layers/BehaviorReader.h"
%include "dna/layers/GeometryReader.h"
%include "dna/Reader.h"
// 暂时注释掉有问题的扩展方法
// %extend dna::Reader {
//     void loadFromDNA(const char* dnaPath) {
//         auto stream = trio::FileStream::create(dnaPath, trio::Stream::OpenMode_Binary);
//         auto reader = dna::BinaryStreamReader::create(stream);
//         $self->setFrom(reader);
//         dna::BinaryStreamReader::destroy(reader);
//     }
// };
%include "dna/StreamReader.h"
%include "dna/BinaryStreamReader.h"
%include "dna/JSONStreamReader.h"
%extend dna::JSONStreamReader {
    JSONStreamReader(trio::MemoryStream* stream) {
        return new dna::JSONStreamReader(stream);
    }
};
pythonize_unmanaged_type(JSONStreamReader, create, destroy)
%include "dna/layers/DescriptorWriter.h"
%include "dna/layers/DefinitionWriter.h"
%include "dna/layers/BehaviorWriter.h"
%include "dna/layers/GeometryWriter.h"
%include "dna/Writer.h"
// 暂时注释掉有问题的扩展方法
// %extend dna::Writer {
//     void writeToJSON(const char* jsonPath) {
//         auto stream = trio::FileStream::create(jsonPath, trio::Stream::OpenMode_Write);
//         dna::JSONStreamWriter writer;
//         $self->setTo(&writer);
//         writer.writeTo(stream);
//     }
// };
%include "dna/StreamWriter.h"
%include "dna/BinaryStreamWriter.h"
%include "dna/JSONStreamWriter.h"
%extend dna::JSONStreamWriter {
    JSONStreamWriter(trio::MemoryStream* stream) {
        return new dna::JSONStreamWriter(stream);
    }
};
// %template(JSONStreamWriter) pma::CreateInterface<dna::JSONStreamWriter>;
pythonize_unmanaged_type(JSONStreamWriter, create, destroy)

// 声明基类的虚函数
%feature("director") Writer;
%feature("director") StreamWriter;
%feature("director") JSONStreamWriter;

// 声明纯虚函数的实现
%feature("abstract") Writer;
%feature("abstract") StreamWriter;
%feature("abstract") JSONStreamWriter;


// 声明模板类
%include "std_string.i"
%include "std_vector.i"
%template(StringVector) std::vector<std::string>;

// 声明 DefaultInstanceCreator 和 DefaultInstanceDestroyer 模板 - 暂时注释掉
// %{
// namespace pma {
// template<typename T>
// struct DefaultInstanceCreator {
//     using type = void;
// };
// 
// template<typename T>
// struct DefaultInstanceDestroyer {
//     using type = void;
// };
// }
// %}









