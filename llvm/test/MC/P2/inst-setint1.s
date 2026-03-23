
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ setint1 r0
	if_nc_and_nz setint1 r0
	if_nc_and_z setint1 r0
	if_nc setint1 r0
	if_c_and_nz setint1 r0
	if_nz setint1 r0
	if_c_ne_z setint1 r0
	if_nc_or_nz setint1 r0
	if_c_and_z setint1 r0
	if_c_eq_z setint1 r0
	if_z setint1 r0
	if_nc_or_z setint1 r0
	if_c setint1 r0
	if_c_or_nz setint1 r0
	if_c_or_z setint1 r0
	setint1 r0
	_ret_ setint1 #0


' CHECK: _ret_ setint1 r0 ' encoding: [0x25,0xa0,0x63,0x0d]
' CHECK-INST: _ret_ setint1 r0


' CHECK: if_nc_and_nz setint1 r0 ' encoding: [0x25,0xa0,0x63,0x1d]
' CHECK-INST: if_nc_and_nz setint1 r0


' CHECK: if_nc_and_z setint1 r0 ' encoding: [0x25,0xa0,0x63,0x2d]
' CHECK-INST: if_nc_and_z setint1 r0


' CHECK: if_nc setint1 r0 ' encoding: [0x25,0xa0,0x63,0x3d]
' CHECK-INST: if_nc setint1 r0


' CHECK: if_c_and_nz setint1 r0 ' encoding: [0x25,0xa0,0x63,0x4d]
' CHECK-INST: if_c_and_nz setint1 r0


' CHECK: if_nz setint1 r0 ' encoding: [0x25,0xa0,0x63,0x5d]
' CHECK-INST: if_nz setint1 r0


' CHECK: if_c_ne_z setint1 r0 ' encoding: [0x25,0xa0,0x63,0x6d]
' CHECK-INST: if_c_ne_z setint1 r0


' CHECK: if_nc_or_nz setint1 r0 ' encoding: [0x25,0xa0,0x63,0x7d]
' CHECK-INST: if_nc_or_nz setint1 r0


' CHECK: if_c_and_z setint1 r0 ' encoding: [0x25,0xa0,0x63,0x8d]
' CHECK-INST: if_c_and_z setint1 r0


' CHECK: if_c_eq_z setint1 r0 ' encoding: [0x25,0xa0,0x63,0x9d]
' CHECK-INST: if_c_eq_z setint1 r0


' CHECK: if_z setint1 r0 ' encoding: [0x25,0xa0,0x63,0xad]
' CHECK-INST: if_z setint1 r0


' CHECK: if_nc_or_z setint1 r0 ' encoding: [0x25,0xa0,0x63,0xbd]
' CHECK-INST: if_nc_or_z setint1 r0


' CHECK: if_c setint1 r0 ' encoding: [0x25,0xa0,0x63,0xcd]
' CHECK-INST: if_c setint1 r0


' CHECK: if_c_or_nz setint1 r0 ' encoding: [0x25,0xa0,0x63,0xdd]
' CHECK-INST: if_c_or_nz setint1 r0


' CHECK: if_c_or_z setint1 r0 ' encoding: [0x25,0xa0,0x63,0xed]
' CHECK-INST: if_c_or_z setint1 r0


' CHECK: setint1 r0 ' encoding: [0x25,0xa0,0x63,0xfd]
' CHECK-INST: setint1 r0


' CHECK: _ret_ setint1 #0 ' encoding: [0x25,0x00,0x64,0x0d]
' CHECK-INST: _ret_ setint1 #0


