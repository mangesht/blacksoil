#!/usr/bin/sh
old_f=upsAgsIgrStrpIPsecAhTunn.sv
new_f=agsL3IgrStrpIPsecAhTunn.sv
echo "my file $old_f"
echo $new_f
cvs add $new_f
cvs ci -m "replacing old file $old_f" $new_f 
rm -f $old_f
cvs remove $old_f
cvs ci -m " replaced with $new_f" $old_f
