
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ trgint3
	if_nc_and_nz trgint3
	if_nc_and_z trgint3
	if_nc trgint3
	if_c_and_nz trgint3
	if_nz trgint3
	if_c_ne_z trgint3
	if_nc_or_nz trgint3
	if_c_and_z trgint3
	if_c_eq_z trgint3
	if_z trgint3
	if_nc_or_z trgint3
	if_c trgint3
	if_c_or_nz trgint3
	if_c_or_z trgint3
	trgint3
	_ret_ trgint3 wc
	_ret_ trgint3 wz
	_ret_ trgint3 wcz


' CHECK: _ret_ trgint3 ' encoding: [0x24,0x46,0x60,0x0d]
' CHECK-INST: _ret_ trgint3


' CHECK: if_nc_and_nz trgint3 ' encoding: [0x24,0x46,0x60,0x1d]
' CHECK-INST: if_nc_and_nz trgint3


' CHECK: if_nc_and_z trgint3 ' encoding: [0x24,0x46,0x60,0x2d]
' CHECK-INST: if_nc_and_z trgint3


' CHECK: if_nc trgint3 ' encoding: [0x24,0x46,0x60,0x3d]
' CHECK-INST: if_nc trgint3


' CHECK: if_c_and_nz trgint3 ' encoding: [0x24,0x46,0x60,0x4d]
' CHECK-INST: if_c_and_nz trgint3


' CHECK: if_nz trgint3 ' encoding: [0x24,0x46,0x60,0x5d]
' CHECK-INST: if_nz trgint3


' CHECK: if_c_ne_z trgint3 ' encoding: [0x24,0x46,0x60,0x6d]
' CHECK-INST: if_c_ne_z trgint3


' CHECK: if_nc_or_nz trgint3 ' encoding: [0x24,0x46,0x60,0x7d]
' CHECK-INST: if_nc_or_nz trgint3


' CHECK: if_c_and_z trgint3 ' encoding: [0x24,0x46,0x60,0x8d]
' CHECK-INST: if_c_and_z trgint3


' CHECK: if_c_eq_z trgint3 ' encoding: [0x24,0x46,0x60,0x9d]
' CHECK-INST: if_c_eq_z trgint3


' CHECK: if_z trgint3 ' encoding: [0x24,0x46,0x60,0xad]
' CHECK-INST: if_z trgint3


' CHECK: if_nc_or_z trgint3 ' encoding: [0x24,0x46,0x60,0xbd]
' CHECK-INST: if_nc_or_z trgint3


' CHECK: if_c trgint3 ' encoding: [0x24,0x46,0x60,0xcd]
' CHECK-INST: if_c trgint3


' CHECK: if_c_or_nz trgint3 ' encoding: [0x24,0x46,0x60,0xdd]
' CHECK-INST: if_c_or_nz trgint3


' CHECK: if_c_or_z trgint3 ' encoding: [0x24,0x46,0x60,0xed]
' CHECK-INST: if_c_or_z trgint3


' CHECK: trgint3 ' encoding: [0x24,0x46,0x60,0xfd]
' CHECK-INST: trgint3


' CHECK: _ret_ trgint3 wc ' encoding: [0x24,0x46,0x70,0x0d]
' CHECK-INST: _ret_ trgint3 wc


' CHECK: _ret_ trgint3 wz ' encoding: [0x24,0x46,0x68,0x0d]
' CHECK-INST: _ret_ trgint3 wz


' CHECK: _ret_ trgint3 wcz ' encoding: [0x24,0x46,0x78,0x0d]
' CHECK-INST: _ret_ trgint3 wcz


