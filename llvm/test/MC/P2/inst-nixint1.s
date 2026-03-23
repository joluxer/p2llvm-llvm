
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ nixint1
	if_nc_and_nz nixint1
	if_nc_and_z nixint1
	if_nc nixint1
	if_c_and_nz nixint1
	if_nz nixint1
	if_c_ne_z nixint1
	if_nc_or_nz nixint1
	if_c_and_z nixint1
	if_c_eq_z nixint1
	if_z nixint1
	if_nc_or_z nixint1
	if_c nixint1
	if_c_or_nz nixint1
	if_c_or_z nixint1
	nixint1
	_ret_ nixint1 wc
	_ret_ nixint1 wz
	_ret_ nixint1 wcz


' CHECK: _ret_ nixint1 ' encoding: [0x24,0x48,0x60,0x0d]
' CHECK-INST: _ret_ nixint1


' CHECK: if_nc_and_nz nixint1 ' encoding: [0x24,0x48,0x60,0x1d]
' CHECK-INST: if_nc_and_nz nixint1


' CHECK: if_nc_and_z nixint1 ' encoding: [0x24,0x48,0x60,0x2d]
' CHECK-INST: if_nc_and_z nixint1


' CHECK: if_nc nixint1 ' encoding: [0x24,0x48,0x60,0x3d]
' CHECK-INST: if_nc nixint1


' CHECK: if_c_and_nz nixint1 ' encoding: [0x24,0x48,0x60,0x4d]
' CHECK-INST: if_c_and_nz nixint1


' CHECK: if_nz nixint1 ' encoding: [0x24,0x48,0x60,0x5d]
' CHECK-INST: if_nz nixint1


' CHECK: if_c_ne_z nixint1 ' encoding: [0x24,0x48,0x60,0x6d]
' CHECK-INST: if_c_ne_z nixint1


' CHECK: if_nc_or_nz nixint1 ' encoding: [0x24,0x48,0x60,0x7d]
' CHECK-INST: if_nc_or_nz nixint1


' CHECK: if_c_and_z nixint1 ' encoding: [0x24,0x48,0x60,0x8d]
' CHECK-INST: if_c_and_z nixint1


' CHECK: if_c_eq_z nixint1 ' encoding: [0x24,0x48,0x60,0x9d]
' CHECK-INST: if_c_eq_z nixint1


' CHECK: if_z nixint1 ' encoding: [0x24,0x48,0x60,0xad]
' CHECK-INST: if_z nixint1


' CHECK: if_nc_or_z nixint1 ' encoding: [0x24,0x48,0x60,0xbd]
' CHECK-INST: if_nc_or_z nixint1


' CHECK: if_c nixint1 ' encoding: [0x24,0x48,0x60,0xcd]
' CHECK-INST: if_c nixint1


' CHECK: if_c_or_nz nixint1 ' encoding: [0x24,0x48,0x60,0xdd]
' CHECK-INST: if_c_or_nz nixint1


' CHECK: if_c_or_z nixint1 ' encoding: [0x24,0x48,0x60,0xed]
' CHECK-INST: if_c_or_z nixint1


' CHECK: nixint1 ' encoding: [0x24,0x48,0x60,0xfd]
' CHECK-INST: nixint1


' CHECK: _ret_ nixint1 wc ' encoding: [0x24,0x48,0x70,0x0d]
' CHECK-INST: _ret_ nixint1 wc


' CHECK: _ret_ nixint1 wz ' encoding: [0x24,0x48,0x68,0x0d]
' CHECK-INST: _ret_ nixint1 wz


' CHECK: _ret_ nixint1 wcz ' encoding: [0x24,0x48,0x78,0x0d]
' CHECK-INST: _ret_ nixint1 wcz


