
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ waitxrl
	if_nc_and_nz waitxrl
	if_nc_and_z waitxrl
	if_nc waitxrl
	if_c_and_nz waitxrl
	if_nz waitxrl
	if_c_ne_z waitxrl
	if_nc_or_nz waitxrl
	if_c_and_z waitxrl
	if_c_eq_z waitxrl
	if_z waitxrl
	if_nc_or_z waitxrl
	if_c waitxrl
	if_c_or_nz waitxrl
	if_c_or_z waitxrl
	waitxrl
	_ret_ waitxrl wc
	_ret_ waitxrl wz
	_ret_ waitxrl wcz


' CHECK: _ret_ waitxrl ' encoding: [0x24,0x3a,0x60,0x0d]
' CHECK-INST: _ret_ waitxrl


' CHECK: if_nc_and_nz waitxrl ' encoding: [0x24,0x3a,0x60,0x1d]
' CHECK-INST: if_nc_and_nz waitxrl


' CHECK: if_nc_and_z waitxrl ' encoding: [0x24,0x3a,0x60,0x2d]
' CHECK-INST: if_nc_and_z waitxrl


' CHECK: if_nc waitxrl ' encoding: [0x24,0x3a,0x60,0x3d]
' CHECK-INST: if_nc waitxrl


' CHECK: if_c_and_nz waitxrl ' encoding: [0x24,0x3a,0x60,0x4d]
' CHECK-INST: if_c_and_nz waitxrl


' CHECK: if_nz waitxrl ' encoding: [0x24,0x3a,0x60,0x5d]
' CHECK-INST: if_nz waitxrl


' CHECK: if_c_ne_z waitxrl ' encoding: [0x24,0x3a,0x60,0x6d]
' CHECK-INST: if_c_ne_z waitxrl


' CHECK: if_nc_or_nz waitxrl ' encoding: [0x24,0x3a,0x60,0x7d]
' CHECK-INST: if_nc_or_nz waitxrl


' CHECK: if_c_and_z waitxrl ' encoding: [0x24,0x3a,0x60,0x8d]
' CHECK-INST: if_c_and_z waitxrl


' CHECK: if_c_eq_z waitxrl ' encoding: [0x24,0x3a,0x60,0x9d]
' CHECK-INST: if_c_eq_z waitxrl


' CHECK: if_z waitxrl ' encoding: [0x24,0x3a,0x60,0xad]
' CHECK-INST: if_z waitxrl


' CHECK: if_nc_or_z waitxrl ' encoding: [0x24,0x3a,0x60,0xbd]
' CHECK-INST: if_nc_or_z waitxrl


' CHECK: if_c waitxrl ' encoding: [0x24,0x3a,0x60,0xcd]
' CHECK-INST: if_c waitxrl


' CHECK: if_c_or_nz waitxrl ' encoding: [0x24,0x3a,0x60,0xdd]
' CHECK-INST: if_c_or_nz waitxrl


' CHECK: if_c_or_z waitxrl ' encoding: [0x24,0x3a,0x60,0xed]
' CHECK-INST: if_c_or_z waitxrl


' CHECK: waitxrl ' encoding: [0x24,0x3a,0x60,0xfd]
' CHECK-INST: waitxrl


' CHECK: _ret_ waitxrl wc ' encoding: [0x24,0x3a,0x70,0x0d]
' CHECK-INST: _ret_ waitxrl wc


' CHECK: _ret_ waitxrl wz ' encoding: [0x24,0x3a,0x68,0x0d]
' CHECK-INST: _ret_ waitxrl wz


' CHECK: _ret_ waitxrl wcz ' encoding: [0x24,0x3a,0x78,0x0d]
' CHECK-INST: _ret_ waitxrl wcz


