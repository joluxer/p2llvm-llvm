
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ waitxfi
	if_nc_and_nz waitxfi
	if_nc_and_z waitxfi
	if_nc waitxfi
	if_c_and_nz waitxfi
	if_nz waitxfi
	if_c_ne_z waitxfi
	if_nc_or_nz waitxfi
	if_c_and_z waitxfi
	if_c_eq_z waitxfi
	if_z waitxfi
	if_nc_or_z waitxfi
	if_c waitxfi
	if_c_or_nz waitxfi
	if_c_or_z waitxfi
	waitxfi
	_ret_ waitxfi wc
	_ret_ waitxfi wz
	_ret_ waitxfi wcz


' CHECK: _ret_ waitxfi ' encoding: [0x24,0x36,0x60,0x0d]
' CHECK-INST: _ret_ waitxfi


' CHECK: if_nc_and_nz waitxfi ' encoding: [0x24,0x36,0x60,0x1d]
' CHECK-INST: if_nc_and_nz waitxfi


' CHECK: if_nc_and_z waitxfi ' encoding: [0x24,0x36,0x60,0x2d]
' CHECK-INST: if_nc_and_z waitxfi


' CHECK: if_nc waitxfi ' encoding: [0x24,0x36,0x60,0x3d]
' CHECK-INST: if_nc waitxfi


' CHECK: if_c_and_nz waitxfi ' encoding: [0x24,0x36,0x60,0x4d]
' CHECK-INST: if_c_and_nz waitxfi


' CHECK: if_nz waitxfi ' encoding: [0x24,0x36,0x60,0x5d]
' CHECK-INST: if_nz waitxfi


' CHECK: if_c_ne_z waitxfi ' encoding: [0x24,0x36,0x60,0x6d]
' CHECK-INST: if_c_ne_z waitxfi


' CHECK: if_nc_or_nz waitxfi ' encoding: [0x24,0x36,0x60,0x7d]
' CHECK-INST: if_nc_or_nz waitxfi


' CHECK: if_c_and_z waitxfi ' encoding: [0x24,0x36,0x60,0x8d]
' CHECK-INST: if_c_and_z waitxfi


' CHECK: if_c_eq_z waitxfi ' encoding: [0x24,0x36,0x60,0x9d]
' CHECK-INST: if_c_eq_z waitxfi


' CHECK: if_z waitxfi ' encoding: [0x24,0x36,0x60,0xad]
' CHECK-INST: if_z waitxfi


' CHECK: if_nc_or_z waitxfi ' encoding: [0x24,0x36,0x60,0xbd]
' CHECK-INST: if_nc_or_z waitxfi


' CHECK: if_c waitxfi ' encoding: [0x24,0x36,0x60,0xcd]
' CHECK-INST: if_c waitxfi


' CHECK: if_c_or_nz waitxfi ' encoding: [0x24,0x36,0x60,0xdd]
' CHECK-INST: if_c_or_nz waitxfi


' CHECK: if_c_or_z waitxfi ' encoding: [0x24,0x36,0x60,0xed]
' CHECK-INST: if_c_or_z waitxfi


' CHECK: waitxfi ' encoding: [0x24,0x36,0x60,0xfd]
' CHECK-INST: waitxfi


' CHECK: _ret_ waitxfi wc ' encoding: [0x24,0x36,0x70,0x0d]
' CHECK-INST: _ret_ waitxfi wc


' CHECK: _ret_ waitxfi wz ' encoding: [0x24,0x36,0x68,0x0d]
' CHECK-INST: _ret_ waitxfi wz


' CHECK: _ret_ waitxfi wcz ' encoding: [0x24,0x36,0x78,0x0d]
' CHECK-INST: _ret_ waitxfi wcz


