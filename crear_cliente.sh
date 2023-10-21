#!/bin/bash

# Verifica que se proporcionen argumentos
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 NOMBRE_CLIENTE TAMAÑO_VOLUMEN RED"
    exit 1
fi

# Variables
nombremaquina="$1"
tamadisco="$2"
nombrered="$3"

# Plantilla

# Línea de creación del disco enlazado

echo "Creando disco enlazado"

virsh -c qemu:///system vol-create-as default $nombremaquina.qcow2 $tamadisco --format qcow2 --backing-vol plantilla-cliente.qcow2 --backing-vol-format qcow2

# Creación de máquina

echo "Creando maquina"

virt-install --connect qemu:///system \
             --noautoconsole \
			 --virt-type kvm \
			 --name $nombremaquina \
			 --os-variant debian10 \
			 --disk path=/var/lib/libvirt/images/$nombremaquina.qcow2 \
			 --memory 1024 \
			 --vcpus 1 \
			 --import

# Conexión a la máquina

echo "Conectando a máquina"

virt-viewer -c qemu:///system $nombremaquina