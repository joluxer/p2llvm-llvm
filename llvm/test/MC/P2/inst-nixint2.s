
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ nixint2
	if_nc_and_nz nixint2
	if_nc_and_z nixint2
	if_nc nixint2
	if_c_and_nz nixint2
	if_nz nixint2
	if_c_ne_z nixint2
	if_nc_or_nz nixint2
	if_c_and_z nixint2
	if_c_eq_z nixint2
	if_z nixint2
	if_nc_or_z nixint2
	if_c nixint2
	if_c_or_nz nixint2
	if_c_or_z nixint2
	nixint2
	_ret_ nixint2 wc
	_ret_ nixint2 wz
	_ret_ nixint2 wcz


' CHECK: _ret_ nixint2 ' encoding: [0x24,0x4a,0x60,0x0d]
' CHECK-INST: _ret_ nixint2


' CHECK: if_nc_and_nz nixint2 ' encoding: [0x24,0x4a,0x60,0x1d]
' CHECK-INST: if_nc_and_nz nixint2


' CHECK: if_nc_and_z nixint2 ' encoding: [0x24,0x4a,0x60,0x2d]
' CHECK-INST: if_nc_and_z nixint2


' CHECK: if_nc nixint2 ' encoding: [0x24,0x4a,0x60,0x3d]
' CHECK-INST: if_nc nixint2


' CHECK: if_c_and_nz nixint2 ' encoding: [0x24,0x4a,0x60,0x4d]
' CHECK-INST: if_c_and_nz nixint2


' CHECK: if_nz nixint2 ' encoding: [0x24,0x4a,0x60,0x5d]
' CHECK-INST: if_nz nixint2


' CHECK: if_c_ne_z nixint2 ' encoding: [0x24,0x4a,0x60,0x6d]
' CHECK-INST: if_c_ne_z nixint2


' CHECK: if_nc_or_nz nixint2 ' encoding: [0x24,0x4a,0x60,0x7d]
' CHECK-INST: if_nc_or_nz nixint2


' CHECK: if_c_and_z nixint2 ' encoding: [0x24,0x4a,0x60,0x8d]
' CHECK-INST: if_c_and_z nixint2


' CHECK: if_c_eq_z nixint2 ' encoding: [0x24,0x4a,0x60,0x9d]
' CHECK-INST: if_c_eq_z nixint2


' CHECK: if_z nixint2 ' encoding: [0x24,0x4a,0x60,0xad]
' CHECK-INST: if_z nixint2


' CHECK: if_nc_or_z nixint2 ' encoding: [0x24,0x4a,0x60,0xbd]
' CHECK-INST: if_nc_or_z nixint2


' CHECK: if_c nixint2 ' encoding: [0x24,0x4a,0x60,0xcd]
' CHECK-INST: if_c nixint2


' CHECK: if_c_or_nz nixint2 ' encoding: [0x24,0x4a,0x60,0xdd]
' CHECK-INST: if_c_or_nz nixint2


' CHECK: if_c_or_z nixint2 ' encoding: [0x24,0x4a,0x60,0xed]
' CHECK-INST: if_c_or_z nixint2


' CHECK: nixint2 ' encoding: [0x24,0x4a,0x60,0xfd]
' CHECK-INST: nixint2


' CHECK: _ret_ nixint2 wc ' encoding: [0x24,0x4a,0x70,0x0d]
' CHECK-INST: _ret_ nixint2 wc


' CHECK: _ret_ nixint2 wz ' encoding: [0x24,0x4a,0x68,0x0d]
' CHECK-INST: _ret_ nixint2 wz


' CHECK: _ret_ nixint2 wcz ' encoding: [0x24,0x4a,0x78,0x0d]
' CHECK-INST: _ret_ nixint2 wcz


