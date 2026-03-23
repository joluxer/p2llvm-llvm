
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ stalli
	if_nc_and_nz stalli
	if_nc_and_z stalli
	if_nc stalli
	if_c_and_nz stalli
	if_nz stalli
	if_c_ne_z stalli
	if_nc_or_nz stalli
	if_c_and_z stalli
	if_c_eq_z stalli
	if_z stalli
	if_nc_or_z stalli
	if_c stalli
	if_c_or_nz stalli
	if_c_or_z stalli
	stalli
	_ret_ stalli wc
	_ret_ stalli wz
	_ret_ stalli wcz


' CHECK: _ret_ stalli ' encoding: [0x24,0x40,0x60,0x0d]
' CHECK-INST: _ret_ stalli


' CHECK: if_nc_and_nz stalli ' encoding: [0x24,0x40,0x60,0x1d]
' CHECK-INST: if_nc_and_nz stalli


' CHECK: if_nc_and_z stalli ' encoding: [0x24,0x40,0x60,0x2d]
' CHECK-INST: if_nc_and_z stalli


' CHECK: if_nc stalli ' encoding: [0x24,0x40,0x60,0x3d]
' CHECK-INST: if_nc stalli


' CHECK: if_c_and_nz stalli ' encoding: [0x24,0x40,0x60,0x4d]
' CHECK-INST: if_c_and_nz stalli


' CHECK: if_nz stalli ' encoding: [0x24,0x40,0x60,0x5d]
' CHECK-INST: if_nz stalli


' CHECK: if_c_ne_z stalli ' encoding: [0x24,0x40,0x60,0x6d]
' CHECK-INST: if_c_ne_z stalli


' CHECK: if_nc_or_nz stalli ' encoding: [0x24,0x40,0x60,0x7d]
' CHECK-INST: if_nc_or_nz stalli


' CHECK: if_c_and_z stalli ' encoding: [0x24,0x40,0x60,0x8d]
' CHECK-INST: if_c_and_z stalli


' CHECK: if_c_eq_z stalli ' encoding: [0x24,0x40,0x60,0x9d]
' CHECK-INST: if_c_eq_z stalli


' CHECK: if_z stalli ' encoding: [0x24,0x40,0x60,0xad]
' CHECK-INST: if_z stalli


' CHECK: if_nc_or_z stalli ' encoding: [0x24,0x40,0x60,0xbd]
' CHECK-INST: if_nc_or_z stalli


' CHECK: if_c stalli ' encoding: [0x24,0x40,0x60,0xcd]
' CHECK-INST: if_c stalli


' CHECK: if_c_or_nz stalli ' encoding: [0x24,0x40,0x60,0xdd]
' CHECK-INST: if_c_or_nz stalli


' CHECK: if_c_or_z stalli ' encoding: [0x24,0x40,0x60,0xed]
' CHECK-INST: if_c_or_z stalli


' CHECK: stalli ' encoding: [0x24,0x40,0x60,0xfd]
' CHECK-INST: stalli


' CHECK: _ret_ stalli wc ' encoding: [0x24,0x40,0x70,0x0d]
' CHECK-INST: _ret_ stalli wc


' CHECK: _ret_ stalli wz ' encoding: [0x24,0x40,0x68,0x0d]
' CHECK-INST: _ret_ stalli wz


' CHECK: _ret_ stalli wcz ' encoding: [0x24,0x40,0x78,0x0d]
' CHECK-INST: _ret_ stalli wcz


