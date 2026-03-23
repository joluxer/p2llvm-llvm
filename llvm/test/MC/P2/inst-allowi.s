
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ allowi
	if_nc_and_nz allowi
	if_nc_and_z allowi
	if_nc allowi
	if_c_and_nz allowi
	if_nz allowi
	if_c_ne_z allowi
	if_nc_or_nz allowi
	if_c_and_z allowi
	if_c_eq_z allowi
	if_z allowi
	if_nc_or_z allowi
	if_c allowi
	if_c_or_nz allowi
	if_c_or_z allowi
	allowi
	_ret_ allowi wc
	_ret_ allowi wz
	_ret_ allowi wcz


' CHECK: _ret_ allowi ' encoding: [0x24,0x3e,0x60,0x0d]
' CHECK-INST: _ret_ allowi


' CHECK: if_nc_and_nz allowi ' encoding: [0x24,0x3e,0x60,0x1d]
' CHECK-INST: if_nc_and_nz allowi


' CHECK: if_nc_and_z allowi ' encoding: [0x24,0x3e,0x60,0x2d]
' CHECK-INST: if_nc_and_z allowi


' CHECK: if_nc allowi ' encoding: [0x24,0x3e,0x60,0x3d]
' CHECK-INST: if_nc allowi


' CHECK: if_c_and_nz allowi ' encoding: [0x24,0x3e,0x60,0x4d]
' CHECK-INST: if_c_and_nz allowi


' CHECK: if_nz allowi ' encoding: [0x24,0x3e,0x60,0x5d]
' CHECK-INST: if_nz allowi


' CHECK: if_c_ne_z allowi ' encoding: [0x24,0x3e,0x60,0x6d]
' CHECK-INST: if_c_ne_z allowi


' CHECK: if_nc_or_nz allowi ' encoding: [0x24,0x3e,0x60,0x7d]
' CHECK-INST: if_nc_or_nz allowi


' CHECK: if_c_and_z allowi ' encoding: [0x24,0x3e,0x60,0x8d]
' CHECK-INST: if_c_and_z allowi


' CHECK: if_c_eq_z allowi ' encoding: [0x24,0x3e,0x60,0x9d]
' CHECK-INST: if_c_eq_z allowi


' CHECK: if_z allowi ' encoding: [0x24,0x3e,0x60,0xad]
' CHECK-INST: if_z allowi


' CHECK: if_nc_or_z allowi ' encoding: [0x24,0x3e,0x60,0xbd]
' CHECK-INST: if_nc_or_z allowi


' CHECK: if_c allowi ' encoding: [0x24,0x3e,0x60,0xcd]
' CHECK-INST: if_c allowi


' CHECK: if_c_or_nz allowi ' encoding: [0x24,0x3e,0x60,0xdd]
' CHECK-INST: if_c_or_nz allowi


' CHECK: if_c_or_z allowi ' encoding: [0x24,0x3e,0x60,0xed]
' CHECK-INST: if_c_or_z allowi


' CHECK: allowi ' encoding: [0x24,0x3e,0x60,0xfd]
' CHECK-INST: allowi


' CHECK: _ret_ allowi wc ' encoding: [0x24,0x3e,0x70,0x0d]
' CHECK-INST: _ret_ allowi wc


' CHECK: _ret_ allowi wz ' encoding: [0x24,0x3e,0x68,0x0d]
' CHECK-INST: _ret_ allowi wz


' CHECK: _ret_ allowi wcz ' encoding: [0x24,0x3e,0x78,0x0d]
' CHECK-INST: _ret_ allowi wcz


