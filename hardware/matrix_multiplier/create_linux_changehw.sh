#!/bin/bash -x

# ===================================================================================
# usage: create_linux_system.sh [sdcard_device]
#
# positional arguments:
#     sdcard_device    path to sdcard device file    [ex: "/dev/sdb", "/dev/mmcblk0"]
# ===================================================================================

# make sure to be in the same directory as this script
script_dir_abs=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "${script_dir_abs}"

# constants ####################################################################
quartus_dir="$(readlink -m "hw/quartus")"
quartus_project_name="$(basename "$(find "${quartus_dir}" -name "*.qpf")" .qpf)"
quartus_sof_file="$(readlink -m "${quartus_dir}/output_files/${quartus_project_name}.sof")"
quartus_sopcinfo_file="$(readlink -m "${quartus_dir}/soc_system.sopcinfo")"
hps_dir="$(readlink -m "sw/hps")"
hps_header_file="$(readlink -m "${hps_dir}/application/hps_soc_system.h")"

fpga_device_part_number="5CSEMA5F31C6" # 5CSEMA4U23C6

preloader_dir="$(readlink -m "sw/hps/preloader")"
preloader_settings_dir="$(readlink -m "${quartus_dir}/hps_isw_handoff/soc_system_hps_0")"
preloader_settings_file="$(readlink -m "${preloader_dir}/settings.bsp")"
preloader_source_tgz_file="$(readlink -m "${SOCEDS_DEST_ROOT}/host_tools/altera/preloader/uboot-socfpga.tar.gz")"
preloader_bin_file="${preloader_dir}/preloader-mkpimage.bin"

uboot_src_dir="$(readlink -m "sw/hps/u-boot")"
uboot_src_git_repo="git://git.denx.de/u-boot.git"
uboot_src_git_checkout_commit="b104b3dc1dd90cdbf67ccf3c51b06e4f1592fe91"
uboot_src_make_config_file="socfpga_cyclone5_config" # socfpga_de0_nano_soc_defconfig
uboot_src_config_file="${uboot_src_dir}/include/configs/socfpga_cyclone5_socdk.h" # socfpga_de0_nano_soc.h
uboot_script_file="$(readlink -m "${uboot_src_dir}/u-boot.script")"
uboot_img_file="$(readlink -m "${uboot_src_dir}/u-boot.img")"

linux_dir="$(readlink -m "sw/hps/linux")"
linux_src_git_repo="https://github.com/altera-opensource/linux-socfpga.git"
linux_src_dir="$(readlink -m "${linux_dir}/source")"
linux_src_git_checkout_commit="9735a22799b9214d17d3c231fe377fc852f042e9"
linux_src_make_config_file="socfpga_defconfig"
linux_kernel_mem_arg="1024M"
linux_zImage_file="$(readlink -m "${linux_src_dir}/arch/arm/boot/zImage")"
linux_dtb_file="$(readlink -m "${linux_src_dir}/arch/arm/boot/dts/socfpga_cyclone5_socdk.dtb")" # socfpga_cyclone5_de0_sockit.dtb

rootfs_dir="${linux_dir}/rootfs"
rootfs_chroot_dir="$(readlink -m ${rootfs_dir}/ubuntu-core-rootfs)"
rootfs_src_tgz_link="http://cdimage.ubuntu.com/ubuntu-base/releases/14.04.5/release/ubuntu-base-14.04.5-base-armhf.tar.gz"
rootfs_src_tgz_file="$(readlink -m "${rootfs_dir}/${rootfs_src_tgz_link##*/}")"
rootfs_system_config_script_file="${rootfs_dir}/config_system.sh"
rootfs_post_install_config_script_file="${rootfs_dir}/config_post_install.sh"

sdcard_fat32_dir="$(readlink -m "sdcard/fat32")"
sdcard_fat32_rbf_file="$(readlink -m "${sdcard_fat32_dir}/socfpga.rbf")"
sdcard_fat32_uboot_img_file="$(readlink -m "${sdcard_fat32_dir}/$(basename "${uboot_img_file}")")"
sdcard_fat32_uboot_scr_file="$(readlink -m "${sdcard_fat32_dir}/u-boot.scr")"
sdcard_fat32_zImage_file="$(readlink -m "${sdcard_fat32_dir}/zImage")"
sdcard_fat32_dtb_file="$(readlink -m "${sdcard_fat32_dir}/socfpga.dtb")"

#sdcard_dev="$(readlink -m "${1}")"
sdcard_dev="/dev/sdb"

sdcard_ext3_rootfs_tgz_file="$(readlink -m "sdcard/ext3_rootfs.tar.gz")"

sdcard_a2_dir="$(readlink -m "sdcard/a2")"
sdcard_a2_preloader_bin_file="$(readlink -m "${sdcard_a2_dir}/$(basename "${preloader_bin_file}")")"

#sdcard_partition_size_fat32="64M"
#sdcard_partition_size_linux="30000M"
sdcard_partition_size_fat32="+512M"
sdcard_partition_size_linux="+53400M"

sdcard_partition_number_fat32="1"
sdcard_partition_number_ext3="2"
sdcard_partition_number_a2="3"

if [ "$(echo "${sdcard_dev}" | grep -P "/dev/sd\w.*$")" ]; then
    sdcard_dev_fat32_id="${sdcard_partition_number_fat32}"
    sdcard_dev_ext3_id="${sdcard_partition_number_ext3}"
    sdcard_dev_a2_id="${sdcard_partition_number_a2}"
elif [ "$(echo "${sdcard_dev}" | grep -P "/dev/sda\w.*$")" ]; then
    sdcard_dev_fat32_id="p${sdcard_partition_number_fat32}"
    sdcard_dev_ext3_id="p${sdcard_partition_number_ext3}"
    sdcard_dev_a2_id="p${sdcard_partition_number_a2}"
fi

sdcard_dev_fat32="${sdcard_dev}${sdcard_dev_fat32_id}"
sdcard_dev_ext3="${sdcard_dev}${sdcard_dev_ext3_id}"
sdcard_dev_a2="${sdcard_dev}${sdcard_dev_a2_id}"
sdcard_dev_fat32_mount_point="$(readlink -m "sdcard/mount_point_fat32")"
sdcard_dev_ext3_mount_point="$(readlink -m "sdcard/mount_point_ext3")"

# compile_preloader() ##########################################################
compile_preloader() {
    # delete old artifacts
    if test -f "${sdcard_fat32_rbf_file}"; then
        rm "${sdcard_fat32_rbf_file}"
    fi
    rm -rf  "${preloader_dir}" \
            "${sdcard_a2_preloader_bin_file}"

    # Convert file .sof to .rbf
    quartus_cpf -c "${quartus_sof_file}" "${sdcard_fat32_rbf_file}" 

    # create directory for preloader
    mkdir -p "${preloader_dir}"

    # change working directory to preloader directory
    pushd "${preloader_dir}"

    # create bsp settings file
    bsp-create-settings \
    --bsp-dir "${preloader_dir}" \
    --preloader-settings-dir "${preloader_settings_dir}" \
    --settings "${preloader_settings_file}" \
    --type spl \
    --set spl.CROSS_COMPILE "arm-altera-eabi-" \
    --set spl.PRELOADER_TGZ "${preloader_source_tgz_file}" \
    --set spl.boot.BOOTROM_HANDSHAKE_CFGIO "1" \
    --set spl.boot.BOOT_FROM_NAND "0" \
    --set spl.boot.BOOT_FROM_QSPI "0" \
    --set spl.boot.BOOT_FROM_RAM "0" \
    --set spl.boot.BOOT_FROM_SDMMC "1" \
    --set spl.boot.CHECKSUM_NEXT_IMAGE "1" \
    --set spl.boot.EXE_ON_FPGA "0" \
    --set spl.boot.FAT_BOOT_PARTITION "1" \
    --set spl.boot.FAT_LOAD_PAYLOAD_NAME "$(basename "${uboot_img_file}")" \
    --set spl.boot.FAT_SUPPORT "1" \
    --set spl.boot.FPGA_DATA_BASE "0xffff0000" \
    --set spl.boot.FPGA_DATA_MAX_SIZE "0x10000" \
    --set spl.boot.FPGA_MAX_SIZE "0x10000" \
    --set spl.boot.NAND_NEXT_BOOT_IMAGE "0xc0000" \
    --set spl.boot.QSPI_NEXT_BOOT_IMAGE "0x60000" \
    --set spl.boot.RAMBOOT_PLLRESET "1" \
    --set spl.boot.SDMMC_NEXT_BOOT_IMAGE "0x40000" \
    --set spl.boot.SDRAM_SCRUBBING "0" \
    --set spl.boot.SDRAM_SCRUB_BOOT_REGION_END "0x2000000" \
    --set spl.boot.SDRAM_SCRUB_BOOT_REGION_START "0x1000000" \
    --set spl.boot.SDRAM_SCRUB_REMAIN_REGION "1" \
    --set spl.boot.STATE_REG_ENABLE "1" \
    --set spl.boot.WARMRST_SKIP_CFGIO "1" \
    --set spl.boot.WATCHDOG_ENABLE "1" \
    --set spl.debug.DEBUG_MEMORY_ADDR "0xfffffd00" \
    --set spl.debug.DEBUG_MEMORY_SIZE "0x200" \
    --set spl.debug.DEBUG_MEMORY_WRITE "0" \
    --set spl.debug.HARDWARE_DIAGNOSTIC "0" \
    --set spl.debug.SEMIHOSTING "0" \
    --set spl.debug.SKIP_SDRAM "0" \
    --set spl.performance.SERIAL_SUPPORT "1" \
    --set spl.reset_assert.DMA "0" \
    --set spl.reset_assert.GPIO0 "0" \
    --set spl.reset_assert.GPIO1 "0" \
    --set spl.reset_assert.GPIO2 "0" \
    --set spl.reset_assert.L4WD1 "0" \
    --set spl.reset_assert.OSC1TIMER1 "0" \
    --set spl.reset_assert.SDR "0" \
    --set spl.reset_assert.SPTIMER0 "0" \
    --set spl.reset_assert.SPTIMER1 "0" \
    --set spl.warm_reset_handshake.ETR "1" \
    --set spl.warm_reset_handshake.FPGA "1" \
    --set spl.warm_reset_handshake.SDRAM "0"

    # generate bsp
    bsp-generate-files \
    --bsp-dir "${preloader_dir}" \
    --settings "${preloader_settings_file}"

    # compile preloader
    make -j4

    # copy artifacts to associated sdcard directory
    cp "${preloader_bin_file}" "${sdcard_a2_preloader_bin_file}"

    # change working directory back to script directory
    popd
} # end compile_preloader

generate_header(){
    # delete old artifacts
    if test -f "${hps_header_file}"; then
        rm "${hps_header_file}"
    fi
    sopc-create-header-files "${quartus_sopcinfo_file}" --single "${hps_header_file}" --module hps_0
} # generate_header

# partition_sdcard() ###########################################################
partition_sdcard() {
    # manually partitioning the sdcard for 64MB 
        # sudo fdisk /dev/sdx
            # use the following commands
            # n p 3 <default> 4095  t   a2 (2048 is default first sector)
            # n p 1 <default> +5000M  t 1  b (4096 is default first sector)
            # n p 2 <default> +55000M t 2 83 (69632 is default first sector)
            # w
        # result
            # Device     Boot Start     End Sectors  Size Id Type
            # /dev/sdb1        4096   69631   65536   32M  b W95 FAT32
            # /dev/sdb2       69632 1118207 1048576  512M 83 Linux
            # /dev/sdb3        2048    4095    2048    1M a2 unknown
        # note that you can choose any size for the FAT32 and Linux partitions,
        # but the a2 partition must be 1M.

    # automatically partitioning the sdcard
    # wipe partition table
    sudo dd if="/dev/zero" of="${sdcard_dev}" bs=512 count=1

    # create partitions
    # no need to specify the partition number for the first invocation of
    # the "t" command in fdisk, because there is only 1 partition at this
    # point
    echo -e "n\np\n3\n\n4095\nt\na2\nn\np\n1\n\n+${sdcard_partition_size_fat32}\nt\n1\nb\nn\np\n2\n\n+${sdcard_partition_size_linux}\nt\n2\n83\nw\nq\n" | sudo fdisk "${sdcard_dev}"

    # create filesystems
    sudo mkfs.vfat "${sdcard_dev_fat32}"
    sudo mkfs.ext3 -F "${sdcard_dev_ext3}"
}

# write_sdcard() ###############################################################
write_sdcard() {
    # create mount point for sdcard
    mkdir -p "${sdcard_dev_fat32_mount_point}"
    #mkdir -p "${sdcard_dev_ext3_mount_point}"

    # mount sdcard partitions
    sudo mount "${sdcard_dev_fat32}" "${sdcard_dev_fat32_mount_point}"
    #sudo mount "${sdcard_dev_ext3}" "${sdcard_dev_ext3_mount_point}"

    # preloader
    sudo dd if="${sdcard_a2_preloader_bin_file}" of="${sdcard_dev_a2}" bs=64K seek=0

    # fpga .rbf, uboot .img, uboot .scr, linux zImage, linux .dtb
    sudo cp "${sdcard_fat32_dir}"/* "${sdcard_dev_fat32_mount_point}"

    # linux rootfs
    #pushd "${sdcard_dev_ext3_mount_point}"
    #sudo tar -xzf "${sdcard_ext3_rootfs_tgz_file}"
    #popd

    # flush write buffers to target
    sudo sync

    # unmount sdcard partitions
    sudo umount "${sdcard_dev_fat32_mount_point}"
    #sudo umount "${sdcard_dev_ext3_mount_point}"

    # delete mount points for sdcard
    rm -rf "${sdcard_dev_fat32_mount_point}"
    #rm -rf "${sdcard_dev_ext3_mount_point}"
}

# Script execution #############################################################

# Report script line number on any error (non-zero exit code).
trap 'echo "Error on line ${LINENO}" 1>&2' ERR
set -e

# Create sdcard output directories
#mkdir -p "${sdcard_a2_dir}"
#mkdir -p "${sdcard_fat32_dir}" 

compile_preloader
generate_header


#Write sdcard if it exists
if [ -z "${sdcard_dev}" ]; then
     echo "sdcard argument not provided => no sdcard written."

 elif [ -b "${sdcard_dev}" ]; then
     #partition_sdcard
     write_sdcard
 fi

# Make sure MSEL = 000000
