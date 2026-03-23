
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ waitatn
	if_nc_and_nz waitatn
	if_nc_and_z waitatn
	if_nc waitatn
	if_c_and_nz waitatn
	if_nz waitatn
	if_c_ne_z waitatn
	if_nc_or_nz waitatn
	if_c_and_z waitatn
	if_c_eq_z waitatn
	if_z waitatn
	if_nc_or_z waitatn
	if_c waitatn
	if_c_or_nz waitatn
	if_c_or_z waitatn
	waitatn
	_ret_ waitatn wc
	_ret_ waitatn wz
	_ret_ waitatn wcz


' CHECK: _ret_ waitatn ' encoding: [0x24,0x3c,0x60,0x0d]
' CHECK-INST: _ret_ waitatn


' CHECK: if_nc_and_nz waitatn ' encoding: [0x24,0x3c,0x60,0x1d]
' CHECK-INST: if_nc_and_nz waitatn


' CHECK: if_nc_and_z waitatn ' encoding: [0x24,0x3c,0x60,0x2d]
' CHECK-INST: if_nc_and_z waitatn


' CHECK: if_nc waitatn ' encoding: [0x24,0x3c,0x60,0x3d]
' CHECK-INST: if_nc waitatn


' CHECK: if_c_and_nz waitatn ' encoding: [0x24,0x3c,0x60,0x4d]
' CHECK-INST: if_c_and_nz waitatn


' CHECK: if_nz waitatn ' encoding: [0x24,0x3c,0x60,0x5d]
' CHECK-INST: if_nz waitatn


' CHECK: if_c_ne_z waitatn ' encoding: [0x24,0x3c,0x60,0x6d]
' CHECK-INST: if_c_ne_z waitatn


' CHECK: if_nc_or_nz waitatn ' encoding: [0x24,0x3c,0x60,0x7d]
' CHECK-INST: if_nc_or_nz waitatn


' CHECK: if_c_and_z waitatn ' encoding: [0x24,0x3c,0x60,0x8d]
' CHECK-INST: if_c_and_z waitatn


' CHECK: if_c_eq_z waitatn ' encoding: [0x24,0x3c,0x60,0x9d]
' CHECK-INST: if_c_eq_z waitatn


' CHECK: if_z waitatn ' encoding: [0x24,0x3c,0x60,0xad]
' CHECK-INST: if_z waitatn


' CHECK: if_nc_or_z waitatn ' encoding: [0x24,0x3c,0x60,0xbd]
' CHECK-INST: if_nc_or_z waitatn


' CHECK: if_c waitatn ' encoding: [0x24,0x3c,0x60,0xcd]
' CHECK-INST: if_c waitatn


' CHECK: if_c_or_nz waitatn ' encoding: [0x24,0x3c,0x60,0xdd]
' CHECK-INST: if_c_or_nz waitatn


' CHECK: if_c_or_z waitatn ' encoding: [0x24,0x3c,0x60,0xed]
' CHECK-INST: if_c_or_z waitatn


' CHECK: waitatn ' encoding: [0x24,0x3c,0x60,0xfd]
' CHECK-INST: waitatn


' CHECK: _ret_ waitatn wc ' encoding: [0x24,0x3c,0x70,0x0d]
' CHECK-INST: _ret_ waitatn wc


' CHECK: _ret_ waitatn wz ' encoding: [0x24,0x3c,0x68,0x0d]
' CHECK-INST: _ret_ waitatn wz


' CHECK: _ret_ waitatn wcz ' encoding: [0x24,0x3c,0x78,0x0d]
' CHECK-INST: _ret_ waitatn wcz


