
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ waitxmt
	if_nc_and_nz waitxmt
	if_nc_and_z waitxmt
	if_nc waitxmt
	if_c_and_nz waitxmt
	if_nz waitxmt
	if_c_ne_z waitxmt
	if_nc_or_nz waitxmt
	if_c_and_z waitxmt
	if_c_eq_z waitxmt
	if_z waitxmt
	if_nc_or_z waitxmt
	if_c waitxmt
	if_c_or_nz waitxmt
	if_c_or_z waitxmt
	waitxmt
	_ret_ waitxmt wc
	_ret_ waitxmt wz
	_ret_ waitxmt wcz


' CHECK: _ret_ waitxmt ' encoding: [0x24,0x34,0x60,0x0d]
' CHECK-INST: _ret_ waitxmt


' CHECK: if_nc_and_nz waitxmt ' encoding: [0x24,0x34,0x60,0x1d]
' CHECK-INST: if_nc_and_nz waitxmt


' CHECK: if_nc_and_z waitxmt ' encoding: [0x24,0x34,0x60,0x2d]
' CHECK-INST: if_nc_and_z waitxmt


' CHECK: if_nc waitxmt ' encoding: [0x24,0x34,0x60,0x3d]
' CHECK-INST: if_nc waitxmt


' CHECK: if_c_and_nz waitxmt ' encoding: [0x24,0x34,0x60,0x4d]
' CHECK-INST: if_c_and_nz waitxmt


' CHECK: if_nz waitxmt ' encoding: [0x24,0x34,0x60,0x5d]
' CHECK-INST: if_nz waitxmt


' CHECK: if_c_ne_z waitxmt ' encoding: [0x24,0x34,0x60,0x6d]
' CHECK-INST: if_c_ne_z waitxmt


' CHECK: if_nc_or_nz waitxmt ' encoding: [0x24,0x34,0x60,0x7d]
' CHECK-INST: if_nc_or_nz waitxmt


' CHECK: if_c_and_z waitxmt ' encoding: [0x24,0x34,0x60,0x8d]
' CHECK-INST: if_c_and_z waitxmt


' CHECK: if_c_eq_z waitxmt ' encoding: [0x24,0x34,0x60,0x9d]
' CHECK-INST: if_c_eq_z waitxmt


' CHECK: if_z waitxmt ' encoding: [0x24,0x34,0x60,0xad]
' CHECK-INST: if_z waitxmt


' CHECK: if_nc_or_z waitxmt ' encoding: [0x24,0x34,0x60,0xbd]
' CHECK-INST: if_nc_or_z waitxmt


' CHECK: if_c waitxmt ' encoding: [0x24,0x34,0x60,0xcd]
' CHECK-INST: if_c waitxmt


' CHECK: if_c_or_nz waitxmt ' encoding: [0x24,0x34,0x60,0xdd]
' CHECK-INST: if_c_or_nz waitxmt


' CHECK: if_c_or_z waitxmt ' encoding: [0x24,0x34,0x60,0xed]
' CHECK-INST: if_c_or_z waitxmt


' CHECK: waitxmt ' encoding: [0x24,0x34,0x60,0xfd]
' CHECK-INST: waitxmt


' CHECK: _ret_ waitxmt wc ' encoding: [0x24,0x34,0x70,0x0d]
' CHECK-INST: _ret_ waitxmt wc


' CHECK: _ret_ waitxmt wz ' encoding: [0x24,0x34,0x68,0x0d]
' CHECK-INST: _ret_ waitxmt wz


' CHECK: _ret_ waitxmt wcz ' encoding: [0x24,0x34,0x78,0x0d]
' CHECK-INST: _ret_ waitxmt wcz


