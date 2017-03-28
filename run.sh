#!/bin/ksh
# ���������� �������� SD-��������
sdcard=`ls /mnt|grep sdcard.*t`

# ������ ���� � SD-�����
SDPath=/mnt/$sdcard

# �������� ������ ������ � SD-�����
mount -u $SDPath

# ����� �������� ������ �������
$SDPath/utils/showScreen $SDPath/screens/scriptStart.png

# ������� ���� .done (���� ����� ������� �� �������� � �������� ����)
rm -f  $SDPath/.done

# ������� ���� .started (����, ��� ������ �������)
echo started > $SDPath/.started

# �������� ������ ������ � EFS
mount -uw /mnt/efs-persist

#�������� �� �������� ��������� ����� ���� ������ 
cp -v -r /mnt/efs-persist/DataPST.db $SDPath/db/efs-persist/old/
cp -v -r /HBpersistence/DataPST.db $SDPath/db/HBpersistence/old/
cp -v -r /mnt/hmisql/DataPST.db $SDPath/db/hmisql/old/

#������� ��������� ������
$SDPath/utils/sqlite3 /mnt/efs-persist/DataPST.db " delete from tb_intvalues where pst_key=4100 and pst_namespace=4"
$SDPath/utils/sqlite3 /HBpersistence/DataPST.db " delete from tb_intvalues where pst_key=4100 and pst_namespace=4"
$SDPath/utils/sqlite3 /mnt/hmisql/DataPST.db " delete from tb_intvalues where pst_key=4100 and pst_namespace=4"

#�������� �� �������� ���������� ���� ���� ������ 
cp -v -r /mnt/efs-persist/DataPST.db $SDPath/db/efs-persist/process/
cp -v -r /HBpersistence/DataPST.db $SDPath/db/HBpersistence/process/
cp -v -r /mnt/hmisql/DataPST.db $SDPath/db/hmisql/process/

#��������� ����� ������. ���� ����� "(4,4100,1)" �������� �� "(4,4100,0)", �� ������ ������� �������� ����������� ����������� ����
$SDPath/utils/sqlite3 /mnt/efs-persist/DataPST.db "insert into tb_intvalues (pst_namespace, pst_key, pst_value) values (4,4100,1)"
$SDPath/utils/sqlite3 /HBpersistence/DataPST.db "insert into tb_intvalues (pst_namespace, pst_key, pst_value) values (4,4100,1)"
$SDPath/utils/sqlite3 /mnt/hmisql/DataPST.db "insert into tb_intvalues (pst_namespace, pst_key, pst_value) values (4,4100,1)"

#�������� �� �������� ���������� ���� ���� ������ 
cp -v -r /mnt/efs-persist/DataPST.db $SDPath/db/efs-persist/new/
cp -v -r /HBpersistence/DataPST.db $SDPath/db/HBpersistence/new/
cp -v -r /mnt/hmisql/DataPST.db $SDPath/db/hmisql/new/

# ����� �������� ��������� ������ �������
$SDPath/utils/showScreen $SDPath/screens/scriptDone.png

# ������� ���� .done (����, ��� ������ ���������)
echo done > $SDPath/.done

# ������� ���� .started (������ ��������� �� �����)
rm -f  $SDPath/.started