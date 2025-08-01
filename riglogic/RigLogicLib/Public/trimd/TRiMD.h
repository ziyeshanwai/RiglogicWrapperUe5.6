// Copyright Epic Games, Inc. All Rights Reserved.

#pragma once

#include "trimd/Platform.h"
// Includes that go after platform detection macros
#include "trimd/AVX.h"
#include "trimd/NEON.h"
#include "trimd/SSE.h"
#include "trimd/Scalar.h"

namespace trimd {

#if defined(TRIMD_ENABLE_AVX)
    using F256 = avx::F256;
    using avx::abs;
    using avx::transpose;
    using avx::andnot;
    using avx::rsqrt;
#elif defined(TRIMD_ENABLE_SSE)
    using F256 = sse::F256;
#elif defined(TRIMD_ENABLE_NEON)
    using F256 = neon::F256;
#else
    using F256 = scalar::F256;
#endif  // TRIMD_ENABLE_AVX

#if defined(TRIMD_ENABLE_SSE)
    using F128 = sse::F128;
    using sse::abs;
    using sse::transpose;
    using sse::andnot;
    using sse::rsqrt;
#elif defined(TRIMD_ENABLE_NEON)
    using F128 = neon::F128;
    using neon::abs;
    using neon::transpose;
    using neon::andnot;
    using neon::rsqrt;
#else
    using F128 = scalar::F128;
#endif  // TRIMD_ENABLE_SSE

using scalar::abs;
using scalar::transpose;
using scalar::andnot;
using scalar::rsqrt;

}  // namespace trimd
