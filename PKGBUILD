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
        hotkeys.service
        hotkeys.sh
        lenovo_fix_powersave.conf
        lenovo_fix_performance.conf)

sha256sums=('93d11b78d35b99ce345e41291f0268e4c21d0ccb2a80922839e51ec2fe3ae0c1'
            '2666d74c05f9564ed30fd0c83a451565dfb973ab2eecc7d8567bfdbaab824b54'
            'f5f28882361ed8500e0b6b991039d3d68f4492ec1e9c99ee06e0aa2143bda2f9'
            '82b2c67cdc28db232dbbfc4618be2f44e0dee4c5bc11c10e26585b71a39dcd05'
            '2be62065436f15ea0ce9e18c3b8572cbdfc4e009665af66c2033f748e7006f6e')

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
  install -Dm644 hotkeys.service "$pkgdir"/usr/lib/systemd/system/hotkeys.service
  install -Dm755 hotkeys.sh "$pkgdir"/usr/bin/hotkeys.sh

  install -Dm644 lenovo_fix_performance.conf "$pkgdir"/etc/lenovo_fix/performance.conf
  install -Dm644 lenovo_fix_powersave.conf "$pkgdir"/etc/lenovo_fix/powersave.conf

  cd throttled-0.6
  install -Dm644 systemd/lenovo_fix_performance.service "$pkgdir"/usr/lib/systemd/system/lenovo_fix_performance.service
  install -Dm644 systemd/lenovo_fix_powersave.service "$pkgdir"/usr/lib/systemd/system/lenovo_fix_powersave.service
  install -Dm755 lenovo_fix.py "$pkgdir"/usr/lib/$pkgname/lenovo_fix.py
  install -Dm755 mmio.py "$pkgdir"/usr/lib/$pkgname/mmio.py
  cp -a __pycache__ "$pkgdir"/usr/lib/$pkgname/
  install -Dm644 LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}

# vim:set ts=2 sw=2 et:
