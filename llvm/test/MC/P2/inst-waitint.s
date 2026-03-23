
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ waitint
	if_nc_and_nz waitint
	if_nc_and_z waitint
	if_nc waitint
	if_c_and_nz waitint
	if_nz waitint
	if_c_ne_z waitint
	if_nc_or_nz waitint
	if_c_and_z waitint
	if_c_eq_z waitint
	if_z waitint
	if_nc_or_z waitint
	if_c waitint
	if_c_or_nz waitint
	if_c_or_z waitint
	waitint
	_ret_ waitint wc
	_ret_ waitint wz
	_ret_ waitint wcz


' CHECK: _ret_ waitint ' encoding: [0x24,0x20,0x60,0x0d]
' CHECK-INST: _ret_ waitint


' CHECK: if_nc_and_nz waitint ' encoding: [0x24,0x20,0x60,0x1d]
' CHECK-INST: if_nc_and_nz waitint


' CHECK: if_nc_and_z waitint ' encoding: [0x24,0x20,0x60,0x2d]
' CHECK-INST: if_nc_and_z waitint


' CHECK: if_nc waitint ' encoding: [0x24,0x20,0x60,0x3d]
' CHECK-INST: if_nc waitint


' CHECK: if_c_and_nz waitint ' encoding: [0x24,0x20,0x60,0x4d]
' CHECK-INST: if_c_and_nz waitint


' CHECK: if_nz waitint ' encoding: [0x24,0x20,0x60,0x5d]
' CHECK-INST: if_nz waitint


' CHECK: if_c_ne_z waitint ' encoding: [0x24,0x20,0x60,0x6d]
' CHECK-INST: if_c_ne_z waitint


' CHECK: if_nc_or_nz waitint ' encoding: [0x24,0x20,0x60,0x7d]
' CHECK-INST: if_nc_or_nz waitint


' CHECK: if_c_and_z waitint ' encoding: [0x24,0x20,0x60,0x8d]
' CHECK-INST: if_c_and_z waitint


' CHECK: if_c_eq_z waitint ' encoding: [0x24,0x20,0x60,0x9d]
' CHECK-INST: if_c_eq_z waitint


' CHECK: if_z waitint ' encoding: [0x24,0x20,0x60,0xad]
' CHECK-INST: if_z waitint


' CHECK: if_nc_or_z waitint ' encoding: [0x24,0x20,0x60,0xbd]
' CHECK-INST: if_nc_or_z waitint


' CHECK: if_c waitint ' encoding: [0x24,0x20,0x60,0xcd]
' CHECK-INST: if_c waitint


' CHECK: if_c_or_nz waitint ' encoding: [0x24,0x20,0x60,0xdd]
' CHECK-INST: if_c_or_nz waitint


' CHECK: if_c_or_z waitint ' encoding: [0x24,0x20,0x60,0xed]
' CHECK-INST: if_c_or_z waitint


' CHECK: waitint ' encoding: [0x24,0x20,0x60,0xfd]
' CHECK-INST: waitint


' CHECK: _ret_ waitint wc ' encoding: [0x24,0x20,0x70,0x0d]
' CHECK-INST: _ret_ waitint wc


' CHECK: _ret_ waitint wz ' encoding: [0x24,0x20,0x68,0x0d]
' CHECK-INST: _ret_ waitint wz


' CHECK: _ret_ waitint wcz ' encoding: [0x24,0x20,0x78,0x0d]
' CHECK-INST: _ret_ waitint wcz


