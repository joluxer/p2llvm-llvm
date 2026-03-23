
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ trgint2
	if_nc_and_nz trgint2
	if_nc_and_z trgint2
	if_nc trgint2
	if_c_and_nz trgint2
	if_nz trgint2
	if_c_ne_z trgint2
	if_nc_or_nz trgint2
	if_c_and_z trgint2
	if_c_eq_z trgint2
	if_z trgint2
	if_nc_or_z trgint2
	if_c trgint2
	if_c_or_nz trgint2
	if_c_or_z trgint2
	trgint2
	_ret_ trgint2 wc
	_ret_ trgint2 wz
	_ret_ trgint2 wcz


' CHECK: _ret_ trgint2 ' encoding: [0x24,0x44,0x60,0x0d]
' CHECK-INST: _ret_ trgint2


' CHECK: if_nc_and_nz trgint2 ' encoding: [0x24,0x44,0x60,0x1d]
' CHECK-INST: if_nc_and_nz trgint2


' CHECK: if_nc_and_z trgint2 ' encoding: [0x24,0x44,0x60,0x2d]
' CHECK-INST: if_nc_and_z trgint2


' CHECK: if_nc trgint2 ' encoding: [0x24,0x44,0x60,0x3d]
' CHECK-INST: if_nc trgint2


' CHECK: if_c_and_nz trgint2 ' encoding: [0x24,0x44,0x60,0x4d]
' CHECK-INST: if_c_and_nz trgint2


' CHECK: if_nz trgint2 ' encoding: [0x24,0x44,0x60,0x5d]
' CHECK-INST: if_nz trgint2


' CHECK: if_c_ne_z trgint2 ' encoding: [0x24,0x44,0x60,0x6d]
' CHECK-INST: if_c_ne_z trgint2


' CHECK: if_nc_or_nz trgint2 ' encoding: [0x24,0x44,0x60,0x7d]
' CHECK-INST: if_nc_or_nz trgint2


' CHECK: if_c_and_z trgint2 ' encoding: [0x24,0x44,0x60,0x8d]
' CHECK-INST: if_c_and_z trgint2


' CHECK: if_c_eq_z trgint2 ' encoding: [0x24,0x44,0x60,0x9d]
' CHECK-INST: if_c_eq_z trgint2


' CHECK: if_z trgint2 ' encoding: [0x24,0x44,0x60,0xad]
' CHECK-INST: if_z trgint2


' CHECK: if_nc_or_z trgint2 ' encoding: [0x24,0x44,0x60,0xbd]
' CHECK-INST: if_nc_or_z trgint2


' CHECK: if_c trgint2 ' encoding: [0x24,0x44,0x60,0xcd]
' CHECK-INST: if_c trgint2


' CHECK: if_c_or_nz trgint2 ' encoding: [0x24,0x44,0x60,0xdd]
' CHECK-INST: if_c_or_nz trgint2


' CHECK: if_c_or_z trgint2 ' encoding: [0x24,0x44,0x60,0xed]
' CHECK-INST: if_c_or_z trgint2


' CHECK: trgint2 ' encoding: [0x24,0x44,0x60,0xfd]
' CHECK-INST: trgint2


' CHECK: _ret_ trgint2 wc ' encoding: [0x24,0x44,0x70,0x0d]
' CHECK-INST: _ret_ trgint2 wc


' CHECK: _ret_ trgint2 wz ' encoding: [0x24,0x44,0x68,0x0d]
' CHECK-INST: _ret_ trgint2 wz


' CHECK: _ret_ trgint2 wcz ' encoding: [0x24,0x44,0x78,0x0d]
' CHECK-INST: _ret_ trgint2 wcz


