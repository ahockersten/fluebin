set -euo pipefail

# Full magic SysRq for emergency recovery.
echo "kernel.sysrq=244" > /etc/sysctl.d/99-sysrq.conf
