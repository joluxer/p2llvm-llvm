
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ waitxro
	if_nc_and_nz waitxro
	if_nc_and_z waitxro
	if_nc waitxro
	if_c_and_nz waitxro
	if_nz waitxro
	if_c_ne_z waitxro
	if_nc_or_nz waitxro
	if_c_and_z waitxro
	if_c_eq_z waitxro
	if_z waitxro
	if_nc_or_z waitxro
	if_c waitxro
	if_c_or_nz waitxro
	if_c_or_z waitxro
	waitxro
	_ret_ waitxro wc
	_ret_ waitxro wz
	_ret_ waitxro wcz


' CHECK: _ret_ waitxro ' encoding: [0x24,0x38,0x60,0x0d]
' CHECK-INST: _ret_ waitxro


' CHECK: if_nc_and_nz waitxro ' encoding: [0x24,0x38,0x60,0x1d]
' CHECK-INST: if_nc_and_nz waitxro


' CHECK: if_nc_and_z waitxro ' encoding: [0x24,0x38,0x60,0x2d]
' CHECK-INST: if_nc_and_z waitxro


' CHECK: if_nc waitxro ' encoding: [0x24,0x38,0x60,0x3d]
' CHECK-INST: if_nc waitxro


' CHECK: if_c_and_nz waitxro ' encoding: [0x24,0x38,0x60,0x4d]
' CHECK-INST: if_c_and_nz waitxro


' CHECK: if_nz waitxro ' encoding: [0x24,0x38,0x60,0x5d]
' CHECK-INST: if_nz waitxro


' CHECK: if_c_ne_z waitxro ' encoding: [0x24,0x38,0x60,0x6d]
' CHECK-INST: if_c_ne_z waitxro


' CHECK: if_nc_or_nz waitxro ' encoding: [0x24,0x38,0x60,0x7d]
' CHECK-INST: if_nc_or_nz waitxro


' CHECK: if_c_and_z waitxro ' encoding: [0x24,0x38,0x60,0x8d]
' CHECK-INST: if_c_and_z waitxro


' CHECK: if_c_eq_z waitxro ' encoding: [0x24,0x38,0x60,0x9d]
' CHECK-INST: if_c_eq_z waitxro


' CHECK: if_z waitxro ' encoding: [0x24,0x38,0x60,0xad]
' CHECK-INST: if_z waitxro


' CHECK: if_nc_or_z waitxro ' encoding: [0x24,0x38,0x60,0xbd]
' CHECK-INST: if_nc_or_z waitxro


' CHECK: if_c waitxro ' encoding: [0x24,0x38,0x60,0xcd]
' CHECK-INST: if_c waitxro


' CHECK: if_c_or_nz waitxro ' encoding: [0x24,0x38,0x60,0xdd]
' CHECK-INST: if_c_or_nz waitxro


' CHECK: if_c_or_z waitxro ' encoding: [0x24,0x38,0x60,0xed]
' CHECK-INST: if_c_or_z waitxro


' CHECK: waitxro ' encoding: [0x24,0x38,0x60,0xfd]
' CHECK-INST: waitxro


' CHECK: _ret_ waitxro wc ' encoding: [0x24,0x38,0x70,0x0d]
' CHECK-INST: _ret_ waitxro wc


' CHECK: _ret_ waitxro wz ' encoding: [0x24,0x38,0x68,0x0d]
' CHECK-INST: _ret_ waitxro wz


' CHECK: _ret_ waitxro wcz ' encoding: [0x24,0x38,0x78,0x0d]
' CHECK-INST: _ret_ waitxro wcz


