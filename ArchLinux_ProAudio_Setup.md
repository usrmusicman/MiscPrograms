 # Arch Linux Pro Audio Setup Guide

This document outlines the configuration for a high-performance Linux audio workstation capable of stable 48-sample buffers at 48kHz, specifically optimized for the Focusrite Scarlett 2i2, Nvidia/AMD GPUs, and Wine+Yabridge environments.
Archlinux_Proaudio_Setup.md

## Advanced Kernel Boot Parameters

Add these to your bootloader (GRUB/systemd-boot). These parameters harden the kernel against jitter and power-saving interruptions.

| Parameter | Purpose |
| -- | -- |
| processor.max_cstate=1 | Disables deep CPU sleep states. This ensures the CPU is always "awake" and ready to process a buffer in under 1ms. |
| preempt=full: | Forces the kernel to be fully preemptible. This allows high-priority audio tasks to "cut in line" ahead of almost any other kernel process. |
| skew_tick=1 | Offsets the system "tick" on different CPUs to prevent them from all firing at once, which can cause micro-jitter in high-load audio sessions. |
| transparent_hugepage=never | Prevents the kernel from trying to group memory into "Huge Pages." While good for databases, the background "defragging" of these pages causes unpredictable CPU spikes (Xruns) in DAWs. |
| threadirqs | Essential for rtirq. It turns hardware interrupts into manageable threads. |
| usbcore.autosuspend=-1 | Prevents the kernel from ever putting USB ports to sleep. This keeps the Scarlett 2i2's connection "hot" and prevents sync-loss clicks. |
    
## Hardware Module Configurations (/etc/modprobe.d/)

To make these persistent, create separate .conf files for each.

### NVMe Optimization

Create the configuration file: /etc/modprobe.d/nvme.conf

	options nvme poll_queues=4

Why: This enables "polling" mode for your SSD. Instead of waiting for an interrupt (which can be delayed), the CPU actively checks the drive.

!! Important Note !!

This drastically speeds up loading massive sample libraries and recording high track counts.

### USB Audio Logic

Create the configuration file: /etc/modprobe.d/audio.conf

	options snd-usb-audio implicit_fb=1

Why: Enables "Implicit Feedback." This synchronizes the playback clock of your Scarlett 2i2 with the capture clock more accurately, reducing clock drift jitter.
    
### Configuring rtirq

**Setting up rtirq**

To enable the rtirq service enter this command as the root user:

	systemctl enable rtirq.service
	systemctl enable rtirq-resume.service

To start the rtirq service enter this command as the root user:

	systemctl start rtirq.service
	systemctl start rtirq-resume.service

**Finding your IRQs**

Use this command to see which IRQ thread belongs to your USB Audio Device:

	lsusb -t

Look for the 'Class=root_hub' device and note the bus/driver (usually xhci_hcd)
	
	/usr/bin/rtirq status

**Setting the Priority**

Edit the file: /etc/conf.d/rtirq (or /etc/default/rtirq)

Edit the RTIRQ_NAME_LIST variable to ensure usb or the specific driver is first or leftmost inside the ""

	sudo rtirq restart

Verification: Run rtirq status again. You should see your USB controller threads moved to Priority 90-95.

!! Important Note !!

This ensures the Scarlett 2i2 USB bus (xhci_hcd) is processed before background hardware like Ethernet or Wifi.

## Advanded Optimization

**Set all cores to max speed**

CPU set to performance to improve responsiveness

	echo "performance" | sudo tee /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor

**GPU Power Management**

Nvidia: Lock to Maximum Performance

	nvidia-settings -a "[gpu:0]/GPUPowerMizerMode=1"

AMD: Lock to Maximum Performance

	echo "high" | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level


**CPU Schedule Tuning (scxctl)**

Using the BPF extensible scheduler allows for "LAVD," which is purpose-built for low-latency audio.

Start the LAVD scheduler with a low-latency profile

	scxctl start --sched lavd --mode lowlatency

Switch to the LAVD scheduler with a low-latency profile (Only use if the scheduler control is already running)

	scxctl switch --sched lavd --mode lowlatency

Stop scxctl scheduler control

	scxctl stop

## Audio Server & MIDI Tuning

### Force Quantum (Buffer) and Rate

**PipeWire Global Metadata**

Force the entire audio graph to stay at 48 samples. This prevents PipeWire from trying to "negotiate" larger buffers for background apps.

	pw-metadata -n settings 0 clock.force-quantum 48
	pw-metadata -n settings 0 clock.force-rate 48000

**MIDI High-Resolution Timers**

Modern Linux uses hrtimer for nanosecond precision. The old 3072Hz RTC hacks are no longer necessary.

Verify the High-Res timer is loaded

	sudo modprobe snd_hrtimer

Check for "1ns" resolution

	cat /proc/asound/timers | grep "HR timer" -A 1

**Wine & Yabridge Performance**

To get "triple the synths" on Linux vs Windows, use these environment variables when launching your DAW.

   	WINEFSYNC=1: Uses fast kernel-level synchronization.
    PIPEWIRE_LATENCY="48/48000": # Tells the Wine client exactly what buffer to initialize, preventing "resync" clicks at startup.
	export PIPEWIRE_LATENCY="48/48000" Exports the environment variable for current and child bash processes
	
	WINEFSYNC=1 pw-jack /path/to/your/DAW

**Diagnostic Toolkit**

| Command | Purpose |
| -- | -- |
| pw-top | View real-time Xruns (errors) and DSP load per plugin. |
"watch -n 1 ""grep \""cpu MHz\"" /proc/cpuinfo""" |  Verify CPU is locked at max frequency. |
| "ps -eLo rtprio,cls,comm \| grep yabridge" | Verify Windows plugins are running with RT priority. |
vmstat 1 | Monitor cs (context switches) to see scheduler efficiency. |

**Permissions (Sudoers)**

Add this to /etc/sudoers (via sudo visudo) to allow the control script to function without password prompts:

	%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor, /usr/bin/rtirq, /usr/bin/nvidia-settings, /usr/bin/modprobe snd_hrtimer, /usr/bin/scxctl

## Verification Checklist
1. **Implicit Feedback:** `cat /sys/module/snd_usb_audio/parameters/implicit_fb` (Look for at least one 'Y').
2. **NVMe Polling:** `cat /sys/module/nvme/parameters/poll_queues` (Should return 4).
3. **CPU Governor:** `cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor` (Should be 'performance' when DAW is open).
4. **IRQ Priority:** `rtirq status` (Ensure `xhci_hcd` or `usb` is Priority 90+).
