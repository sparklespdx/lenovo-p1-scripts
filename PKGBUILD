# Maintainer: Felix Yan <felixonmars@archlinux.org>
# Contributor: Kenneth Endfinger <kaendfinger@gmail.com>

pkgname=lenovo-p1-scripts
pkgver=0.1
pkgrel=1
pkgdesc="Scripts for Lenovo P1. Includes throttled 0.6: https://github.com/erpalma/throttled"

arch=('any')
url="https://github.com/erpalma/throttled"
license=('MIT')
depends=('python-dbus' 'python-psutil' 'python-gobject' 'cpupower' 'bluez')
conflicts=('throttled' 'lenovo-throttling-fix-git' 'lenovo-throttling-fix')
replaces=('throttled' 'lenovo-throttling-fix')
backup=('etc/lenovo_fix.conf')

source=("throttled-0.6.tar.gz::https://github.com/erpalma/throttled/archive/v0.6.tar.gz"
        gpuwrap.sh
        gpu-module-load.conf
        gpu-modprobe-nvidia.conf
        gpu-modprobe-nouveau.conf
        hotkeys.service
        hotkeys.sh
        lenovo_fix_powersave.conf
        lenovo_fix_performance.conf
        modprobe-thinkpad_acpi.conf)

sha256sums=('93d11b78d35b99ce345e41291f0268e4c21d0ccb2a80922839e51ec2fe3ae0c1'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP')

prepare() {
  # Copy default config into two places and tweak for hotkeys selector
  cp throttled-0.6/systemd/lenovo_fix.service throttled-0.6/systemd/lenovo_fix_performance.service
  cp throttled-0.6/systemd/lenovo_fix.service throttled-0.6/systemd/lenovo_fix_powersave.service

  sed -i "s|ExecStart=.*|ExecStart=/usr/lib/$pkgname/lenovo_fix.py --config /etc/lenovo_fix/performance.conf |" throttled-0.6/systemd/lenovo_fix_performance.service
  sed -i "s|Description=Stop Intel throttling|Description=Stop Intel throttling\nConflicts=lenovo_fix_powersave.service |" throttled-0.6/systemd/lenovo_fix_performance.service

  sed -i "s|ExecStart=.*|ExecStart=/usr/lib/$pkgname/lenovo_fix.py --config /etc/lenovo_fix/powersave.conf|" throttled-0.6/systemd/lenovo_fix_powersave.service
  sed -i "s|Description=Stop Intel throttling|Description=Stop Intel throttling\nConflicts=lenovo_fix_performance.service |" throttled-0.6/systemd/lenovo_fix_powersave.service
}

build() {
  cd throttled-0.6
  python -m compileall *.py
}

package() {
  # GPU
  install -Dm755 gpuwrap.sh "$pkgdir"/usr/bin/gpuwrap.sh
  install -Dm644 gpu-module-load.conf "$pkgdir"/etc/modules-load.d/nvidia.conf
  install -Dm644 gpu-modprobe-nvidia.conf "$pkgdir"/etc/modprobe.d/nvidia.conf
  install -Dm644 gpu-modprobe-nouveau.conf "$pkgdir"/etc/modprobe.d/nouveau.conf

  # Hotkeys
  install -Dm644 hotkeys.service "$pkgdir"/usr/lib/systemd/system/hotkeys.service
  install -Dm755 hotkeys.sh "$pkgdir"/usr/bin/hotkeys.sh

  # Thermal Fixes
  install -Dm644 lenovo_fix_performance.conf "$pkgdir"/etc/lenovo_fix/performance.conf
  install -Dm644 lenovo_fix_powersave.conf "$pkgdir"/etc/lenovo_fix/powersave.conf
  install -Dm644 modprobe-thinkpad_acpi.conf "$pkgdir"/etc/modprobe.d/thinkpad_acpi.conf

  # throttled
  cd throttled-0.6
  install -Dm644 systemd/lenovo_fix_performance.service "$pkgdir"/usr/lib/systemd/system/lenovo_fix_performance.service
  install -Dm644 systemd/lenovo_fix_powersave.service "$pkgdir"/usr/lib/systemd/system/lenovo_fix_powersave.service
  install -Dm755 lenovo_fix.py "$pkgdir"/usr/lib/$pkgname/lenovo_fix.py
  install -Dm755 mmio.py "$pkgdir"/usr/lib/$pkgname/mmio.py
  cp -a __pycache__ "$pkgdir"/usr/lib/$pkgname/
  install -Dm644 LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}

# vim:set ts=2 sw=2 et:
