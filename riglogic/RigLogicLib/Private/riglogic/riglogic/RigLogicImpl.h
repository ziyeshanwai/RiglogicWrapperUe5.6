// Copyright Epic Games, Inc. All Rights Reserved.

#pragma once

#include "riglogic/TypeDefs.h"
#include "riglogic/animatedmaps/AnimatedMaps.h"
#include "riglogic/animatedmaps/AnimatedMapsOutputInstance.h"
#include "riglogic/blendshapes/BlendShapes.h"
#include "riglogic/blendshapes/BlendShapesOutputInstance.h"
#include "riglogic/controls/Controls.h"
#include "riglogic/controls/ControlsInputInstance.h"
#include "riglogic/joints/Joints.h"
#include "riglogic/joints/JointsOutputInstance.h"
#include "riglogic/ml/MachineLearnedBehavior.h"
#include "riglogic/ml/MachineLearnedBehaviorOutputInstance.h"
#include "riglogic/rbf/RBFBehavior.h"
#include "riglogic/riglogic/Configuration.h"
#include "riglogic/riglogic/RigLogic.h"
#include "riglogic/riglogic/RigMetrics.h"
#include "riglogic/system/simd/Utils.h"

namespace rl4 {

class RigLogicImpl : public RigLogic {
    public:
        RigLogicImpl(const Configuration& config_,
                     ActiveFeatures activeFeatures_,
                     RigMetrics::Pointer metrics_,
                     Controls::Pointer controls_,
                     MachineLearnedBehavior::Pointer machineLearnedBehavior_,
                     RBFBehavior::Pointer rbfBehavior_,
                     Joints::Pointer joints_,
                     BlendShapes::Pointer blendShapes_,
                     AnimatedMaps::Pointer animatedMaps_,
                     MemoryResource* memRes_);

        void dump(BoundedIOStream* destination) const override;
        const Configuration& getConfiguration() const override;
        const RigMetrics& getRigMetrics() const;
        std::uint16_t getLODCount() const override;
        ConstArrayView<std::uint16_t> getRBFSolverIndicesForLOD(std::uint16_t lod) const override;
        ConstArrayView<std::uint32_t> getNeuralNetworkIndicesForLOD(std::uint16_t lod) const override;
        ConstArrayView<std::uint16_t> getBlendShapeChannelIndicesForLOD(std::uint16_t lod) const override;
        ConstArrayView<std::uint16_t> getAnimatedMapIndicesForLOD(std::uint16_t lod) const override;
        ConstArrayView<std::uint16_t> getJointIndicesForLOD(std::uint16_t lod) const override;
        ConstArrayView<float> getNeutralJointValues() const override;
        ConstArrayView<std::uint16_t> getJointVariableAttributeIndices(std::uint16_t lod) const override;
        std::uint16_t getJointGroupCount() const override;
        std::uint16_t getNeuralNetworkCount() const override;
        std::uint16_t getRBFSolverCount() const override;
        std::uint16_t getMeshCount() const override;
        std::uint16_t getMeshRegionCount(std::uint16_t meshIndex) const override;
        ConstArrayView<std::uint16_t> getNeuralNetworkIndices(std::uint16_t meshIndex, std::uint16_t regionIndex) const override;

        ControlsInputInstance::Pointer createControlsInstance(MemoryResource* instanceMemRes) const;
        MachineLearnedBehaviorOutputInstance::Pointer createMachineLearnedBehaviorInstance(MemoryResource* instanceMemRes) const;
        RBFBehaviorOutputInstance::Pointer createRBFBehaviorInstance(MemoryResource* instanceMemRes) const;
        JointsOutputInstance::Pointer createJointsInstance(MemoryResource* instanceMemRes) const;
        BlendShapesOutputInstance::Pointer createBlendShapesInstance(MemoryResource* instanceMemRes) const;
        AnimatedMapsOutputInstance::Pointer createAnimatedMapsInstance(MemoryResource* instanceMemRes) const;

        void mapGUIToRawControls(RigInstance* instance) const override;
        void mapRawToGUIControls(RigInstance* instance) const override;
        void calculateControls(RigInstance* instance) const override;
        void calculateMachineLearnedBehaviorControls(RigInstance* instance) const override;
        void calculateMachineLearnedBehaviorControls(RigInstance* instance, std::uint16_t neuralNetIndex) const override;
        void calculateRBFControls(RigInstance* instance) const override;
        void calculateRBFControls(RigInstance* instance, std::uint16_t solverIndex) const override;
        void calculateJoints(RigInstance* instance) const override;
        void calculateJoints(RigInstance* instance, std::uint16_t jointGroupIndex) const override;
        void calculateBlendShapes(RigInstance* instance) const override;
        void calculateAnimatedMaps(RigInstance* instance) const override;
        void calculate(RigInstance* instance) const override;
        void collectCalculationStats(const RigInstance* instance, Stats* stats) const override;

        MemoryResource* getMemoryResource();

    private:
        MemoryResource* memRes;
        Configuration config;
        ActiveFeatures activeFeatures;
        RigMetrics::Pointer metrics;
        Controls::Pointer controls;
        MachineLearnedBehavior::Pointer machineLearnedBehavior;
        RBFBehavior::Pointer rbfBehavior;
        Joints::Pointer joints;
        BlendShapes::Pointer blendShapes;
        AnimatedMaps::Pointer animatedMaps;

};

}  // namespace rl4
