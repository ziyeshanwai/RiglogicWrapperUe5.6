// Copyright Epic Games, Inc. All Rights Reserved.

#include "riglogic/riglogic/RigInstanceImpl.h"

#include "riglogic/TypeDefs.h"
#include "riglogic/animatedmaps/AnimatedMapsOutputInstance.h"
#include "riglogic/blendshapes/BlendShapesOutputInstance.h"
#include "riglogic/controls/ControlsInputInstance.h"
#include "riglogic/joints/JointsOutputInstance.h"
#include "riglogic/riglogic/RigLogicImpl.h"
#include "riglogic/riglogic/RigMetrics.h"
#include "riglogic/types/Aliases.h"
#include "riglogic/utils/Extd.h"

#ifdef _MSC_VER
    #pragma warning(push)
    #pragma warning(disable : 4365 4987)
#endif
#include <algorithm>
#include <cassert>
#include <cstdint>
#include <numeric>
#if defined(_MSC_VER) && !defined(__clang__) && (_MSC_VER < 1938) && (_MSC_VER >= 1900) && (__cplusplus >= 202002L)
    #include <span>
#endif
#ifdef _MSC_VER
    #pragma warning(pop)
#endif

namespace rl4 {

namespace {

inline std::uint16_t getMaxLODLevel(std::uint16_t lodCount) {
    return (lodCount > 0u ? static_cast<std::uint16_t>(lodCount - 1) : static_cast<std::uint16_t>(0));
}

}  // namespace

RigInstance* RigInstance::create(RigLogic* rigLogic, MemoryResource* memRes) {
    // NOLINTNEXTLINE(cppcoreguidelines-pro-type-static-cast-downcast)
    auto pRigLogic = static_cast<RigLogicImpl*>(rigLogic);
    PolyAllocator<RigInstanceImpl> alloc{memRes};
    return alloc.newObject(pRigLogic->getRigMetrics(), pRigLogic, memRes);
}

void RigInstance::destroy(RigInstance* instance) {
    // NOLINTNEXTLINE(cppcoreguidelines-pro-type-static-cast-downcast)
    auto ptr = static_cast<RigInstanceImpl*>(instance);
    PolyAllocator<RigInstanceImpl> alloc{ptr->getMemoryResource()};
    alloc.deleteObject(ptr);
}

RigInstance::~RigInstance() = default;

RigInstanceImpl::RigInstanceImpl(const RigMetrics& metrics, RigLogicImpl* rigLogic, MemoryResource* memRes_) :
    memRes{memRes_},
    lodMaxLevel{getMaxLODLevel(metrics.lodCount)},
    lodLevel{},
    guiControlCount{metrics.guiControlCount},
    rawControlCount{metrics.rawControlCount},
    psdControlCount{metrics.psdControlCount},
    mlControlCount{metrics.mlControlCount},
    rbfControlCount{metrics.rbfControlCount},
    neuralNetworkCount{metrics.neuralNetworkCount},
    controlsInstance{rigLogic->createControlsInstance(memRes)},
    machineLearnedBehaviorInstance{rigLogic->createMachineLearnedBehaviorInstance(memRes)},
    rbfBehaviorInstance{rigLogic->createRBFBehaviorInstance(memRes)},
    jointsInstance{rigLogic->createJointsInstance(memRes)},
    blendShapesInstance{rigLogic->createBlendShapesInstance(memRes)},
    animatedMapsInstance{rigLogic->createAnimatedMapsInstance(memRes)} {
}

std::uint16_t RigInstanceImpl::getGUIControlCount() const {
    return guiControlCount;
}

float RigInstanceImpl::getGUIControl(std::uint16_t index) const {
    return getGUIControlValues()[index];
}

void RigInstanceImpl::setGUIControl(std::uint16_t index, float value) {
    auto guiControlBuffer = controlsInstance->getGUIControlBuffer();
    guiControlBuffer[index] = value;
}

ConstArrayView<float> RigInstanceImpl::getGUIControlValues() const {
    return controlsInstance->getGUIControlBuffer();
}

void RigInstanceImpl::setGUIControlValues(const float* values) {
    auto guiControlBuffer = controlsInstance->getGUIControlBuffer();
    #if defined(_MSC_VER) && !defined(__clang__) && (_MSC_VER < 1938)
        #if (_MSC_VER >= 1900) && (__cplusplus >= 202002L)
            std::copy(values,
                      values + guiControlCount,
                      std::span{guiControlBuffer.data(), guiControlBuffer.size()}.begin());
        #else
            std::copy(values,
                      values + guiControlCount,
                      stdext::make_checked_array_iterator(guiControlBuffer.data(), guiControlBuffer.size()));
        #endif
    #else
        std::copy(values, values + guiControlCount, guiControlBuffer.begin());
    #endif
}

std::uint16_t RigInstanceImpl::getRawControlCount() const {
    return rawControlCount;
}

float RigInstanceImpl::getRawControl(std::uint16_t index) const {
    return getRawControlValues()[index];
}

void RigInstanceImpl::setRawControl(std::uint16_t index, float value) {
    auto inputBuffer = controlsInstance->getInputBuffer();
    inputBuffer[index] = value;
}

ConstArrayView<float> RigInstanceImpl::getRawControlValues() const {
    return controlsInstance->getInputBuffer().subview(0ul, rawControlCount);
}

void RigInstanceImpl::setRawControlValues(const float* values) {
    auto inputBuffer = controlsInstance->getInputBuffer();
    #if defined(_MSC_VER) && !defined(__clang__) && (_MSC_VER < 1938)
        #if (_MSC_VER >= 1900) && (__cplusplus >= 202002L)
            std::copy(values,
                      values + rawControlCount,
                      std::span{inputBuffer.data(), inputBuffer.size()}.begin());
        #else
            std::copy(values,
                      values + rawControlCount,
                      stdext::make_checked_array_iterator(inputBuffer.data(), inputBuffer.size()));
        #endif
    #else
        std::copy(values, values + rawControlCount, inputBuffer.begin());
    #endif
}

std::uint16_t RigInstanceImpl::getPSDControlCount() const {
    return psdControlCount;
}

float RigInstanceImpl::getPSDControl(std::uint16_t index) const {
    return getPSDControlValues()[index];
}

ConstArrayView<float> RigInstanceImpl::getPSDControlValues() const {
    return controlsInstance->getInputBuffer().subview(rawControlCount, psdControlCount);
}

std::uint16_t RigInstanceImpl::getMLControlCount() const {
    return mlControlCount;
}

float RigInstanceImpl::getMLControl(std::uint16_t index) const {
    return getMLControlValues()[index];
}

ConstArrayView<float> RigInstanceImpl::getMLControlValues() const {
    const auto mlControlsOffset = static_cast<std::size_t>(rawControlCount) + static_cast<std::size_t>(psdControlCount);
    return controlsInstance->getInputBuffer().subview(mlControlsOffset, mlControlCount);
}

std::uint16_t RigInstanceImpl::getRBFControlCount() const {
    return rbfControlCount;
}

float RigInstanceImpl::getRBFControl(std::uint16_t index) const {
    return getRBFControlValues()[index];
}

ConstArrayView<float> RigInstanceImpl::getRBFControlValues() const {
    const auto rbfControlsOffset = static_cast<std::size_t>(rawControlCount) + static_cast<std::size_t>(psdControlCount) +
        static_cast<std::size_t>(mlControlCount);
    return controlsInstance->getInputBuffer().subview(rbfControlsOffset, rbfControlCount);
}

std::uint16_t RigInstanceImpl::getNeuralNetworkCount() const {
    return neuralNetworkCount;
}

float RigInstanceImpl::getNeuralNetworkMask(std::uint16_t neuralNetIndex) const {
    assert(neuralNetIndex < neuralNetworkCount);
    auto maskBuffer = machineLearnedBehaviorInstance->getMaskBuffer();
    return maskBuffer[neuralNetIndex];
}

void RigInstanceImpl::setNeuralNetworkMask(std::uint16_t neuralNetIndex, float value) {
    assert(neuralNetIndex < neuralNetworkCount);
    auto maskBuffer = machineLearnedBehaviorInstance->getMaskBuffer();
    maskBuffer[neuralNetIndex] = value;
}

std::uint16_t RigInstanceImpl::getLOD() const {
    return lodLevel;
}

void RigInstanceImpl::setLOD(std::uint16_t level) {
    if (level != lodLevel) {
        controlsInstance->resetInternalInputBuffer();
        jointsInstance->resetOutputBuffer();
        blendShapesInstance->resetOutputBuffer();
        animatedMapsInstance->resetOutputBuffer();
    }
    lodLevel = extd::clamp(level, static_cast<std::uint16_t>(0), lodMaxLevel);
}

ConstArrayView<float> RigInstanceImpl::getJointOutputs() const {
    return jointsInstance->getOutputBuffer();
}

ConstArrayView<float> RigInstanceImpl::getBlendShapeOutputs() const {
    return blendShapesInstance->getOutputBuffer();
}

ConstArrayView<float> RigInstanceImpl::getAnimatedMapOutputs() const {
    return animatedMapsInstance->getOutputBuffer();
}

ControlsInputInstance* RigInstanceImpl::getControlsInputInstance() {
    return controlsInstance.get();
}

MachineLearnedBehaviorOutputInstance* RigInstanceImpl::getMachineLearnedBehaviorOutputInstance() {
    return machineLearnedBehaviorInstance.get();
}

RBFBehaviorOutputInstance* RigInstanceImpl::getRBFBehaviorOutputInstance() {
    return rbfBehaviorInstance.get();
}

JointsOutputInstance* RigInstanceImpl::getJointsOutputInstance() {
    return jointsInstance.get();
}

BlendShapesOutputInstance* RigInstanceImpl::getBlendShapesOutputInstance() {
    return blendShapesInstance.get();
}

AnimatedMapsOutputInstance* RigInstanceImpl::getAnimatedMapOutputInstance() {
    return animatedMapsInstance.get();
}

MemoryResource* RigInstanceImpl::getMemoryResource() {
    return memRes;
}

}  // namespace rl4
