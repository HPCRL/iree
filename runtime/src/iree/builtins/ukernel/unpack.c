// Copyright 2022 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include "iree/builtins/ukernel/unpack.h"

static iree_uk_status_t iree_uk_unpack_validate(
    const iree_uk_unpack_params_t* params) {
#ifdef IREE_UK_ENABLE_VALIDATION
  const iree_uk_uint32_t allflags =
      IREE_UK_FLAG_UNPACK_TRANSPOSE_INNER | IREE_UK_FLAG_UNPACK_TRANSPOSE_OUTER;
  if (params->flags & ~allflags) {
    return iree_uk_status_bad_flags;
  }
  switch (params->type) {
    case iree_uk_unpack_type_f32f32:
    case iree_uk_unpack_type_i8i8:
    case iree_uk_unpack_type_i32i32:
      break;
    default:
      return iree_uk_status_bad_type;
  }
  if (params->in_stride0 < 0 || params->out_stride0 < 0 ||
      params->in_size0 < 0 || params->in_size1 < 0 || params->in_size2 < 0 ||
      params->in_size3 < 0 || params->out_size0 < 0 || params->out_size1 < 0) {
    return iree_uk_status_unsupported_huge_or_negative_dimension;
  }
  // Check that the input and output shapes match, give or take padding that
  // must not exceed the inner tile size.s
  iree_uk_ssize_t outer_size0 = params->in_size0;
  iree_uk_ssize_t outer_size1 = params->in_size1;
  iree_uk_ssize_t tile_size0 = params->in_size2;
  iree_uk_ssize_t tile_size1 = params->in_size3;
  if (params->flags & IREE_UK_FLAG_UNPACK_TRANSPOSE_OUTER) {
    iree_uk_ssize_swap(&outer_size0, &outer_size1);
  }
  if (params->flags & IREE_UK_FLAG_UNPACK_TRANSPOSE_INNER) {
    iree_uk_ssize_swap(&tile_size0, &tile_size1);
  }
  if (outer_size0 * tile_size0 < params->out_size0 ||
      outer_size1 * tile_size1 < params->out_size1 ||
      (outer_size0 - 1) * tile_size0 >= params->out_size0 ||
      (outer_size1 - 1) * tile_size1 >= params->out_size1) {
    return iree_uk_status_shapes_mismatch;
  }
#endif  // IREE_UK_ENABLE_VALIDATION
  return iree_uk_status_ok;
}

static bool iree_uk_unpack_early(const iree_uk_unpack_params_t* params) {
  return (params->out_size0 == 0 || params->out_size1 == 0);
}

static void iree_unpack_reference(const iree_uk_unpack_params_t* params) {
  // For now, the input and output element types are always the same.
  iree_uk_type_t elem_type = iree_uk_unpack_in_type(params->type);
  iree_uk_ssize_t elem_size = iree_uk_type_size(elem_type);
  iree_uk_ssize_t outer_size0 = params->in_size0;
  iree_uk_ssize_t outer_size1 = params->in_size1;
  iree_uk_ssize_t tile_size0 = params->in_size2;
  iree_uk_ssize_t tile_size1 = params->in_size3;
  iree_uk_ssize_t in_stride_l0 = params->in_stride0;
  iree_uk_ssize_t in_stride_l1 = params->in_size3 * params->in_size2;
  iree_uk_ssize_t in_stride_l2 = params->in_size3;
  iree_uk_ssize_t in_stride_l3 = 1;
  if (params->flags & IREE_UK_FLAG_UNPACK_TRANSPOSE_OUTER) {
    iree_uk_ssize_swap(&outer_size0, &outer_size1);
    iree_uk_ssize_swap(&in_stride_l0, &in_stride_l1);
  }
  if (params->flags & IREE_UK_FLAG_UNPACK_TRANSPOSE_INNER) {
    iree_uk_ssize_swap(&tile_size0, &tile_size1);
    iree_uk_ssize_swap(&in_stride_l2, &in_stride_l3);
  }
  assert(outer_size0 * tile_size0 >= params->out_size0);
  assert(outer_size1 * tile_size1 >= params->out_size1);
  assert((outer_size0 - 1) * tile_size0 < params->out_size0);
  assert((outer_size1 - 1) * tile_size1 < params->out_size1);
  for (iree_uk_ssize_t outer_i0 = 0; outer_i0 < outer_size0; ++outer_i0) {
    for (iree_uk_ssize_t outer_i1 = 0; outer_i1 < outer_size1; ++outer_i1) {
      for (iree_uk_ssize_t tile_i0 = 0; tile_i0 < tile_size0; ++tile_i0) {
        for (iree_uk_ssize_t tile_i1 = 0; tile_i1 < tile_size1; ++tile_i1) {
          iree_uk_ssize_t in_offset =
              outer_i0 * in_stride_l0 + tile_i0 * in_stride_l2 +
              outer_i1 * in_stride_l1 + tile_i1 * in_stride_l3;
          iree_uk_ssize_t i0 = outer_i0 * tile_size0 + tile_i0;
          iree_uk_ssize_t i1 = outer_i1 * tile_size1 + tile_i1;
          if (!(i0 >= params->out_size0 || i1 >= params->out_size1)) {
            iree_uk_ssize_t out_offset = i1 + i0 * params->out_stride0;
            const char* in_ptr =
                ((char*)params->in_buffer) + in_offset * elem_size;
            char* out_ptr =
                ((char*)params->out_buffer) + out_offset * elem_size;
            iree_uk_memcpy(out_ptr, in_ptr, elem_size);
          }
        }
      }
    }
  }
}

iree_uk_status_t iree_uk_unpack(const iree_uk_unpack_params_t* params) {
  IREE_UK_RETURN_IF_ERROR(iree_uk_unpack_validate(params));

  if (iree_uk_unpack_early(params)) return iree_uk_status_ok;

  iree_unpack_reference(params);
  return iree_uk_status_ok;
}