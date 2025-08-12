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

// 工厂函数定义 - 使用pma中的默认创建器和销毁器
#include <pma/ScopedPtr.h>

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
#include "dna/layers/HeaderReader.h"
#include "dna/layers/HeaderWriter.h"
#include "dna/layers/RBFBehavior.h"
#include "dna/layers/RBFBehaviorReader.h"
#include "dna/layers/RBFBehaviorWriter.h"
#include "dna/layers/MachineLearnedBehavior.h"
#include "dna/layers/MachineLearnedBehaviorReader.h"
#include "dna/layers/MachineLearnedBehaviorWriter.h"
#include "dna/layers/JointBehaviorMetadata.h"
#include "dna/layers/JointBehaviorMetadataReader.h"
#include "dna/layers/JointBehaviorMetadataWriter.h"
#include "dna/layers/Twist.h"
#include "dna/layers/TwistSwingBehaviorReader.h"
#include "dna/layers/TwistSwingBehaviorWriter.h"

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



%pythoncode %{
try:
    FileStream.AccessMode_Read = AccessMode_Read
    FileStream.AccessMode_Write = AccessMode_Write
    FileStream.AccessMode_ReadWrite = AccessMode_ReadWrite

    FileStream.OpenMode_Binary = OpenMode_Binary
    FileStream.OpenMode_Text = OpenMode_Text

    MemoryMappedFileStream.AccessMode_Read = AccessMode_Read
    MemoryMappedFileStream.AccessMode_Write = AccessMode_Write
    MemoryMappedFileStream.AccessMode_ReadWrite = AccessMode_ReadWrite
except:
    # Fallback for compatibility
    FileStream.AccessMode_Read = 0
    FileStream.AccessMode_Write = 1
    FileStream.AccessMode_ReadWrite = 2

    FileStream.OpenMode_Binary = 0
    FileStream.OpenMode_Text = 1

    MemoryMappedFileStream.AccessMode_Read = 0
    MemoryMappedFileStream.AccessMode_Write = 1
    MemoryMappedFileStream.AccessMode_ReadWrite = 2
%}

%include <spyus/ArrayView.i>
%include <spyus/Vector3.i>

%include "Geometry.i"


array_view_to_py_list(trust::ArrayView);
%apply trust::ArrayView {
    trust::ConstArrayView,
    dna::ArrayView,
    dna::ConstArrayView
};

%apply trust::ArrayView {
    av::ConstArrayView<float>,
    av::ConstArrayView<std::uint16_t>,
    av::ConstArrayView<std::uint32_t>
};

string_view_to_py_string(trust::StringView);
%apply trust::StringView {
    dna::StringView,
    av::StringView
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





// 声明基类的虚函数
%feature("director") Writer;
%feature("director") StreamWriter;
%feature("director") JSONStreamWriter;

// 声明纯虚函数的实现
%feature("abstract") Writer;
%feature("abstract") StreamWriter;
%feature("abstract") JSONStreamWriter;

%include "std_string.i"
%include "std_vector.i"
%template(StringVector) std::vector<std::string>;

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
%include "dna/layers/RBFBehaviorReader.h"
%include "dna/layers/MachineLearnedBehaviorReader.h"
%include "dna/layers/JointBehaviorMetadataReader.h"
%include "dna/layers/TwistSwingBehaviorReader.h"
%include "dna/Reader.h"
%include "dna/layers/HeaderReader.h"
%include "dna/layers/HeaderWriter.h"
// 使用typedef来处理枚举类型
%{
typedef dna::RBFSolverType RBFSolverType;
typedef dna::AutomaticRadius AutomaticRadius;
typedef dna::RBFDistanceMethod RBFDistanceMethod;
typedef dna::RBFNormalizeMethod RBFNormalizeMethod;
typedef dna::RBFFunctionType RBFFunctionType;
typedef dna::TwistAxis TwistAxis;
typedef dna::ActivationFunction ActivationFunction;
typedef dna::TranslationRepresentation TranslationRepresentation;
typedef dna::RotationRepresentation RotationRepresentation;
typedef dna::ScaleRepresentation ScaleRepresentation;
%}




%include "dna/layers/RBFBehavior.h"
%include "dna/layers/RBFBehaviorReader.h"
%include "dna/layers/RBFBehaviorWriter.h"
%include "dna/layers/MachineLearnedBehavior.h"
%include "dna/layers/MachineLearnedBehaviorReader.h"
%include "dna/layers/MachineLearnedBehaviorWriter.h"
%include "dna/layers/JointBehaviorMetadata.h"
%include "dna/layers/JointBehaviorMetadataReader.h"
%include "dna/layers/JointBehaviorMetadataWriter.h"
%include "dna/layers/Twist.h"
%include "dna/layers/TwistSwingBehaviorReader.h"
%include "dna/layers/TwistSwingBehaviorWriter.h"

%include "dna/StreamReader.h"
%include "dna/BinaryStreamReader.h"
%include "dna/JSONStreamReader.h"

%include "dna/layers/DescriptorWriter.h"
%include "dna/layers/DefinitionWriter.h"
%include "dna/layers/BehaviorWriter.h"
%include "dna/layers/GeometryWriter.h"
%include "dna/Writer.h"

%include "dna/StreamWriter.h"
%include "dna/BinaryStreamWriter.h"
%include "dna/JSONStreamWriter.h"

pythonize_unmanaged_type(JSONStreamReader, create, destroy)
pythonize_unmanaged_type(JSONStreamWriter, create, destroy)
pythonize_unmanaged_type(FileStream, create, destroy)
pythonize_unmanaged_type(MemoryMappedFileStream, create, destroy)
pythonize_unmanaged_type(BinaryStreamReader, create, destroy)
pythonize_unmanaged_type(BinaryStreamWriter, create, destroy)