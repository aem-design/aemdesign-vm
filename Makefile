all: vmware qemu virtualbox

vmware:
	packer build -only=vmware-iso templates/rancheros-all.json

virtualbox:
	packer build -only=virtualbox-iso templates/rancheros-all.json

qemu:
	packer build -only=qemu templates/rancheros-all.json

clean:
	rm -fr build/output-vmware-iso/ build/output-virtualbox-iso/ build/output-qemu/

.PHONY: clean all