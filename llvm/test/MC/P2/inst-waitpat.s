
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ waitpat
	if_nc_and_nz waitpat
	if_nc_and_z waitpat
	if_nc waitpat
	if_c_and_nz waitpat
	if_nz waitpat
	if_c_ne_z waitpat
	if_nc_or_nz waitpat
	if_c_and_z waitpat
	if_c_eq_z waitpat
	if_z waitpat
	if_nc_or_z waitpat
	if_c waitpat
	if_c_or_nz waitpat
	if_c_or_z waitpat
	waitpat
	_ret_ waitpat wc
	_ret_ waitpat wz
	_ret_ waitpat wcz


' CHECK: _ret_ waitpat ' encoding: [0x24,0x30,0x60,0x0d]
' CHECK-INST: _ret_ waitpat


' CHECK: if_nc_and_nz waitpat ' encoding: [0x24,0x30,0x60,0x1d]
' CHECK-INST: if_nc_and_nz waitpat


' CHECK: if_nc_and_z waitpat ' encoding: [0x24,0x30,0x60,0x2d]
' CHECK-INST: if_nc_and_z waitpat


' CHECK: if_nc waitpat ' encoding: [0x24,0x30,0x60,0x3d]
' CHECK-INST: if_nc waitpat


' CHECK: if_c_and_nz waitpat ' encoding: [0x24,0x30,0x60,0x4d]
' CHECK-INST: if_c_and_nz waitpat


' CHECK: if_nz waitpat ' encoding: [0x24,0x30,0x60,0x5d]
' CHECK-INST: if_nz waitpat


' CHECK: if_c_ne_z waitpat ' encoding: [0x24,0x30,0x60,0x6d]
' CHECK-INST: if_c_ne_z waitpat


' CHECK: if_nc_or_nz waitpat ' encoding: [0x24,0x30,0x60,0x7d]
' CHECK-INST: if_nc_or_nz waitpat


' CHECK: if_c_and_z waitpat ' encoding: [0x24,0x30,0x60,0x8d]
' CHECK-INST: if_c_and_z waitpat


' CHECK: if_c_eq_z waitpat ' encoding: [0x24,0x30,0x60,0x9d]
' CHECK-INST: if_c_eq_z waitpat


' CHECK: if_z waitpat ' encoding: [0x24,0x30,0x60,0xad]
' CHECK-INST: if_z waitpat


' CHECK: if_nc_or_z waitpat ' encoding: [0x24,0x30,0x60,0xbd]
' CHECK-INST: if_nc_or_z waitpat


' CHECK: if_c waitpat ' encoding: [0x24,0x30,0x60,0xcd]
' CHECK-INST: if_c waitpat


' CHECK: if_c_or_nz waitpat ' encoding: [0x24,0x30,0x60,0xdd]
' CHECK-INST: if_c_or_nz waitpat


' CHECK: if_c_or_z waitpat ' encoding: [0x24,0x30,0x60,0xed]
' CHECK-INST: if_c_or_z waitpat


' CHECK: waitpat ' encoding: [0x24,0x30,0x60,0xfd]
' CHECK-INST: waitpat


' CHECK: _ret_ waitpat wc ' encoding: [0x24,0x30,0x70,0x0d]
' CHECK-INST: _ret_ waitpat wc


' CHECK: _ret_ waitpat wz ' encoding: [0x24,0x30,0x68,0x0d]
' CHECK-INST: _ret_ waitpat wz


' CHECK: _ret_ waitpat wcz ' encoding: [0x24,0x30,0x78,0x0d]
' CHECK-INST: _ret_ waitpat wcz


